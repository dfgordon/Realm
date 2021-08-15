'''Check all maps for errors.  Assumes JSON files have been created.'''

import json
import pathlib

dest = pathlib.Path.home() / 'Documents' / 'appleii' / 'Realm'
realm_name = ['ABYSS','ARRINEA','FONKRAKIS','WORNOTH']
realm_dir = ['exo-maps','arrinea-maps','exo-maps','exo-maps']

def townfile(coords):
    t = 'TOWNPIC.' + coords[0] + '.' + coords[1] + '#068000'
    return str(dest / 'arrinea-maps' / t)

def xtownfile(coords):
    t = 'TOWNPIC.' + coords[0] + '.' + coords[1] + '#068000'
    return str(dest / 'exo-maps' / t)

def dungeonfile(coords):
    d = 'DNGPIC.' + coords[0] + '.' + coords[1] + '#068000'
    return str(dest / 'exo-maps'/ d)

def realmfile(idx):
    d = realm_name[idx] + '#068000'
    return str(dest / realm_dir[idx] / d)

def encode_terrain(c):
    return c.encode('ascii')[0] -'A'.encode('ascii')[0]

with open('text.json') as f:
    text = json.load(f)

with open('maps.json') as f:
    maps = json.load(f)

with open('dmaps.json') as f:
    dmaps = json.load(f)

def get_word_run(m,col):
    t = '\u0000 '
    f = col-1
    while m[f] not in t:
        f = f - 1
    wr1 = m[f+1:col]
    l = col
    while m[l] not in t:
        l = l + 1
    wr2 = m[col:l]
    return wr1+'|'+wr2

def check_towns(x):
    longest_mono = ''
    problems = 0
    word_runs = []
    if x:
        sub_dict = text['xtowns']
    else:
        sub_dict = text['towns']
    for town in sub_dict:
        print('Checking '+town)
        if len(town)>49:
            print(' * name too long')
            problems += 1
        coords = sub_dict[town]['coords']
        map = maps[town]
        dmap = dmaps[town]
        for i in range(7):
            mono = sub_dict[town]['mono'][i]
            if len(mono) > len(longest_mono):
                longest_mono = mono
            if len(mono)>119:
                print(' * run-on monologue: '+mono)
                problems += 1
            test = mono + '\u0000'*80
            if test[0].encode('ascii')[0]<26:
                test = test[1:]
            if test[40]==' ' or test[80]==' ':
                print(' * extra space: '+test)
                problems += 1
            word_runs += [get_word_run(test,40)]
            word_runs += [get_word_run(test,80)]
        for row in dmap:
            for ch in row:
                if ch == 'O':
                    print(' * pre-existing corpse found')
                    problems += 1
    return problems,longest_mono,word_runs

def check_dungeons():
    longest_trove = ''
    problems = 0
    for dungeon in text['dungeons']:
        print('Checking '+dungeon)
        if len(dungeon)>29:
            print(' * name too long')
            problems += 1
        coords = text['dungeons'][dungeon]['coords']
        map = maps[dungeon]
        for i in range(8):
            trove = text['dungeons'][dungeon]['trove'][i]
            if len(trove) > len(longest_trove):
                longest_trove = trove
            if len(trove)>49:
                print(' * run-on trove: '+trove)
                problems += 1
        for row in map:
            for ch in row:
                if ch == 'D':
                    print(' * pre-existing corpse found')
                    problems += 1
    return problems,longest_trove

def check_realms():
    problems = 0
    for idx in range(4):
        print('Checking '+realm_name[idx])
        map = maps[realm_name[idx]]
        for row in map:
            for ch in row:
                if ch == 'L':
                    print(' * Ship found')
                    problems += 1
    return problems

p1,long_mono_1,wr1 = check_towns(False)
p2,long_mono_2,wr2 = check_towns(True)
p3,long_trove = check_dungeons()
p4 = check_realms()

print('Longest Arrinea monologue =',len(long_mono_1))
print(long_mono_1)

print('Longest Outer monologue =',len(long_mono_2))
print(long_mono_2)

print('Longest trove =',len(long_trove))
print(long_trove)

print ('Word runs must be checked one by one:')
runs = wr1+wr2
for r in runs:
    if r[0] not in '\u0000 |':
        print(r)

print('Total problems =',p1+p2+p3+p4)
