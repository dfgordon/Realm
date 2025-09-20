import pathlib
import a2kit
import deploy_pack as packer

fmt = {
    'woz': {
        'ext': 'woz',
        'typ': ['-t','woz2'],
    },
    'po': {
        'ext': 'po',
        'typ': ['-t','po'],
    },
    '2mg-po': {
        'ext': '2mg',
        'typ': ['-t','2mg','-w','po']
    }
}

def deploy(img_fmt: str, realm_path: pathlib.Path, distro_path: pathlib.Path, prodos: list[packer.PackedFile]):
    if img_fmt not in fmt:
        print('format must be in',fmt.keys())
        exit(1)

    fimg_folder = realm_path / 'file-images'
    bas_pro_folder = realm_path / 'basic-prodos'
    disk_path = distro_path / ('realm-prodos.' + fmt[img_fmt]['ext'])

    print('creating 800K',img_fmt,'image...')

    # Create bootable 3.5 inch image
    a2kit.cmd(['mkdsk','-d',disk_path,'-o','prodos','-v','REALM.DISK','-k','3.5in-apple-800']+fmt[img_fmt]['typ'])
    prodos_img = a2kit.cmd(['get','-f',fimg_folder/'prodos.json'])
    a2kit.cmd(['put','-f','PRODOS','-t','any','-d',disk_path], prodos_img)
    basic_img = a2kit.cmd(['get','-f',fimg_folder/'basic.system.json'])
    a2kit.cmd(['put','-f','BASIC.SYSTEM','-t','any','-d',disk_path], basic_img)
    startup_txt = a2kit.cmd(['get','-f',bas_pro_folder/'STARTUP.bas'])
    startup_tok = a2kit.cmd(['tokenize','-t','atxt','-a','2049'], startup_txt)
    a2kit.cmd(['put','-f','STARTUP','-t','atok','-d',disk_path], startup_tok)

    # Create directories
    a2kit.cmd(['mkdir','-d',disk_path,'-f','REALM'])
    a2kit.cmd(['mkdir','-d',disk_path,'-f','REALM/PROG'])
    a2kit.cmd(['mkdir','-d',disk_path,'-f','REALM/BIN'])
    a2kit.cmd(['mkdir','-d',disk_path,'-f','REALM/MAPS'])
    a2kit.cmd(['mkdir','-d',disk_path,'-f','REALM/XMAPS'])
    a2kit.cmd(['mkdir','-d',disk_path,'-f','REALM/MONSTERS'])
    a2kit.cmd(['mkdir','-d',disk_path,'-f','REALM/PARTIES'])

    # Redundant startup code for users that are browsing rather than booting
    a2kit.cmd(['put','-f','REALM/START.REALM','-t','atok','-d',disk_path], startup_tok)

    # Deploy all the file images to the disk image
    print("writing all files...")
    fimg_list = "["
    for f in prodos:
        if 9 in f['disks']:
            if fimg_list[-1] != "[":
                fimg_list += ","
            fimg_list += f['fimg']
    fimg_list += "]"
    a2kit.cmd(['mput','-d',disk_path],fimg_list.encode('utf-8'))

if __name__ == "__main__":
    print("this is a module, do not run directly")