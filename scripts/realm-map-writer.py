'''This performs the inverse operation compared with realm-map-reader.py.
In particular this reads the data from the JSON formatted maps, and
saves it back into binaries, which can in turn be tansferred to DOS 3.3
disk images, using, e.g., CiderPress.  This last is facilitated by
the deploy-binaries.py script.'''

import json
import pathlib

dest = pathlib.Path.home() / 'Documents' / 'appleii' / 'Realm'
realm_name = ['ABYSS','ARRINEA','FONKRAKIS','WORNOTH']
realm_dir = ['exo-maps','arrinea-maps','exo-maps','exo-maps']

def townfile(coords):
    t = 'TOWNPIC.' + coords[0] + ' ' + coords[1] + '#068000'
    return str(dest / 'arrinea-maps' / t)

def xtownfile(coords):
    t = 'TOWNPIC.' + coords[0] + ' ' + coords[1] + '#068000'
    return str(dest / 'exo-maps' / t)

def dungeonfile(coords):
    d = 'DNGPIC.' + coords[0] + ' ' + coords[1] + '#068000'
    return str(dest / 'exo-maps'/ d)

def realmfile(idx):
    d = realm_name[idx] + '#068000'
    return str(dest / realm_dir[idx] / d)

def encode_terrain(c):
    return c.encode('ascii')[0] -'A'.encode('ascii')[0]

def pack_map(rows):
    bytesPerRow = int(len(rows[0])/2)
    bytes = bytearray(len(rows)*bytesPerRow)
    for i,r in enumerate(rows):
        for j in range(bytesPerRow):
            bytes[i*bytesPerRow+j] = encode_terrain(r[j*2]) + encode_terrain(r[j*2+1])*16
    return bytes

with open('text.json') as f:
    text = json.load(f)

with open('maps.json') as f:
    maps = json.load(f)

with open('dmaps.json') as f:
    dmaps = json.load(f)

def save_towns(x):
    if x:
        sub_dict = text['xtowns']
    else:
        sub_dict = text['towns']
    for town in sub_dict:
        coords = sub_dict[town]['coords']
        name = town + '\u0000' * (50 - len(town))
        bytes = bytearray(2490)
        bytes[:800] = pack_map(maps[town])
        bytes[800:850] = name.encode('ascii')
        bytes[850:1650] = pack_map(dmaps[town])
        for i in range(7):
            mono = sub_dict[town]['mono'][i]
            mono = mono + '\u0000' * (120 - len(mono))
            bytes[1650+120*i:1650+120*(i+1)] = mono.encode('ascii')
        if x:
            with open(xtownfile(coords),'w+b') as f:
                f.write(bytes)
        else:
            with open(townfile(coords),'w+b') as f:
                f.write(bytes)

def save_dungeons():
    for dungeon in text['dungeons']:
        coords = text['dungeons'][dungeon]['coords']
        name = dungeon + '\u0000' * (30 - len(dungeon))
        bytes = bytearray(2030)
        bytes[:1600] = pack_map(maps[dungeon])
        for i in range(5):
            trove = text['dungeons'][dungeon]['trove'][i]
            trove = trove + '\u0000' * (80 - len(trove))
            bytes[1600+80*i:1600+80*(i+1)] = trove.encode('ascii')
        bytes[2000:2030] = name.encode('ascii')
        with open(dungeonfile(coords),'w+b') as f:
            f.write(bytes[:2030])

def save_realms():
    for idx in range(4):
        bytes = pack_map(maps[realm_name[idx]])
        with open(realmfile(idx),'w+b') as f:
            f.write(bytes)

save_towns(False)
save_towns(True)
save_dungeons()
save_realms()
