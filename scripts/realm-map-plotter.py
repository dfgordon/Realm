'''Uses MatPlotLib to render Realm maps in a convenient way.
Outside maps will show towns, castles, and dungeons.
Town maps will show denizens (as plot markers) and monologues.
Dungeon maps will show where troves are, and what they are.
The dungeon map is flattened into two columns of four levels each.'''

import glob
import json
import numpy as np
import PIL
from PIL import ImageFilter
import matplotlib as mpl
from matplotlib import pyplot as plt
from matplotlib.colors import ListedColormap as lcmap

mpl.rcParams['text.usetex'] = False

realm_colors = np.array([[0.0,0.0,0.0],
    [0.0,0.7,0.0],
    [0.5,0.3,0.3],
    [0.0,1.0,0.3],
    [0.1,0.5,1.0],
    [0.0,0.0,0.0],
    [1.0,0.3,0.0],
    [1.0,1.0,1.0],
    [0.5,0.2,0.0],
    [0.5,0.2,0.0],
    [0.0,0.0,0.0],
    [1.0,1.0,0.0],
    [1.0,1.0,1.0],
    [1.0,0.0,0.0],
    [1.0,1.0,1.0],
    [0.2,0.5,0.0],
    ])

town_colors = np.array([[0.3,0.0,0.3],
    [0.0,1.0,0.0],
    [0.3,0.0,0.3],
    [0.3,0.0,0.3],
    [0.0,0.0,1.0],
    [1.0,1.0,1.0],
    [1.0,0.0,1.0],
    [0.3,0.0,0.3],
    [0.3,0.0,0.3],
    [0.3,0.0,0.3],
    [0.0,0.0,0.0],
    [1.0,1.0,0.0],
    [1.0,0.1,0.0],
    [0.5,0.5,0.5],
    [0.3,0.0,0.3],
    [0.0,0.5,0.0],
    ])

denizen_marks = ['s','o','|','d','v','>','^','+','H','*','*','*','*','X','p']

dungeon_colors = np.array([[1.0,1.0,0.0],
    [1.0,1.0,0.0],
    [0.3,0.3,0.3],
    [0.0,0.0,0.0],
    [0.0,0.0,1.0],
    [0.0,1.0,0.8],
    [0.0,1.0,1.0],
    [0.5,0.5,0.5],
    [0.0,0.0,0.0],
    [1.0,0.5,0.0],
    [1.0,1.0,1.0],
    [0.0,0.0,0.0],
    [1.0,1.0,1.0],
    [0.0,1.0,0.0],
    [0.0,0.0,0.0],
    [1.0,0.0,0.0],
    ])

def make_map_array(map):
    ans = np.zeros((len(map),len(map[0])))
    for i,s in enumerate(map):
        for j,c in enumerate(s):
            ans[i,j] = ord(c)-65
    return ans

def disp_map(ary):
    plt.figure()
    if ary.shape==(160,20):
        plt.imshow(np.hstack((ary[:80,:],2*np.ones((80,4)),ary[80:,:])),vmin=0,vmax=15,cmap=lcmap(dungeon_colors))
    if ary.shape==(40,40):
        plt.imshow(ary,vmin=0,vmax=15,cmap=lcmap(town_colors))
    if ary.shape==(80,80):
        plt.imshow(ary,vmin=0,vmax=15,cmap=lcmap(realm_colors))
    plt.axis('off')

def fortycolumns(s):
    if len(s)>40:
        s = s[:40] + '\n' + s[40:]
    if len(s)>80:
        s = s[:81] + '\n' + s[81:]
    return s

def get_locality_name(typ,x,y):
    return next((nm for nm in text[typ] if text[typ][nm]['coords']==[str(x),str(y)]),None)

with open('maps.json') as f:
    maps = json.load(f)
with open('dmaps.json') as f:
    dmaps = json.load(f)
with open('text.json') as f:
    text = json.load(f)

print('(t)own, (d)ungeon, (o)utside')
ans = input()

names = []
for m in maps:
    if ans.lower()=='t' and len(maps[m])==40:
        names += [m]
    if ans.lower()=='o' and len(maps[m])==80:
        names += [m]
    if ans.lower()=='d' and len(maps[m])==160:
        names += [m]
for i in range(len(names)):
    print(i,names[i])

print('select number: ')
name = names[int(input())]

ary = make_map_array(maps[name])
disp_map(ary)
if ary.shape==(40,40):
    dary = make_map_array(dmaps[name])
    denizen_loc = np.where(dary<15)
    mono_idx = 0
    for i,y in enumerate(denizen_loc[0]):
        x = denizen_loc[1][i]
        d = int(dary[y,x])
        plt.plot(x,y,denizen_marks[d],color=(0,0,0))
        if d>=9 and d <=14:
            try:
                mono = text['towns'][name]['mono'][mono_idx]
            except KeyError:
                mono = text['xtowns'][name]['mono'][mono_idx]
            mono = fortycolumns(mono)
            xt = 40
            yt = mono_idx*6
            plt.annotate(mono,xy=(x,y),xytext=(xt,yt),arrowprops={'width':0.25,'headwidth':2,'headlength':2},fontsize=6)
            mono_idx += 1
if ary.shape==(80,80):
    town_loc = np.where(np.logical_or(ary==14,ary==7))
    dungeon_loc = np.where(ary==13)
    for i,y in enumerate(town_loc[0]):
        x = town_loc[1][i]
        if name=='ARRINEA':
            typ = 'towns'
        else:
            typ = 'xtowns'
        lname = get_locality_name(typ,x,y)
        plt.annotate(lname.lower(),xy=(x,y),fontsize=6)
    for i,y in enumerate(dungeon_loc[0]):
        x = dungeon_loc[1][i]
        typ = 'dungeons'
        lname = get_locality_name(typ,x,y)
        plt.annotate(lname.lower(),xy=(x,y),fontsize=6)
if ary.shape==(160,20):
    trove_idx = 0
    trove_loc = np.where(ary==13)
    for i,y in enumerate(trove_loc[0]):
        x = trove_loc[1][i]
        trove = text['dungeons'][name]['trove'][trove_idx]
        trove = fortycolumns(trove)
        if y<80:
            idx0 = trove_idx
            xt = -30
            yt = trove_idx*14
            dy = 0
            dx = 0
        else:
            xt = 44
            yt = (trove_idx - idx0 - 1)*14
            dy = -80
            dx = 24
        plt.annotate(trove,xy=(x+dx,y+dy),xytext=(xt,yt),arrowprops={'width':0.25,'headwidth':2,'headlength':2},fontsize=6)
        trove_idx += 1

plt.show()

# with PIL.Image.open('map.png') as im:
#     im1 = im.filter(PIL.ImageFilter.BLUR)
#     im1.show()
