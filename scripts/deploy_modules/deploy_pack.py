'''Module to create file images for all deployments.
We can save time by doing this only once.
This tends to be the most intensive task.
There is a numerical disk mapping involved which goes as follows.
* 0-3 are the 140K play disks
* 9 is the 800K play disk
* 100-102 are the 140K installer disks'''
import pathlib
import a2kit
from typing import TypedDict

class PackedFile(TypedDict):
    '''contains a serialized file image and list of disks it shall be deployed to'''
    fimg: str
    disks: list[int]

def need_prodos(disks: list[int]):
    return 9 in disks or 100 in disks or 101 in disks or 102 in disks

def need_dos33(disks: list[int]):
    return 0 in disks or 1 in disks or 2 in disks or 3 in disks

config_file = '''100
100
BIN/
PROG/
'''

def get_tokens(pth: pathlib.Path, dict: dict):
    '''Get minified tokens, works in all cases'''
    print('processing',dict['name'])
    # This must include all line numbers that are interprogram branch destinations,
    # so the minifier knows not to combine them with preceding lines.
    line_guards = "0,1,5,10,100,8900,8910,25000"
    src = a2kit.cmd(['get','-f',pth/(dict['name']+'.bas')])
    min = a2kit.cmd(['minify','-t','atxt','--level','3','--extern',line_guards], src)
    tok = a2kit.cmd(['tokenize','-t','atxt','-a',str(dict['load']+1)], min)
    if len(tok) > dict['max']:
        print('ERROR: program',dict['name'],'is too long')
        exit(1)
    return tok

def pack_basic(realm_path: pathlib.Path, ans_dos: list[PackedFile], ans_prodos: list[PackedFile]):
    bas_dos_folder = realm_path / 'basic-dos33'
    bas_pro_folder = realm_path / 'basic-prodos'
    bas_com_folder = realm_path / 'basic-common'
    bas_files = [
        {"name": "ALCHEMIST", "load": 0x800, "max": 0x7ff, "disks": [0,1,9,100], "com": True, "bin": True},
        {"name": "ARCHWIZ", "load": 0xb00, "max": 0x4ff, "disks": [0,9,100], "com": True, "bin": True},
        {"name": "BARON", "load": 0x800, "max": 0x7ff, "disks": [1,9,100], "com": True, "bin": True},
        {"name": "CHAIN", "load": 0x1000, "max": 0x5ab, "disks": [0,1,2,9,100], "com": False, "bin": True},
        {"name": "COMBAT", "load": 0x4000, "max": 0x2cff, "disks": [0,1,2,9,101], "com": True, "bin": True},
        {"name": "DUNGEON", "load": 0x4000, "max": 0x2cff, "disks": [2,9,101], "com": False, "bin": True},
        {"name": "FOOD", "load": 0xb00, "max": 0x4ff, "disks": [0,1,9,100], "com": True, "bin": True},
        {"name": "HIGH.PRIEST", "load": 0x1000, "max": 0x5ab, "disks": [2,9,100], "com": True, "bin": True},
        {"name": "LIBRARY", "load": 0x800, "max": 0x7ff, "disks": [0,1,9,100], "com": True, "bin": True},
        {"name": "FINAL", "load": 0x800, "max": 0x17ff, "disks": [2,9,101], "com": False, "bin": True},
        {"name": "OUTSIDE", "load": 0x4000, "max": 0x2cff, "disks": [0,1,9,101], "com": False, "bin": True},
        {"name": "PUB", "load": 0x800, "max": 0x7ff, "disks": [0,1,9,101], "com": True, "bin": True},
        {"name": "SAGE", "load": 0xb00, "max": 0x4ff, "disks": [0,9,101], "com": True, "bin": True},
        {"name": "SAVE.GAME", "load": 0x800, "max": 0x7ff, "disks": [0,9,101], "com": False, "bin": True},
        {"name": "SHIPYARD", "load": 0xb00, "max": 0x4ff, "disks": [0,1,9,100], "com": True, "bin": True},
        {"name": "TEMPLE", "load": 0x800, "max": 0x7ff, "disks": [0,1,9,101], "com": True, "bin": True},
        {"name": "TOWN", "load": 0x4000, "max": 0x2cff, "disks": [0,1,9,102], "com": True, "bin": True},
        {"name": "WEAPARM", "load": 0x800, "max": 0x7ff, "disks": [0,1,9,101], "com": True, "bin": True},
        {"name": "AUTOSTART", "load": 0x800, "max": 0x37ff, "disks": [0], "com": False, "bin": False},
        {"name": "GUTEN TAG", "load": 0x800, "max": 0xff, "disks": [0,3], "com": False, "bin": False},
        {"name": "LAUNCH", "load": 0x800, "max": 0x37ff, "disks": [3,9,102], "com": False, "bin": False},
        {"name": "DISK0", "load": 0x800, "max": 0xff, "disks": [0], "com": False, "bin": False},
        {"name": "DISK1", "load": 0x800, "max": 0xff, "disks": [1], "com": False, "bin": False},
        {"name": "DISK2", "load": 0x800, "max": 0xff, "disks": [2], "com": False, "bin": False},
        {"name": "DISK3", "load": 0x800, "max": 0xff, "disks": [3], "com": False, "bin": False}
    ]
    for dict in bas_files:
        addr0 = dict['load']
        if dict['com']:
            tok_dos = get_tokens(bas_com_folder,dict)
            tok_prodos = tok_dos
        else:
            tok_dos = get_tokens(bas_dos_folder,dict) if need_dos33(dict['disks']) else None
            tok_prodos = get_tokens(bas_pro_folder,dict) if need_prodos(dict['disks']) else None
        if tok_dos:
            if dict['bin']:
                x: PackedFile = { "fimg": a2kit.pack_bin(tok_dos,addr0+1,dict['name'],'dos33'), "disks": dict['disks']}
            else:
                x: PackedFile = { "fimg": a2kit.pack_tok(tok_dos,dict['name'],'dos33'), "disks": dict['disks']}
            ans_dos += [x]
        if tok_prodos:
            pth = 'REALM/PROG/' + dict['name']
            if dict['bin']:
                x: PackedFile = { "fimg": a2kit.pack_bin(tok_prodos,addr0+1,pth,'prodos'), "disks": dict['disks']}
            else:
                x: PackedFile = { "fimg": a2kit.pack_tok(tok_prodos,pth,'prodos'), "disks": dict['disks']}
            ans_prodos += [x]

