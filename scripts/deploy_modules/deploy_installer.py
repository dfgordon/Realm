import pathlib
import a2kit
import deploy_pack as packer

fmt = {
    'woz': {
        'ext': 'woz',
        'typ': ['-t','woz2'],
    },
    'nib': {
        'ext': 'nib',
        'typ': ['-t','nib'],
    },
    'do': {
        'ext': 'do',
        'typ': ['-t','do'],
    },
    'po': {
        'ext': 'po',
        'typ': ['-t','po'],
    },
    '2mg-do': {
        'ext': '2mg',
        'typ': ['-t','2mg','-w','do']
    },
    '2mg-po': {
        'ext': '2mg',
        'typ': ['-t','2mg','-w','po']
    },
    '2mg-nib': {
        'ext': '2mg',
        'typ': ['-t','2mg','-w','nib']
    }
}

def deploy(img_fmt: str, realm_path: pathlib.Path, distro_path: pathlib.Path, prodos: list[packer.PackedFile]):
    if img_fmt not in fmt:
        print('format must be in',fmt.keys())
        exit(1)
    fimg_folder = realm_path / 'file-images'
    bas_pro_folder = realm_path / 'basic-prodos'
    mc_folder = realm_path / 'assembly'

    disk_path = [
        distro_path / ('realm-install-1.' + fmt[img_fmt]['ext']),
        distro_path / ('realm-install-2.' + fmt[img_fmt]['ext']),
        distro_path / ('realm-install-3.' + fmt[img_fmt]['ext'])
    ]

    print("creating installer",img_fmt,"images...")

    # Create bootable 5.25 inch image
    dsk = disk_path[0]
    a2kit.cmd(['mkdsk','-d',dsk,'-o','prodos','-v','REALM.INSTALL1','-k','5.25in-apple-16']+fmt[img_fmt]['typ'])
    prodos_img = a2kit.cmd(['get','-f',fimg_folder/'prodos.json'])
    a2kit.cmd(['put','-f','PRODOS','-t','any','-d',dsk], prodos_img)
    basic_img = a2kit.cmd(['get','-f',fimg_folder/'basic.system.json'])
    a2kit.cmd(['put','-f','BASIC.SYSTEM','-t','any','-d',dsk], basic_img)
    startup_txt = a2kit.cmd(['get','-f',bas_pro_folder/'INSTALL.bas'])
    startup_tok = a2kit.cmd(['tokenize','-t','atxt','-a','2049'], startup_txt)
    a2kit.cmd(['put','-f','STARTUP','-t','atok','-d',dsk], startup_tok)
    a2kit.cmd(['mkdir','-d',dsk,'-f','ITEMS'])
    game_startup_txt = a2kit.cmd(['get','-f',bas_pro_folder/'STARTUP.bas'])
    game_startup_tok = a2kit.cmd(['tokenize','-t','atxt','-a','2049'], game_startup_txt)
    a2kit.cmd(['put','-f','ITEMS/START.REALM','-t','atok','-d',dsk],game_startup_tok)

    # Create the 2 data disks
    for i in range(2,4):
        dsk = disk_path[i-1]
        a2kit.cmd(['mkdsk','-d',dsk,'-o','prodos','-v','REALM.INSTALL'+str(i),'-k','5.25in-apple-16']+fmt[img_fmt]['typ'])
        noboot_message = a2kit.cmd(['get','-f',mc_folder/'NOBOOT.INST#060800'])
        a2kit.cmd(['put','-t','sec','-f','0,0,0','-d',dsk], noboot_message)
        a2kit.cmd(['mkdir','-d',dsk,'-f','ITEMS'])

    # Deploy all the file images to all the disk images
    print("writing all files...")
    for idx in range(3):
        print("   disk",idx)
        fimg_list = "["
        for f in prodos:
            if 100+idx in f['disks']:
                if fimg_list[-1] != "[":
                    fimg_list += ","
                fimg_list += f['fimg']
        fimg_list += "]"
        a2kit.cmd(['mput','-d',disk_path[idx],'-f','ITEMS'],fimg_list.encode('utf-8'))

if __name__ == "__main__":
    print("this is a module, do not run directly")