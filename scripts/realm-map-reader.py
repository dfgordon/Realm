'''Program to read Realm map files in original format
and save them as JSON files.  The assumed filename suffix is a
product of CiderPress extraction.  The directory structure
mirrors the original disk structure, i.e., arrinea-maps
are the maps that were on the master disk, and exo-maps
are the ones that were on the dungeon disk.'''

import pathlib
import json

src = pathlib.Path.home() / 'Documents' / 'appleii' / 'Realm'
realms = []

towns = (src / 'arrinea-maps').glob('TOWNPIC.*')
xtowns = (src / 'exo-maps').glob('TOWNPIC.*')
dungeons = (src / 'exo-maps').glob('DNGPIC.*')
realms += [src / 'arrinea-maps' / 'ARRINEA#068000']
realms += [src / 'exo-maps' / 'FONKRAKIS#068000']
realms += [src / 'exo-maps' / 'ABYSS#068000']
realms += [src / 'exo-maps' / 'WORNOTH#068000']

towns = list(map(str,list(towns)))
xtowns = list(map(str,list(xtowns)))
dungeons = list(map(str,list(dungeons)))
realms = list(map(str,list(realms)))

text = {'towns':{},'xtowns':{},'dungeons':{}}
maps = {}
dmaps = {}

def get_nibbles(bytes,dims):
    '''Encode map as a list of strings.  Each string is a row of terrain.
    bytes = raw bytes from vintage data.
    dims = (rows,columns)'''
    nibbles = []
    for j in range(dims[0]):
        s = ''
        for i in range(dims[1]):
            idx = int(j*dims[1]/2) + int(i/2)
            if i%2==0:
                z = bytes[idx] & 15
            else:
                z = bytes[idx] >> 4
            s += chr(65 + z)
        nibbles += [s]
    return nibbles

def town_data(town,bytes):
    coords = town.split('.')[1].split('#')[0].split(' ')
    name = bytes[800:850].decode('ascii','ignore').split('\0')[0]
    mono = []
    for i in range(7):
        mono += [bytes[1650+120*i:1650+120*(i+1)].decode('ascii','ignore').split('\0')[0]]
    map = get_nibbles(bytes[:800],(40,40))
    dmap = get_nibbles(bytes[850:1650],(40,40))
    return name,coords,mono,map,dmap

def dungeon_data(dng,bytes):
    coords = dng.split('.')[1].split('#')[0].split(' ')
    name = bytes[2000:2030].decode('ascii','ignore').split('\0')[0]
    trove = []
    for i in range(5):
        trove += [bytes[1600+80*i:1600+80*(i+1)].decode('ascii','ignore').split('\0')[0]]
    map = get_nibbles(bytes[:1600],(160,20))
    return name,coords,trove,map

for town in towns:
    with open(town,'r+b') as f:
        bytes = f.read()
    name,coords,mono,map,dmap = town_data(town,bytes)
    text['towns'][name] = { 'coords':coords, 'mono':mono}
    maps[name] = map
    dmaps[name] = dmap

for town in xtowns:
    with open(town,'r+b') as f:
        bytes = f.read()
    name,coords,mono,map,dmap = town_data(town,bytes)
    text['xtowns'][name] = { 'coords':coords, 'mono':mono}
    maps[name] = map
    dmaps[name] = dmap

for dng in dungeons:
    with open(dng,'r+b') as f:
        bytes = f.read()
    name,coords,trove,map = dungeon_data(dng,bytes)
    text['dungeons'][name] = { 'coords':coords, 'trove':trove}
    maps[name] = map

for realm in realms:
    key = realm.split('/')[-1].split('#')[0]
    with open(realm,'r+b') as f:
        bytes = f.read()
    maps[key] = get_nibbles(bytes,(80,80))

with open('text.json','w') as f:
    json.dump(text,f,sort_keys=True,indent=4)

with open('maps.json','w') as f:
    json.dump(maps,f,sort_keys=True,indent=4)

with open('dmaps.json','w') as f:
    json.dump(dmaps,f,sort_keys=True,indent=4)