def pack_art(realm_path: pathlib.Path, ans_dos: list[PackedFile], ans_prodos: list[PackedFile]):
    art_folder = realm_path / 'artwork-squeezed'
    artlist = pathlib.Path.glob(art_folder , '*')
    dos_addr = 0x8c80
    pro_addr = 0x6d00
    for path in artlist:
        name = path.name.split('#')[0]
        print('processing',name)
        obj = a2kit.cmd(['get','-f',path])
        x: PackedFile = { "fimg": a2kit.pack_bin(obj,dos_addr,name,'dos33'), "disks": [2,9,102] }
        ans_dos += [x]
        x: PackedFile = { "fimg": a2kit.pack_bin(obj,pro_addr,'REALM/MONSTERS/'+name,'prodos'), "disks": [2,9,102] }
        ans_prodos += [x]

def pack_maps(realm_path: pathlib.Path, ans_dos: list[PackedFile], ans_prodos: list[PackedFile]):
    map_folder = realm_path / 'arrinea-maps'
    xmap_folder = realm_path / 'exo-maps'
    maplist = pathlib.Path.glob(map_folder , '*')
    xmaplist = pathlib.Path.glob(xmap_folder , '*')
    dos_addr = 0x8000
    pro_addr = 0x6e00
    for path in maplist:
        name = path.name.split('#')[0]
        print('processing',name)
        obj = a2kit.cmd(['get','-f',path])
        disks = [0,3,9,100] if name=="ARRINEA" else [0,9,100]
        x: PackedFile = { "fimg": a2kit.pack_bin(obj,dos_addr,name,'dos33'), "disks": disks }
        ans_dos += [x]
        x: PackedFile = { "fimg": a2kit.pack_bin(obj,pro_addr,'REALM/MAPS/'+name,'prodos'), "disks": disks }
        ans_prodos += [x]
    for path in xmaplist:
        name = path.name.split('#')[0]
        print('processing',name)
        obj = a2kit.cmd(['get','-f',path])
        disks = [1,3,9,101] if name in ["ABYSS","FONKRAKIS","WORNOTH"] else [1,9,101]
        x: PackedFile = { "fimg": a2kit.pack_bin(obj,dos_addr,name,'dos33'), "disks": disks }
        ans_dos += [x]
        x: PackedFile = { "fimg": a2kit.pack_bin(obj,pro_addr,'REALM/XMAPS/'+name,'prodos'), "disks": disks }
        ans_prodos += [x]

