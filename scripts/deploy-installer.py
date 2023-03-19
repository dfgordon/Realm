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

fimg_folder = realm_path / 'file-images'
bas_pro_folder = realm_path / 'basic-prodos'
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

disk_path = [
    distro_path / ('realm-install-1.' + img_fmt),
    distro_path / ('realm-install-2.' + img_fmt),
    distro_path / ('realm-install-3.' + img_fmt)
]

art_addr = str(0x6d00)
map_addr = str(0x6e00)
screen_addr = str(0x2000)

prog_files = [
    {"name": "ALCHEMIST", "load": 0x800, "folder": bas_com_folder, "disk": 0},
    {"name": "ARCHWIZ", "load": 0xb00, "folder": bas_com_folder, "disk": 0},
    {"name": "BARON", "load": 0x800, "folder": bas_com_folder, "disk": 0},
    {"name": "CHAIN", "load": 0x1000, "folder": bas_pro_folder, "disk": 0},
    {"name": "COMBAT", "load": 0x4000, "folder": bas_com_folder, "disk": 1},
    {"name": "DUNGEON", "load": 0x4000, "folder": bas_pro_folder, "disk": 1},
    {"name": "FOOD", "load": 0xb00, "folder": bas_com_folder, "disk": 0},
    {"name": "HIGH.PRIEST", "load": 0x1000, "folder": bas_com_folder, "disk": 0},
    {"name": "LIBRARY", "load": 0x800, "folder": bas_com_folder, "disk": 0},
    {"name": "FINAL", "load": 0x800, "folder": bas_pro_folder, "disk": 1},
    {"name": "OUTSIDE", "load": 0x4000, "folder": bas_pro_folder, "disk": 1},
    {"name": "PUB", "load": 0x800, "folder": bas_com_folder, "disk": 1},
    {"name": "SAGE", "load": 0xb00, "folder": bas_com_folder, "disk": 1},
    {"name": "SAVE.GAME", "load": 0x800, "folder": bas_pro_folder, "disk": 1},
    {"name": "SHIPYARD", "load": 0xb00, "folder": bas_com_folder, "disk": 0},
    {"name": "TEMPLE", "load": 0x800, "folder": bas_com_folder, "disk": 1},
    {"name": "TOWN", "load": 0x4000, "folder": bas_com_folder, "disk": 2},
    {"name": "WEAPARM", "load": 0x800, "folder": bas_com_folder, "disk": 1},
    {"name": "LAUNCH", "load": None, "folder": bas_pro_folder, "disk": 2}
]

bin_files = [
    {"name": "SOUND#060300", "load": 0x300, "folder": mc_folder},
    {"name": "SDP.INTRP#0615ac", "load": 0x15ac, "folder": mc_folder},
    {"name": "MAP.INTRP#06163e", "load": 0x163e, "folder": mc_folder},
    {"name": "OUTSPS#060800", "load": 0x800, "folder": sprite_folder},
    {"name": "TWNSPS#060800", "load": 0x800, "folder": sprite_folder},
    {"name": "DNGNSPS#060800", "load": 0x800, "folder": sprite_folder}
]

text_files = [
    {"name": "MONSTERS", "folder": text_folder}
]

config_file = '''
100
100
BIN/
PROG/
'''

# Create bootable 5.25 inch image

if img_fmt=='woz':
    img_fmt = 'woz2'
dsk = disk_path[0]
a2kit_beg(['mkdsk','-d',dsk,'-o','prodos','-t',img_fmt,'-v','REALM.INSTALL1','-k','5.25in'])
prodos_img = a2kit_beg(['get','-f',fimg_folder/'prodos.json'])
a2kit_end(['put','-f','PRODOS','-t','any','-d',dsk], prodos_img)
basic_img = a2kit_beg(['get','-f',fimg_folder/'basic.system.json'])
a2kit_end(['put','-f','BASIC.SYSTEM','-t','any','-d',dsk], basic_img)
startup_txt = a2kit_beg(['get','-f',bas_pro_folder/'INSTALL.bas'])
startup_tok = a2kit_pipe(['tokenize','-t','atxt','-a','2049'], startup_txt)
a2kit_end(['put','-f','STARTUP','-t','atok','-d',dsk], startup_tok)
disk_lib = a2kit_beg(['get','-f',mc_folder/'DISKLIB#064000'])
a2kit_end(['put','-f','DISKLIB','-t','bin','-d',dsk,'-a','16384'], disk_lib)
a2kit_beg(['mkdir','-d',dsk,'-f','ITEMS'])

