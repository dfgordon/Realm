
'''Diff tokenized BASIC programs and disk catalogs
comparing one version to another.

This was developed to help verify the new a2kit based deploy scripts
against the previous method based on Virtual II.
A limitation is that we opted to use `a2kit minify` on the ProDOS version,
which makes the diff with the prior version large.
On the other hand, the DOS version was left un-minified,
and it shows no difference anywhere except for the version number.

This can also be used to test whether different a2kit versions are
producing consistent output.'''

import pathlib
import sys
import difflib
import json
import a2kit

if not a2kit.chk_vers((1,8,0),(2,4,2)):
    exit(1)

issue_count = 0

if len(sys.argv)!=6:
    print('usage: python '+sys.argv[0]+' <base_path> <old_v> <new_v> <old_ext> <new_ext>')
    print('ex: python diff-vers.py . 150 151 woz 2mg')
    exit(1)
base_path = pathlib.Path(sys.argv[1])
v1 = sys.argv[2]
v2 = sys.argv[3]
x1 = sys.argv[4]
x2 = sys.argv[5]

v1_path = base_path / ('Realm-v'+v1)
v2_path = base_path / ('Realm-v'+v2)

bas_files = [
    {"name": "ALCHEMIST", "load": 0x800, "disks": [0,1], "folder": "PROG"},
    {"name": "ARCHWIZ", "load": 0xb00, "disks": [0], "folder": "PROG"},
    {"name": "BARON", "load": 0x800, "disks": [1], "folder": "PROG"},
    {"name": "CHAIN", "load": 0x1000, "disks": [0,1,2], "folder": "PROG"},
    {"name": "COMBAT", "load": 0x4000, "disks": [0,1,2], "folder": "PROG"},
    {"name": "DUNGEON", "load": 0x4000, "disks": [2], "folder": "PROG"},
    {"name": "FOOD", "load": 0xb00, "disks": [0,1], "folder": "PROG"},
    {"name": "HIGH.PRIEST", "load": 0x1000, "disks": [2], "folder": "PROG"},
    {"name": "LIBRARY", "load": 0x800, "disks": [0,1], "folder": "PROG"},
    {"name": "FINAL", "load": 0x800, "disks": [2], "folder": "PROG"},
    {"name": "OUTSIDE", "load": 0x4000, "disks": [0,1], "folder": "PROG"},
    {"name": "PUB", "load": 0x800, "disks": [0,1], "folder": "PROG"},
    {"name": "SAGE", "load": 0xb00, "disks": [0], "folder": "PROG"},
    {"name": "SAVE.GAME", "load": 0x800, "disks": [0], "folder": "PROG"},
    {"name": "SHIPYARD", "load": 0xb00, "disks": [0,1], "folder": "PROG"},
    {"name": "TEMPLE", "load": 0x800, "disks": [0,1], "folder": "PROG"},
    {"name": "TOWN", "load": 0x4000, "disks": [0,1], "folder": "PROG"},
    {"name": "WEAPARM", "load": 0x800, "disks": [0,1], "folder": "PROG"},
    {"name": "AUTOSTART", "load": None, "disks": [0], "folder": None},
    {"name": "GUTEN TAG", "load": None, "disks": [0,3], "folder": None},
    {"name": "LAUNCH", "load": None, "disks": [3], "folder": "PROG"},
    {"name": "DISK0", "load": None, "disks": [0], "folder": None},
    {"name": "DISK1", "load": None, "disks": [1], "folder": None},
    {"name": "DISK2", "load": None, "disks": [2], "folder": None},
    {"name": "DISK3", "load": None, "disks": [3], "folder": None},
]

disk_name = (
    'realm-dos33-master',
    'realm-dos33-dungeon',
    'realm-dos33-monster',
    'realm-dos33-setup'
)

# Find differences in tokenized BASIC files

def compare_tokens(v1_disk,v2_disk,nibbles_to_skip,path):
    global issue_count
    tok1 = json.loads(a2kit.beg(['get','-d',v1_disk,'-t','any','-f',path],True))
    tok2 = json.loads(a2kit.beg(['get','-d',v2_disk,'-t','any','-f',path],True))
    for k in tok1:
        if k not in ['created','modified','chunks']:
            if tok1[k] != tok2[k]:
                issue_count += 1
                print('value of ' + k + ' differs')
    count1 = len(tok1['chunks'])
    count2 = len(tok2['chunks'])
    if count1!=count2:
        print('chunk count different',count1,count2)
    for i in range(0,min(count1,count2)):
        tst1 = tok1['chunks'][str(i)]
        tst2 = tok2['chunks'][str(i)]
        if i==0:
            start = nibbles_to_skip
        else:
            start = nibbles_to_skip
        end1 = tst1.find('000000')
        end2 = tst2.find('000000')
        if end1==-1:
            end1 = len(tst1)
        if end2==-1:
            end2 = len(tst2)
        if end1!=end2:
            print('ending different',end1,end2)
        if tst1[start:end1]!=tst2[start:end2]:
            subchunk_size = 64
            issue_count += 1
            print('differing chunk',i)
            subchunks = 1 + int(min(end1,end2)/subchunk_size)
            for j in range(subchunks):
                subtst1 = tst1[start+subchunk_size*j : start+subchunk_size*(j+1)]
                subtst2 = tst2[start+subchunk_size*j : start+subchunk_size*(j+1)]
                if subtst1!=subtst2:
                    print('subchunk',j)
                    dif = difflib.Differ().compare(
                        subtst1.splitlines(True),
                        subtst2.splitlines(True))
                    print('\n'.join(dif))
        else:
            print(i,end=".")
    print()

