'''This program stages binary and text files in folders that
correspond to the contents of a floppy disk image.  They can
then be transferred en masse using CiderPress.
The TXT extensions have to be removed by hand.
This worklow is now supplanted by Virtual ][ scripts.'''

import json
import pathlib
import shutil
import os
import warnings

machine_code = [("MRC3",(0,1,2)),
  ("OUTSIDE.INTRP",(0,1)),
  ("S2",(0,3)),
  ("SDP.INTRP",(0,1,2)),
  ("TOWN.INTRP2",(0,1)),
  ("DNGN.INTRP",(2,))
  ]

sprites = [("OUTSPS",(0,1)),
  ("TWNSPS",(0,1)),
  ("DNGNSPS",(2,))]

frames = [("FRAMEO",(0,1)),
  ("FRAMED",(2,)),
  ("FRAMEM",(2,))]

text = [("DD",(0,3)),
  ("PLIST",(0,3)),
  ("MONSTERS",(2,))]

dest = pathlib.Path.home() / 'Documents' / 'appleii'
src = pathlib.Path.home() / 'Documents' / 'appleii' / 'Realm'

def deploy(s,f,typ=''):
    if typ=='b':
        res = list((src/s).glob(f[0]+'#*'))
    else:
        res = list((src/s).glob(f[0]+'.TXT'))
    if len(res)==1:
        for i in f[1]:
            d = 'realm-disk' + str(i)
            shutil.copy(res[0],dest/d)
    else:
        print(res)
        raise ValueError('found too many matches')

# Setup directory structure

for i in range(4):
    d = 'realm-disk' + str(i)
    if (dest / d).exists():
        if (dest / d).is_dir():
            warnings.warn('Deleting existing directory tree '+d)
            shutil.rmtree(dest/d)
        else:
            warnings.warn('Deleting existing file '+d)
            (dest/d).unlink()
    os.mkdir(dest / d)

# Copy stuff that goes uniquely to one disk

shutil.copy(src/'arrinea-maps'/'ARRINEA#068000',dest/'realm-disk3')
shutil.copy(src/'exo-maps'/'FONKRAKIS#068000',dest/'realm-disk3')
shutil.copy(src/'exo-maps'/'ABYSS#068000',dest/'realm-disk3')
shutil.copy(src/'exo-maps'/'WORNOTH#068000',dest/'realm-disk3')

maps = (src/'arrinea-maps').glob('*')
for f in maps:
    shutil.copy(f,dest/'realm-disk0')

exomaps = (src/'exo-maps').glob('*')
for f in exomaps:
    shutil.copy(f,dest/'realm-disk1')

art = (src/'artwork-squeezed').glob('*')
for f in art:
    if 'FRAME' not in str(f):
        shutil.copy(f,dest/'realm-disk2')

shutil.copy(src/'TITLE.PIC#062000',dest/'realm-disk3')

# Copy stuff that may go to multiple places

for f in machine_code:
    deploy('machine-code',f,'b')

for f in sprites:
    deploy('sprites',f,'b')

for f in frames:
    deploy('artwork-squeezed',f,'b')

for f in text:
    deploy('source',f)
