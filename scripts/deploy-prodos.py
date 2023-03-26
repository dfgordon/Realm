import subprocess
import pathlib
import sys

if len(sys.argv)!=4:
    print('usage: python '+sys.argv[0]+' <img_type> <project_path> <distro_path>')
    exit(1)
img_fmt = sys.argv[1]
if img_fmt!='woz' and img_fmt!='po':
    print('format must be woz or po')
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

disk_path = distro_path / ('realm-prodos.' + img_fmt)

art_addr = str(0x6d00)
map_addr = str(0x6e00)
screen_addr = str(0x2000)

prog_files = [
    {"name": "ALCHEMIST", "load": 0x800, "folder": bas_com_folder},
    {"name": "ARCHWIZ", "load": 0xb00, "folder": bas_com_folder},
    {"name": "BARON", "load": 0x800, "folder": bas_com_folder},
    {"name": "CHAIN", "load": 0x1000, "folder": bas_pro_folder},
    {"name": "COMBAT", "load": 0x4000, "folder": bas_com_folder},
    {"name": "DUNGEON", "load": 0x4000, "folder": bas_pro_folder},
    {"name": "FOOD", "load": 0xb00, "folder": bas_com_folder},
    {"name": "HIGH.PRIEST", "load": 0x1000, "folder": bas_com_folder},
    {"name": "LIBRARY", "load": 0x800, "folder": bas_com_folder},
    {"name": "FINAL", "load": 0x800, "folder": bas_pro_folder},
    {"name": "OUTSIDE", "load": 0x4000, "folder": bas_pro_folder},
    {"name": "PUB", "load": 0x800, "folder": bas_com_folder},
    {"name": "SAGE", "load": 0xb00, "folder": bas_com_folder},
    {"name": "SAVE.GAME", "load": 0x800, "folder": bas_pro_folder},
    {"name": "SHIPYARD", "load": 0xb00, "folder": bas_com_folder},
    {"name": "TEMPLE", "load": 0x800, "folder": bas_com_folder},
    {"name": "TOWN", "load": 0x4000, "folder": bas_com_folder},
    {"name": "WEAPARM", "load": 0x800, "folder": bas_com_folder},
    {"name": "LAUNCH", "load": None, "folder": bas_pro_folder}
]