for dict in bas_files:
    print('processing',dict['name'])
    
    print('DOS')
    if dict['load']==None:
        nibbles_to_skip = 4 # skip length header
    else:
        nibbles_to_skip = 8 # skip load address and length header
    v1_disk = v1_path / (disk_name[dict['disks'][0]] + "-v" + v1 + "." + x1)
    v2_disk = v2_path / (disk_name[dict['disks'][0]] + "-v" + v2 + "." + x2)
    path = dict['name']
    compare_tokens(v1_disk,v2_disk,nibbles_to_skip,path)

    if dict['folder']==None:
        continue
    print('ProDOS')
    v1_disk = v1_path / ("realm-prodos-v" + v1 + ".po")
    v2_disk = v2_path / ("realm-prodos-v" + v2 + ".po")
    path = 'REALM/' + dict['folder'] + '/' + dict['name']
    compare_tokens(v1_disk,v2_disk,0,path)

# Install Program
print('processing','STARTUP')
v1_disk = v1_path / ("realm-install-1-v" + v1 + ".woz")
v2_disk = v2_path / ("realm-install-1-v" + v2 + ".woz")
compare_tokens(v1_disk,v2_disk,0,'STARTUP')


# Catalogs

def check_cats(cat1,cat2,disk,row1,row2,col1,col2):
    global issue_count
    catset1 = set()
    catset2 = set()
    for line in cat1[row1:row2]:
        if len(line)>col1:
            catset1.add(line[col1:col2])
    for line in cat2[row1:row2]:
        if len(line)>col1:
            catset2.add(line[col1:col2])
    if catset1!=catset2:
        issue_count += 1
        print(disk,'catalogs different')
        print(catset1)
        print(catset2)
    else:
        print(disk,'catalogs the same')

# See if DOS 3.3 catalogs contain the same files

for d in range(0,4):
    v1_disk = v1_path / (disk_name[d] + "-v" + v1 + "." + x1)
    v2_disk = v2_path / (disk_name[d] + "-v" + v2 + "." + x2)
    cat1 = a2kit.beg(['catalog','-d',v1_disk],True).splitlines()
    cat2 = a2kit.beg(['catalog','-d',v2_disk],True).splitlines()
    check_cats(cat1,cat2,disk_name[d],3,None,7,None)

# See if installer catalogs contain the same files

for d in range(0,3):
    v1_disk = v1_path / ("realm-install-"+str(d+1)+"-v" + v1 + ".woz")
    v2_disk = v2_path / ("realm-install-"+str(d+1)+"-v" + v2 + ".woz")
    cat1 = a2kit.beg(['catalog','-d',v1_disk,'-f','items'],True).splitlines()
    cat2 = a2kit.beg(['catalog','-d',v2_disk,'-f','items'],True).splitlines()
    check_cats(cat1,cat2,'realm-install-'+str(d+1)+'/items',5,-3,0,16)

# See if ProDOS catalogs contain the same files
# (ignore PARTIES)

dirs = ['REALM','REALM/PROG','REALM/BIN','REALM/MAPS','REALM/XMAPS','REALM/MONSTERS']

v1_disk = v1_path / ('realm-prodos-v' + v1 + ".po")
v2_disk = v2_path / ('realm-prodos-v' + v2 + ".po")
cat1 = a2kit.beg(['catalog','-d',v1_disk],True).splitlines()
cat2 = a2kit.beg(['catalog','-d',v2_disk],True).splitlines()
check_cats(cat1,cat2,'realm-prodos',5,-3,0,16)
for dir in dirs:
    cat1 = a2kit.beg(['catalog','-d',v1_disk,'-f',dir],True).splitlines()
    cat2 = a2kit.beg(['catalog','-d',v2_disk,'-f',dir],True).splitlines()
    check_cats(cat1,cat2,'realm-prodos/'+dir,5,-3,0,16)

print()
print('ISSUE COUNT =',issue_count)