# Create the 2 data disks

for i in range(2,4):
    dsk = disk_path[i-1]
    a2kit_beg(['mkdsk','-d',dsk,'-o','prodos','-t',img_fmt,'-v','REALM.INSTALL'+str(i),'-k','5.25in'])
    noboot_message = a2kit_beg(['get','-f',mc_folder/'NOBOOT.INST#060800'])
    a2kit_end(['put','-t','sec','-f','0,0,0','-d',dsk], noboot_message)
    a2kit_beg(['mkdir','-d',dsk,'-f','ITEMS'])

# Root files

dsk = disk_path[0]
startup_txt = a2kit_beg(['get','-f',bas_pro_folder/'STARTUP.bas'])
startup_tok = a2kit_pipe(['tokenize','-t','atxt','-a','2049'], startup_txt)
a2kit_end(['put','-f','ITEMS/START.REALM','-t','atok','-d',dsk], startup_tok)
f = a2kit_beg(['get','-f',realm_path/'TITLE.PIC#062000'])
a2kit_end(['put','-f','ITEMS/TITLE.PIC','-t','bin','-a',screen_addr,'-d',dsk], f)
a2kit_end(['put','-f','ITEMS/DD','-t','txt','-d',dsk], bytes(config_file,encoding='utf8'))

# Deploy machine code and sprites
dsk = disk_path[0]
for dict in bin_files:
    name = dict['name'].split('#')[0]
    print('processing',name)
    src_path = dict['folder']/dict['name']
    dst_path = 'ITEMS/'+name
    obj = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','bin','-f',dst_path,'-a',str(dict['load']),'-d',dsk], obj)

# Deploy maps
dsk = disk_path[0]
for src_path in maplist:
    name = src_path.name.split('#')[0]
    print('processing',name)
    dst_path = 'ITEMS/'+name
    obj = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','bin','-f',dst_path,'-a',map_addr,'-d',dsk], obj)

# Deploy xmaps
dsk = disk_path[1]
for src_path in xmaplist:
    name = src_path.name.split('#')[0]
    print('processing',name)
    dst_path = 'ITEMS/'+name
    obj = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','bin','-f',dst_path,'-a',map_addr,'-d',dsk], obj)

# Deploy artwork
dsk = disk_path[2]
for src_path in artlist:
    name = src_path.name.split('#')[0]
    print('processing',name)
    dst_path = 'ITEMS/'+name
    obj = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','bin','-f',dst_path,'-a',art_addr,'-d',dsk], obj)

# Deploy text files
dsk = disk_path[2]
for dict in text_files:
    print('processing',dict['name'])
    src_path = dict['folder']/(dict['name']+'.TXT')
    dst_path = 'ITEMS/'+dict['name']
    txt = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','txt','-f',dst_path,'-d',dsk], txt)

# Deploy BASIC programs - spread across disks

for dict in prog_files:
    print('processing',dict['name'])
    src_path = dict['folder']/(dict['name']+'.bas')
    dst_path = 'ITEMS/'+dict['name']
    dsk = disk_path[dict['disk']]
    if dict['load']==None:
        addr0 = 0x800
    else:
        addr0 = dict['load']
    src = a2kit_beg(['get','-f',src_path])
    tok = a2kit_pipe(['tokenize','-t','atxt','-a',str(addr0+1)], src)
    max_lens = {0xb00:0x4ff, 0x800:0x7ff, 0x4000:0x2cff, 0x1000:0x5ab}
    if addr0 in max_lens and len(tok) > max_lens[addr0]:
        if dict['name']!='FINAL' and dict['name']!="LAUNCH":
            print('ERROR: program',dict['name'],'is too long')
            exit(1)
    if dict['load']==None:
        a2kit_end(['put','-t','atok','-f',dst_path,'-d',dsk], tok)
    else:
        # this is the faux binary that allows us to BLOAD applesoft tokens
        a2kit_end(['put','-t','bin','-f',dst_path,'-a',str(addr0+1),'-d',dsk], tok)
    print('program length',len(tok))