bin_files = [
    {"name": "SOUND#060300", "load": 0x300, "folder": mc_folder},
    {"name": "SDP.INTRP#0615ac", "load": 0x15ac, "folder": mc_folder},
    {"name": "MAP.INTRP#06163e", "load": 0x163e, "folder": mc_folder},
    {"name": "OUTSPS#060800", "load": 0x800, "folder": sprite_folder},
    {"name": "TWNSPS#060800", "load": 0x800, "folder": sprite_folder},
    {"name": "DNGNSPS#060800", "load": 0x800, "folder": sprite_folder},
    {"name": "DISKLIB#064000", "load": 0x4000, "folder": mc_folder}
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

# Create bootable 3.5 inch image

if img_fmt=='woz':
    img_fmt = 'woz2'
a2kit_beg(['mkdsk','-d',disk_path,'-o','prodos','-t',img_fmt,'-v','REALM.DISK','-k','3.5in'])
prodos_img = a2kit_beg(['get','-f',fimg_folder/'prodos.json'])
a2kit_end(['put','-f','PRODOS','-t','any','-d',disk_path], prodos_img)
basic_img = a2kit_beg(['get','-f',fimg_folder/'basic.system.json'])
a2kit_end(['put','-f','BASIC.SYSTEM','-t','any','-d',disk_path], basic_img)
startup_txt = a2kit_beg(['get','-f',bas_pro_folder/'STARTUP.bas'])
startup_tok = a2kit_pipe(['tokenize','-t','atxt','-a','2049'], startup_txt)
a2kit_end(['put','-f','STARTUP','-t','atok','-d',disk_path], startup_tok)

# Root directory and files

a2kit_beg(['mkdir','-d',disk_path,'-f','REALM'])
a2kit_end(['put','-f','REALM/START.REALM','-t','atok','-d',disk_path], startup_tok)
f = a2kit_beg(['get','-f',realm_path/'TITLE.PIC#062000'])
a2kit_end(['put','-f','REALM/TITLE.PIC','-t','bin','-a',screen_addr,'-d',disk_path], f)
a2kit_end(['put','-f','REALM/DD','-t','txt','-d',disk_path], bytes(config_file,encoding='utf8'))

# Create subdirectories

a2kit_beg(['mkdir','-d',disk_path,'-f','REALM/PROG'])
a2kit_beg(['mkdir','-d',disk_path,'-f','REALM/BIN'])
a2kit_beg(['mkdir','-d',disk_path,'-f','REALM/MAPS'])
a2kit_beg(['mkdir','-d',disk_path,'-f','REALM/XMAPS'])
a2kit_beg(['mkdir','-d',disk_path,'-f','REALM/MONSTERS'])
a2kit_beg(['mkdir','-d',disk_path,'-f','REALM/PARTIES'])

# Deploy BASIC programs

for dict in prog_files:
    print('processing',dict['name'])
    src_path = dict['folder']/(dict['name']+'.bas')
    dst_path = 'REALM/PROG/'+dict['name']
    if dict['load']==None:
        addr0 = 0x800
    else:
        addr0 = dict['load']
    src = a2kit_beg(['get','-f',src_path])
    min = a2kit_pipe(['minify','-t','atxt'], src)
    tok = a2kit_pipe(['tokenize','-t','atxt','-a',str(addr0+1)], min)
    if dict['name']=='LAUNCH':
        max_len = 0x37ff
    elif dict['name']=='FINAL':
        max_len = 0x17ff
    else:
        max_len = {0xb00:0x4ff, 0x800:0x7ff, 0x4000:0x2cff, 0x1000:0x5ab}[addr0]
    if len(tok) > max_len:
        print('ERROR: program',dict['name'],'is too long')
        exit(1)
    if dict['load']==None:
        a2kit_end(['put','-t','atok','-f',dst_path,'-d',disk_path], tok)
    else:
        # this is the faux binary that allows us to BLOAD applesoft tokens
        a2kit_end(['put','-t','bin','-f',dst_path,'-a',str(addr0+1),'-d',disk_path], tok)
    print('program length',len(tok))

# Deploy machine code and sprites
for dict in bin_files:
    name = dict['name'].split('#')[0]
    print('processing',name)
    src_path = dict['folder']/dict['name']
    dst_path = 'REALM/BIN/'+name
    obj = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','bin','-f',dst_path,'-a',str(dict['load']),'-d',disk_path], obj)

# Deploy maps
for src_path in maplist:
    name = src_path.name.split('#')[0]
    print('processing',name)
    dst_path = 'REALM/MAPS/'+name
    obj = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','bin','-f',dst_path,'-a',map_addr,'-d',disk_path], obj)

# Deploy xmaps
for src_path in xmaplist:
    name = src_path.name.split('#')[0]
    print('processing',name)
    dst_path = 'REALM/XMAPS/'+name
    obj = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','bin','-f',dst_path,'-a',map_addr,'-d',disk_path], obj)

# Deploy artwork
for src_path in artlist:
    name = src_path.name.split('#')[0]
    print('processing',name)
    dst_path = 'REALM/MONSTERS/'+name
    obj = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','bin','-f',dst_path,'-a',art_addr,'-d',disk_path], obj)

# Deploy text files
for dict in text_files:
    print('processing',dict['name'])
    src_path = dict['folder']/(dict['name']+'.TXT')
    dst_path = 'REALM/MONSTERS/'+dict['name']
    txt = a2kit_beg(['get','-f',src_path])
    a2kit_end(['put','-t','txt','-f',dst_path,'-d',disk_path], txt)
