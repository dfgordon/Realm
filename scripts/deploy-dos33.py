import subprocess
import pathlib
import sys

if len(sys.argv)!=4:
    print('usage: python '+sys.argv[0]+' <img_type> <project_path> <distro_path>')
    exit(1)
img_fmt = sys.argv[1]
if img_fmt!='woz' and img_fmt!='do':
    print('format must be woz or do')
    exit(1)
home_path = pathlib.Path.home()
realm_path = pathlib.Path(sys.argv[2])
distro_path = pathlib.Path(sys.argv[3])

def a2kit_beg(args):
    '''run a2kit and pipe the output'''
    compl = subprocess.run(['a2kit']+args,capture_output=True,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout
def a2kit_pipe(args,pipe_in):
    '''run a2kit with piped input and output'''
    compl = subprocess.run(['a2kit']+args,input=pipe_in,capture_output=True,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout
def a2kit_end(args,pipe_in):
    '''run a2kit with piped input and terminate output'''
    compl = subprocess.run(['a2kit']+args,input=pipe_in,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout

bas_dos_folder = realm_path / 'basic-dos33'
bas_com_folder = realm_path / 'basic-common'
text_folder = realm_path / 'text-data'
script_folder = realm_path / 'scripts'
art_folder = realm_path / 'artwork-squeezed'
map_folder = realm_path / 'arrinea-maps'
xmap_folder = realm_path / 'exo-maps'
sprite_folder = realm_path / 'sprites'
mc_folder = realm_path / 'assembly'

artlist = pathlib.Path.glob(art_folder , '*')
maplist = pathlib.Path.glob(map_folder , '*')
xmaplist = pathlib.Path.glob(xmap_folder , '*')

disk_path = (
    distro_path / ('realm-dos33-master.'+img_fmt),
    distro_path / ('realm-dos33-dungeon.'+img_fmt),
    distro_path / ('realm-dos33-monster.'+img_fmt),
    distro_path / ('realm-dos33-setup.'+img_fmt)
)

map_addr = str(0x8000)
art_addr = str(0x8c80)

bas_files = [
    {"name": "ALCHEMIST", "load": 0x800, "disks": [0,1], "folder": bas_com_folder},
    {"name": "ARCHWIZ", "load": 0xb00, "disks": [0], "folder": bas_com_folder},
    {"name": "BARON", "load": 0x800, "disks": [1], "folder": bas_com_folder},
    {"name": "CHAIN", "load": 0x1000, "disks": [0,1,2], "folder": bas_dos_folder},
    {"name": "COMBAT", "load": 0x4000, "disks": [0,1,2], "folder": bas_com_folder},
    {"name": "DUNGEON", "load": 0x4000, "disks": [2], "folder": bas_dos_folder},
    {"name": "FOOD", "load": 0xb00, "disks": [0,1], "folder": bas_com_folder},
    {"name": "HIGH.PRIEST", "load": 0x1000, "disks": [2], "folder": bas_com_folder},
    {"name": "LIBRARY", "load": 0x800, "disks": [0,1], "folder": bas_com_folder},
    {"name": "FINAL", "load": 0x800, "disks": [2], "folder": bas_dos_folder},
    {"name": "OUTSIDE", "load": 0x4000, "disks": [0,1], "folder": bas_dos_folder},
    {"name": "PUB", "load": 0x800, "disks": [0,1], "folder": bas_com_folder},
    {"name": "SAGE", "load": 0xb00, "disks": [0], "folder": bas_com_folder},
    {"name": "SAVE.GAME", "load": 0x800, "disks": [0], "folder": bas_dos_folder},
    {"name": "SHIPYARD", "load": 0xb00, "disks": [0,1], "folder": bas_com_folder},
    {"name": "TEMPLE", "load": 0x800, "disks": [0,1], "folder": bas_com_folder},
    {"name": "TOWN", "load": 0x4000, "disks": [0,1], "folder": bas_com_folder},
    {"name": "WEAPARM", "load": 0x800, "disks": [0,1], "folder": bas_com_folder},
    {"name": "AUTOSTART", "load": None, "disks": [0], "folder": bas_dos_folder},
    {"name": "GUTEN TAG", "load": None, "disks": [0,3], "folder": bas_dos_folder},
    {"name": "LAUNCH", "load": None, "disks": [3], "folder": bas_dos_folder},
    {"name": "DISK0", "load": None, "disks": [0], "folder": bas_dos_folder},
    {"name": "DISK1", "load": None, "disks": [1], "folder": bas_dos_folder},
    {"name": "DISK2", "load": None, "disks": [2], "folder": bas_dos_folder},
    {"name": "DISK3", "load": None, "disks": [3], "folder": bas_dos_folder},
]

bin_files = [
    {"name": "SOUND#060300", "load": 0x300, "disks": [0,3], "folder": mc_folder},
    {"name": "SDP.INTRP#0615ac", "load": 0x15ac, "disks": [0,1], "folder": mc_folder},
    {"name": "MAP.INTRP#06163e", "load": 0x163e, "disks": [0,1], "folder": mc_folder},
    {"name": "OUTSPS#060800", "load": 0x800, "disks": [0,1], "folder": sprite_folder},
    {"name": "TWNSPS#060800", "load": 0x800, "disks": [0,1], "folder": sprite_folder},
    {"name": "DNGNSPS#060800", "load": 0x800, "disks": [2], "folder": sprite_folder},
    {"name": "TITLE.PIC#062000", "load": 0x2000, "disks": [3], "folder": realm_path}
]

text_files = [
    {"name": "MONSTERS", "disks": [2], "folder": text_folder},
    {"name": "DD", "disks": [0,3], "folder": text_folder},
    {"name": "PLIST", "disks": [0,3], "folder": text_folder}
]

# Create the blank disk images, some bootable, some with noboot message

if img_fmt=='woz':
    img_fmt = 'woz2'
print('creating disk images')
a2kit_beg(['mkdsk','-d',disk_path[0],'-o','dos33','-t',img_fmt,'-v','254','-b'])
a2kit_beg(['mkdsk','-d',disk_path[1],'-o','dos33','-t',img_fmt,'-v','254'])
a2kit_beg(['mkdsk','-d',disk_path[2],'-o','dos33','-t',img_fmt,'-v','254'])
a2kit_beg(['mkdsk','-d',disk_path[3],'-o','dos33','-t',img_fmt,'-v','254','-b'])
noboot_message = a2kit_beg(['get','-f',mc_folder/'NOBOOT#060800'])
a2kit_end(['put','-t','sec','-f','0,0,0','-d',disk_path[1]], noboot_message)
a2kit_end(['put','-t','sec','-f','0,0,0','-d',disk_path[2]], noboot_message)

# Deploy BASIC programs
for dict in bas_files:
    print('processing',dict['name'])
    if dict['load']==None:
        addr0 = 0x800
    else:
        addr0 = dict['load']
    src = a2kit_beg(['get','-f',dict['folder']/(dict['name']+'.bas')])
    tok = a2kit_pipe(['tokenize','-t','atxt','-a',str(addr0+1)], src)
    max_lens = {0xb00:0x4ff, 0x800:0x7ff, 0x4000:0x2cff, 0x1000:0x5ab}
    if addr0 in max_lens and len(tok) > max_lens[addr0]:
        if dict['name']!='FINAL' and dict['name']!="AUTOSTART" and dict['name']!="LAUNCH":
            print('ERROR: program',dict['name'],'is too long')
            exit(1)
    for disk_count in dict['disks']:
        if dict['load']==None:
            a2kit_end(['put','-t','atok','-f',dict['name'],'-d',disk_path[disk_count]], tok)
        else:
            # this is the faux binary that allows us to BLOAD applesoft tokens
            a2kit_end(['put','-t','bin','-f',dict['name'],'-a',str(addr0+1),'-d',disk_path[disk_count]], tok)
    print('program length',len(tok))

# Deploy machine code sprites and pics
for dict in bin_files:
    name = dict['name'].split('#')[0]
    print('processing',name)
    obj = a2kit_beg(['get','-f',dict['folder']/dict['name']])
    for disk_count in dict['disks']:
        a2kit_end(['put','-t','bin','-f',name,'-a',str(dict['load']),'-d',disk_path[disk_count]], obj)

# Deploy text files
for dict in text_files:
    print('processing',dict['name'])
    txt = a2kit_beg(['get','-f',dict['folder']/(dict['name']+'.TXT')])
    for disk_count in dict['disks']:
        a2kit_end(['put','-t','txt','-f',dict['name'],'-d',disk_path[disk_count]], txt)

# Deploy maps
for path in maplist:
    name = path.name.split('#')[0]
    print('processing',name)
    obj = a2kit_beg(['get','-f',path])
    a2kit_end(['put','-t','bin','-f',name,'-a',map_addr,'-d',disk_path[0]], obj)
    if name=="ARRINEA":
        a2kit_end(['put','-t','bin','-f',name,'-a',map_addr,'-d',disk_path[3]], obj)

# Deploy xmaps
for path in xmaplist:
    name = path.name.split('#')[0]
    print('processing',name)
    obj = a2kit_beg(['get','-f',path])
    a2kit_end(['put','-t','bin','-f',name,'-a',map_addr,'-d',disk_path[1]], obj)
    if name in ["ABYSS","FONKRAKIS","WORNOTH"]:
        a2kit_end(['put','-t','bin','-f',name,'-a',map_addr,'-d',disk_path[3]], obj)

# Deploy artwork
for path in artlist:
    name = path.name.split('#')[0]
    print('processing',name)
    obj = a2kit_beg(['get','-f',path])
    a2kit_end(['put','-t','bin','-f',name,'-a',art_addr,'-d',disk_path[2]], obj)

# Change greeting program to GUTEN TAG
# (for old time's sake)
block = list(a2kit_beg(['get','-t','block','-f','25','-d',disk_path[0]]))
for i,char in enumerate('GUTEN TAG'):
    block[0x75+i] = ord(char) + 128
a2kit_end(['put','-t','block','-f','25','-d',disk_path[0]], bytes(block))
a2kit_end(['put','-t','block','-f','25','-d',disk_path[3]], bytes(block))