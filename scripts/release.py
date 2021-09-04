'''Helper to prepare a final release for distribution.'''

import sys
import os
import glob
import shutil
import pathlib
import subprocess

if len(sys.argv)<2 or len(sys.argv)>4:
    print('Usage: release.py <vers> [33] [pro]')
    print('<vers> should be in the form x.x.x')
    print('optional arguments request dos33 and/or prodos distros')
    exit(0)

if len(sys.argv[1].split('.'))!=3:
    raise ValueError('Version has wrong number of parts.')
for n in sys.argv[1].split('.'):
    if not n.isnumeric():
        raise ValueError('One of the version parts is not a number: '+n)
v = ('v'+sys.argv[1]).replace('.','')

disk_path = pathlib.Path.home() / 'Documents' / 'appleii' / 'DISKS'
#script_path = pathlib.Path.home() / 'Library' / 'Application Support' / 'Virtual ][' / 'Scripts' / 'User scripts'
script_path = pathlib.Path.home() / 'Documents' / 'appleii' / 'Realm' / 'scripts'
distro_path = disk_path / ('Realm-'+v)

os.makedirs(distro_path,exist_ok=True)
print('Clean distro folder first ?')
print('(deletes all files - enter y to delete)')
ans = input()
if ans=='y':
    cleanstr = glob.glob(str(distro_path / "*"))
    for f in cleanstr:
        print('delete '+f)
        os.remove(f)

if '33' in sys.argv:
    shutil.copy(disk_path / 'Realm-blanks' / 'realm-dos33-dungeon.DO' , disk_path)
    shutil.copy(disk_path / 'Realm-blanks' / 'realm-dos33-master.DO' , disk_path)
    shutil.copy(disk_path / 'Realm-blanks' / 'realm-dos33-monster.DO' , disk_path)
    shutil.copy(disk_path / 'Realm-blanks' / 'realm-dos33-setup.DO' , disk_path)

    subprocess.run(["open",str(script_path / 'deploy-all-dos33.scpt')])
    print('We opened an AppleScript, please run.  When it completes return here and press enter.')
    input()

    print('Copying disk images to distribution folder...')
    shutil.copy(disk_path / 'realm-dos33-dungeon.DO' , distro_path / ('realm-dos33-dungeon-'+v+'.DO'))
    shutil.copy(disk_path / 'realm-dos33-master.DO' , distro_path / ('realm-dos33-master-'+v+'.DO'))
    shutil.copy(disk_path / 'realm-dos33-monster.DO' , distro_path / ('realm-dos33-monster-'+v+'.DO'))
    shutil.copy(disk_path / 'realm-dos33-setup.DO' , distro_path / ('realm-dos33-setup-'+v+'.DO'))

if 'pro' in sys.argv:
    shutil.copy(disk_path / 'Realm-blanks' / 'realm-prodos.po' , disk_path)

    subprocess.run(["open",str(script_path / 'deploy-all-prodos.scpt')])
    print('We opened an AppleScript, please run.  When it completes return here and press enter.')
    input()

    print('Copying disk images to distribution folder...')
    shutil.copy(disk_path / 'realm-prodos.po' , distro_path / ('realm-prodos-'+v+'.po'))