def pack_bin(realm_path: pathlib.Path, ans_dos: list[PackedFile], ans_prodos: list[PackedFile]):
    sprite_folder = realm_path / 'sprites'
    mc_folder = realm_path / 'assembly'
    bin_files = [
        {"name": "DISKLIB#064000", "load": 0x4000, "disks": [9,100], "folder": mc_folder, "dst": "REALM/BIN/"},
        {"name": "SOUND#060300", "load": 0x300, "disks": [0,3,9,100], "folder": mc_folder, "dst": "REALM/BIN/"},
        {"name": "SDP.INTRP#0615ac", "load": 0x15ac, "disks": [0,1,9,100], "folder": mc_folder, "dst": "REALM/BIN/"},
        {"name": "MAP.INTRP#06163e", "load": 0x163e, "disks": [0,1,9,100], "folder": mc_folder, "dst": "REALM/BIN/"},
        {"name": "OUTSPS#060800", "load": 0x800, "disks": [0,1,9,100], "folder": sprite_folder, "dst": "REALM/BIN/"},
        {"name": "TWNSPS#060800", "load": 0x800, "disks": [0,1,9,100], "folder": sprite_folder, "dst": "REALM/BIN/"},
        {"name": "DNGNSPS#060800", "load": 0x800, "disks": [2,9,100], "folder": sprite_folder, "dst": "REALM/BIN/"},
        {"name": "TITLE.PIC#062000", "load": 0x2000, "disks": [3,9,100], "folder": realm_path, "dst": "REALM/"}
    ]
    for dict in bin_files:
        name = dict['name'].split('#')[0]
        print('processing',name)
        obj = a2kit.cmd(['get','-f',dict['folder']/dict['name']])
        if need_dos33(dict['disks']):
            x: PackedFile = { "fimg": a2kit.pack_bin(obj,dict['load'],name,'dos33'), "disks": dict['disks'] }
            ans_dos += [x]
        if need_prodos(dict['disks']):
            x: PackedFile = { "fimg": a2kit.pack_bin(obj,dict['load'],dict['dst']+name,'prodos'), "disks": dict['disks'] }
            ans_prodos += [x]

def pack_txt(realm_path: pathlib.Path, ans_dos: list[PackedFile], ans_prodos: list[PackedFile]):
    text_folder = realm_path / 'text-data'
    text_files = [
        {"name": "MONSTERS", "disks": [2,9,102], "folder": text_folder},
        {"name": "DD", "disks": [0,3], "folder": text_folder},
        {"name": "PLIST", "disks": [0,3], "folder": text_folder}
    ]
    for dict in text_files:
        print('processing',dict['name'])
        raw = a2kit.cmd(['get','-f',dict['folder']/(dict['name']+'.TXT')])
        if need_dos33(dict['disks']):
            x: PackedFile = { "fimg": a2kit.pack_txt(raw,dict['name'],'dos33'), "disks": dict['disks'] }
            ans_dos += [x]
        if need_prodos(dict['disks']):
            x: PackedFile = { "fimg": a2kit.pack_txt(raw,'REALM/MONSTERS/'+dict['name'],'prodos'), "disks": dict['disks'] }
            ans_prodos += [x]
    # handle prodos config file specially
    x: PackedFile = { "fimg": a2kit.pack_txt(config_file.encode('utf-8'),'REALM/DD','prodos'), "disks": [9,100] }
    ans_prodos += [x]

def pack_all(realm_path: pathlib.Path):
    ans_dos: list[PackedFile] = []
    ans_prodos: list[PackedFile] = []
    pack_basic(realm_path,ans_dos,ans_prodos)
    pack_art(realm_path,ans_dos,ans_prodos)
    pack_maps(realm_path,ans_dos,ans_prodos)
    pack_bin(realm_path,ans_dos,ans_prodos)
    pack_txt(realm_path,ans_dos,ans_prodos)
    return ans_dos,ans_prodos

if __name__ == "__main__":
    print("this is a module, do not run directly")