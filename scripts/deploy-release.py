'''Helper to prepare a final release for distribution.'''

import sys
import os
import glob
import pathlib
import subprocess

if len(sys.argv)!=4:
    print('Usage: release.py <vers> <proj_path> <distro_path>')
    print('<vers> should be in the form x.x.x')
    print('<proj_path> is the main Realm project directory')
    print('<distro_path> should not include the last node (will be Realm vx.x.x)')
    exit(0)

if len(sys.argv[1].split('.'))!=3:
    raise ValueError('Version has wrong number of parts.')
for n in sys.argv[1].split('.'):
    if not n.isnumeric():
        raise ValueError('One of the version parts is not a number: '+n)
v = ('v'+sys.argv[1]).replace('.','')
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

# print("Deploy DOS 3.3 DO disks...")
# compl = subprocess.run(['python','deploy-dos33.py','do',project_path,distro_path])
# if compl.returncode>0:
#     raise RuntimeError('subprocess failed')

print("Deploy DOS 3.3 WOZ disks")
compl = subprocess.run(['python','deploy-dos33.py','woz',project_path,distro_path])
if compl.returncode>0:
    raise RuntimeError('subprocess failed')

print("Deploy ProDOS PO logical volume...")
compl = subprocess.run(['python','deploy-prodos.py','po',project_path,distro_path])
if compl.returncode>0:
    raise RuntimeError('subprocess failed')

print("Deploy ProDOS WOZ 3.5 inch disk...")
compl = subprocess.run(['python','deploy-prodos.py','woz',project_path,distro_path])
if compl.returncode>0:
    raise RuntimeError('subprocess failed')

# print("Deploy Installer DO disks...")
# compl = subprocess.run(['python','deploy-installer.py','do',project_path,distro_path])
# if compl.returncode>0:
#     raise RuntimeError('subprocess failed')

print("Deploy Installer WOZ disks...")
compl = subprocess.run(['python','deploy-installer.py','woz',project_path,distro_path])
if compl.returncode>0:
    raise RuntimeError('subprocess failed')

print("Add version designations")
unversioned = glob.glob(str(distro_path/"*"))
for f in unversioned:
    ext = pathlib.Path(f).name.split('.')[-1]
    os.rename(f,f[:-len(ext)-1]+"-"+v+"."+ext)