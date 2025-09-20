import pathlib
import a2kit
import deploy_pack as packer

fmt = {
    'woz': {
        'ext': 'woz',
        'typ': ['-t','woz2'],
    },
    'do': {
        'ext': 'do',
        'typ': ['-t','do'],
    },
    '2mg-do': {
        'ext': '2mg',
        'typ': ['-t','2mg','-w','do']
    },
    'nib': {
        'ext': 'nib',
        'typ': ['-t','nib'],
    },
    '2mg-nib': {
        'ext': '2mg',
        'typ': ['-t','2mg','-w','nib']
    }
}

def deploy(img_fmt: str, realm_path: pathlib.Path, distro_path: pathlib.Path, dos33: list[packer.PackedFile]):
    if img_fmt not in fmt:
        print('format must be in',fmt.keys())
        exit(1)
    mc_folder = realm_path / 'assembly'
    disk_path = (
        distro_path / ('realm-dos33-master.'+fmt[img_fmt]['ext']),
        distro_path / ('realm-dos33-dungeon.'+fmt[img_fmt]['ext']),
        distro_path / ('realm-dos33-monster.'+fmt[img_fmt]['ext']),
        distro_path / ('realm-dos33-setup.'+fmt[img_fmt]['ext'])
    )

    print('creating DOS 3.3',img_fmt,'images...')

    # Create the blank disk images, some bootable, some with noboot message
    mkdsk_args = ['mkdsk','-o','dos33','-v','254','-k','5.25in-apple-16'] + fmt[img_fmt]['typ']
    a2kit.cmd(mkdsk_args + ['-d',disk_path[0],'-b'])
    a2kit.cmd(mkdsk_args + ['-d',disk_path[1]])
    a2kit.cmd(mkdsk_args + ['-d',disk_path[2]])
    a2kit.cmd(mkdsk_args + ['-d',disk_path[3],'-b'])
    noboot_message = a2kit.cmd(['get','-f',mc_folder/'NOBOOT#060800'])
    a2kit.cmd(['put','-t','sec','-f','0,0,0','-d',disk_path[1]], noboot_message)
    a2kit.cmd(['put','-t','sec','-f','0,0,0','-d',disk_path[2]], noboot_message)

    # Deploy all the file images to all the disk images
    print("writing all files...")
    for idx in range(4):
        print("   disk",idx)
        fimg_list = "["
        for f in dos33:
            if idx in f['disks']:
                if fimg_list[-1] != "[":
                    fimg_list += ","
                fimg_list += f['fimg']
        fimg_list += "]"
        a2kit.cmd(['mput','-d',disk_path[idx]],fimg_list.encode('utf-8'))

    # Change greeting program to GUTEN TAG
    # (for old time's sake)
    block = list(a2kit.cmd(['get','-t','block','-f','25','-d',disk_path[0]]))
    for i,char in enumerate('GUTEN TAG'):
        block[0x75+i] = ord(char) + 128
    a2kit.cmd(['put','-t','block','-f','25','-d',disk_path[0]], bytes(block))
    a2kit.cmd(['put','-t','block','-f','25','-d',disk_path[3]], bytes(block))

if __name__ == "__main__":
    print("this is a module, do not run directly")