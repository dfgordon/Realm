'''Create a final release for distribution.'''

import sys
sys.path.append('deploy_modules')
import os
import glob
import pathlib
import deploy_modules.a2kit as a2kit
import json
import deploy_modules.deploy_dos33 as deploy_dos33
import deploy_modules.deploy_prodos as deploy_prodos
import deploy_modules.deploy_installer as deploy_installer
import deploy_modules.deploy_pack as packer

# Pre-Deployment setup and error checking

a2kit.verify_py((3,12,0),(4,0,0))
a2kit.verify_a2((4,0,0),(5,0,0))

dos3x_fmt = ['woz']
prodos_fmt = ['po','woz']
installer_fmt = ['woz']

if len(sys.argv)!=4:
    print('Usage: ',sys.argv[0],' <vers> <proj_path> <distro_path>')
    print('<vers> should be in the form x.x.x')
    print('<proj_path> is the main Realm project directory')
    print('<distro_path> should not include the last node (Realm-vxxx is created)')
    exit(0)

if len(sys.argv[1].split('.'))!=3:
    raise ValueError('Version has wrong number of parts.')
for n in sys.argv[1].split('.'):
    if not n.isnumeric():
        raise ValueError('One of the version parts is not a number: '+n)
vers = sys.argv[1]
v = ('v'+vers).replace('.','')
project_path = pathlib.Path(sys.argv[2])
distro_path = pathlib.Path(sys.argv[3]) / ('Realm-'+v)

os.makedirs(distro_path,exist_ok=True)
cleanstr = glob.glob(str(distro_path/"*"))
if len(cleanstr)>0:
    print('Clean',str(distro_path),'first ?')
    print('(deletes all files - enter y to delete)')
    ans = input()
    if ans=='y':
        for f in cleanstr:
            print('delete '+f)
            os.remove(f)

with open(project_path / 'basic-dos33' / 'LAUNCH.bas') as f:
    if not "REALM V" + vers in f.read():
        raise ValueError("version in DOS 3.3 LAUNCH.bas was not consistent")

with open(project_path / 'basic-prodos' / 'LAUNCH.bas') as f:
    if not "REALM V" + vers in f.read():
        raise ValueError("version in ProDOS LAUNCH.bas was not consistent")

with open(project_path / 'basic-prodos' / 'INSTALL.bas') as f:
    if not "INSTALLER V" + vers in f.read():
        raise ValueError("version in INSTALL.bas was not consistent")

# Pack-up everything into a2kit file images.
# This task will typically take the longest.

dos33,prodos = packer.pack_all(project_path)

# Create all disk images

for fmt in dos3x_fmt:
    deploy_dos33.deploy(fmt,project_path,distro_path,dos33)

for fmt in prodos_fmt:
    deploy_prodos.deploy(fmt,project_path,distro_path,prodos)

for fmt in installer_fmt:
    deploy_installer.deploy(fmt,project_path,distro_path,prodos)

# Add disk image metadata

print()
print("Add version designations and metadata")
unversioned = glob.glob(str(distro_path/"*"))
with open('meta.json') as f:
    meta = json.load(f)
for f in unversioned:
    ext = pathlib.Path(f).name.split('.')[-1]

    meta["2mg"] = {}
    meta["woz2"]["meta"]["version"] = vers

    meta["woz2"]["meta"]["side"] = ""
    meta["woz2"]["meta"].pop("side")
    meta["woz2"]["meta"]["side_name"] = ""
    meta["woz2"]["meta"].pop("side_name")
    meta["2mg"]["comment"] = "Realm, Complete Volume"

    if "master" in f:
        meta["woz2"]["meta"]["side"] = "Disk 1, Side A"
        meta["woz2"]["meta"]["side_name"] = "Master"
        meta["2mg"]["comment"] = "Realm Master Disk"
    elif "dungeon" in f:
        meta["woz2"]["meta"]["side"] = "Disk 1, Side B"
        meta["woz2"]["meta"]["side_name"] = "Dungeon"
        meta["2mg"]["comment"] = "Realm Dungeon Disk"
    elif "monster" in f:
        meta["woz2"]["meta"]["side"] = "Disk 2, Side A"
        meta["woz2"]["meta"]["side_name"] = "Monster"
        meta["2mg"]["comment"] = "Realm Monster Disk"
    elif "setup" in f:
        meta["woz2"]["meta"]["side"] = "Disk 2, Side B"
        meta["woz2"]["meta"]["side_name"] = "Setup"
        meta["2mg"]["comment"] = "Realm Setup Disk"

    if "install-1" in f:
        meta["woz2"]["meta"]["side"] = "Disk 1, Side A"
        meta["woz2"]["meta"]["side_name"] = "Install 1"
        meta["2mg"]["comment"] = "Realm Install Disk 1"
    elif "install-2" in f:
        meta["woz2"]["meta"]["side"] = "Disk 1, Side B"
        meta["woz2"]["meta"]["side_name"] = "Install 2"
        meta["2mg"]["comment"] = "Realm Install Disk 2"
    elif "install-3" in f:
        meta["woz2"]["meta"]["side"] = "Disk 2, Side A"
        meta["woz2"]["meta"]["side_name"] = "Install 3"
        meta["2mg"]["comment"] = "Realm Install Disk 3"

    if ext=="woz":
        filt = ['-f','/woz2/']
    else:
        filt = ['-f','/'+ext+'/']
    a2kit.cmd(['put','-d',f,'-t','meta']+filt,json.dumps(meta).encode('utf-8'))
    os.rename(f,f[:-len(ext)-1]+"-"+v+"."+ext)