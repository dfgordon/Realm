import pathlib
import sys
import a2kit

if not a2kit.chk_vers((1,8,0),(2,4,2)):
    exit(1)

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

if len(sys.argv)!=4:
    print('usage: python '+sys.argv[0]+' <img_type> <project_path> <distro_path>')
    print('<distro_path> is the final node (enclosing folder is not created)')
    exit(1)
img_fmt = sys.argv[1]
if img_fmt not in fmt:
    print('format must be in',fmt.keys())
    exit(1)
home_path = pathlib.Path.home()
realm_path = pathlib.Path(sys.argv[2])
distro_path = pathlib.Path(sys.argv[3])

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
    distro_path / ('realm-dos33-master.'+fmt[img_fmt]['ext']),
    distro_path / ('realm-dos33-dungeon.'+fmt[img_fmt]['ext']),
    distro_path / ('realm-dos33-monster.'+fmt[img_fmt]['ext']),
    distro_path / ('realm-dos33-setup.'+fmt[img_fmt]['ext'])
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

mkdsk_args = ['mkdsk','-o','dos33','-v','254'] + fmt[img_fmt]['typ']

print('creating disk images')
a2kit.beg(mkdsk_args + ['-d',disk_path[0],'-b'])
a2kit.beg(mkdsk_args + ['-d',disk_path[1]])
a2kit.beg(mkdsk_args + ['-d',disk_path[2]])
a2kit.beg(mkdsk_args + ['-d',disk_path[3],'-b'])
noboot_message = a2kit.beg(['get','-f',mc_folder/'NOBOOT#060800'])
a2kit.end(['put','-t','sec','-f','0,0,0','-d',disk_path[1]], noboot_message)
a2kit.end(['put','-t','sec','-f','0,0,0','-d',disk_path[2]], noboot_message)

# Deploy BASIC programs
for dict in bas_files:
    print('processing',dict['name'])
    if dict['load']==None:
        addr0 = 0x800
    else:
        addr0 = dict['load']
    src = a2kit.beg(['get','-f',dict['folder']/(dict['name']+'.bas')])
    # minify step could be added here
    tok = a2kit.pipe(['tokenize','-t','atxt','-a',str(addr0+1)], src)
    if dict['name']=='LAUNCH':
        max_len = 0x37ff
    elif dict['name']=='FINAL':
        max_len = 0x17ff
    elif dict['name']=='AUTOSTART':
        max_len = 0x37ff
    elif dict['load']!=None:
        max_len = {0xb00:0x4ff, 0x800:0x7ff, 0x4000:0x2cff, 0x1000:0x5ab}[addr0]
    else:
        max_len = 0x200 # small greeting programs or DISK<n> stubs
    if len(tok) > max_len:
        print('ERROR: program',dict['name'],'is too long')
        exit(1)
    for disk_count in dict['disks']:
        if dict['load']==None:
            a2kit.end(['put','-t','atok','-f',dict['name'],'-d',disk_path[disk_count]], tok)
        else:
            # this is the faux binary that allows us to BLOAD applesoft tokens
            a2kit.end(['put','-t','bin','-f',dict['name'],'-a',str(addr0+1),'-d',disk_path[disk_count]], tok)
    print('program length',len(tok))

# Deploy machine code sprites and pics
for dict in bin_files:
    name = dict['name'].split('#')[0]
    print('processing',name)
    obj = a2kit.beg(['get','-f',dict['folder']/dict['name']])
    for disk_count in dict['disks']:
        a2kit.end(['put','-t','bin','-f',name,'-a',str(dict['load']),'-d',disk_path[disk_count]], obj)

# Deploy text files
for dict in text_files:
    print('processing',dict['name'])
    txt = a2kit.beg(['get','-f',dict['folder']/(dict['name']+'.TXT')])
    for disk_count in dict['disks']:
        a2kit.end(['put','-t','txt','-f',dict['name'],'-d',disk_path[disk_count]], txt)

# Deploy maps
for path in maplist:
    name = path.name.split('#')[0]
    print('processing',name)
    obj = a2kit.beg(['get','-f',path])
    a2kit.end(['put','-t','bin','-f',name,'-a',map_addr,'-d',disk_path[0]], obj)
    if name=="ARRINEA":
        a2kit.end(['put','-t','bin','-f',name,'-a',map_addr,'-d',disk_path[3]], obj)

# Deploy xmaps
for path in xmaplist:
    name = path.name.split('#')[0]
    print('processing',name)
    obj = a2kit.beg(['get','-f',path])
    a2kit.end(['put','-t','bin','-f',name,'-a',map_addr,'-d',disk_path[1]], obj)
    if name in ["ABYSS","FONKRAKIS","WORNOTH"]:
        a2kit.end(['put','-t','bin','-f',name,'-a',map_addr,'-d',disk_path[3]], obj)

# Deploy artwork
for path in artlist:
    name = path.name.split('#')[0]
    print('processing',name)
    obj = a2kit.beg(['get','-f',path])
    a2kit.end(['put','-t','bin','-f',name,'-a',art_addr,'-d',disk_path[2]], obj)

# Change greeting program to GUTEN TAG
# (for old time's sake)
block = list(a2kit.beg(['get','-t','block','-f','25','-d',disk_path[0]]))
for i,char in enumerate('GUTEN TAG'):
    block[0x75+i] = ord(char) + 128
a2kit.end(['put','-t','block','-f','25','-d',disk_path[0]], bytes(block))
a2kit.end(['put','-t','block','-f','25','-d',disk_path[3]], bytes(block))