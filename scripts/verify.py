'''Checks consistency of certain blocks of code across the different programs.
Also checks that inventory short-hand satisfies uniqueness.
Various other checks are handled by a2kit language servers.'''

import re

# Check for consistencies across files

def get_line_table(files,start,end):
    '''loads a set of lines from several files in a table
    of the form chklines[file][line]'''
    chklines = []
    num_files = len(files)
    for i in range(num_files):
        chklines += [[]]
        with open(files[i],'r') as f:
            lines = f.read().split('\n')
            for line in lines:
                words = line.split()
                if len(words)>0:
                    num = int(line.split()[0])
                    if num>=start and num<end:
                        chklines[i] += [line]
    return chklines

def check_consistency(chklines,cat_str):
    n = len(chklines)
    for i in range(n-1):
        if len(chklines[i])!=len(chklines[i+1]):
            print('Number of '+cat_str+' lines not matching:')
            print(files[i],files[i+1])
    for i in range(len(chklines[0])):
        for j in range(n-1):
            if chklines[j][i]!=chklines[j+1][i]:
                print('Lines different:')
                print(files[j]+':')
                print(chklines[j][i])
                print(files[j+1]+':')
                print(chklines[j+1][i])
                exit(1)
    print(cat_str,'OK')

print('Consistency checks:')
print('-------------------')
files = ["../basic-dos33/DUNGEON.bas","../basic-dos33/OUTSIDE.bas","../basic-common/TOWN.bas"]
files += ["../basic-prodos/DUNGEON.bas","../basic-prodos/OUTSIDE.bas"]
chklines = get_line_table(files,2000,4500)
check_consistency(chklines,'inventory handling')
chklines = get_line_table(files,130,139)
check_consistency(chklines,'movement')
chklines = get_line_table(files,150,160)
check_consistency(chklines,'fast status')
chklines = get_line_table(files,190,200)
check_consistency(chklines,'select character, oops handler')
chklines = get_line_table(files,700,724)
check_consistency(chklines,'casting')
chklines = get_line_table(files,1000,1010)
check_consistency(chklines,'using')
chklines = get_line_table(files,750,790)
check_consistency(chklines,'healing and raising')

files = ["../basic-common/WEAPARM.bas","../basic-common/ALCHEMIST.bas"]
chklines = get_line_table(files,21,41)
check_consistency(chklines,'placement')

files = ["../basic-common/COMBAT.bas","../basic-dos33/FINAL.bas","../basic-prodos/FINAL.bas"]
chklines = get_line_table(files,2800,2900)
check_consistency(chklines,'combat inventory')
chklines = get_line_table(files,3100,3200)
check_consistency(chklines,'defenses')

files = ["../basic-dos33/AUTOSTART.bas","../basic-dos33/LAUNCH.bas","../basic-prodos/LAUNCH.bas"]
chklines = get_line_table(files,8300,8400)
check_consistency(chklines,'proficiency table')
chklines = get_line_table(files,8050,8200)
check_consistency(chklines,'global declarations')

# In v1.5.0 the LAUNCH programs have further diverged
# so checks a bit more restricted than we would like
files = ["../basic-dos33/LAUNCH.bas","../basic-prodos/LAUNCH.bas"]
# chklines = get_line_table(files,102,200)
# check_consistency(chklines,'main menu')
# chklines = get_line_table(files,200,400)
# check_consistency(chklines,'character generator subs')
chklines = get_line_table(files,1100,1516)
check_consistency(chklines,'character generator')
chklines = get_line_table(files,1800,1950)
check_consistency(chklines,'party ops')
chklines = get_line_table(files,7500,7625)
check_consistency(chklines,'help')

# Check inventory short-hand used in COMBAT.bas

shorthand = []
with open('../basic-common/COMBAT.bas','r') as f:
    lines = f.read().split('\n')
for line in lines:
    matches = re.findall(r'W\$\s*\=\s*\"([\w\+]+)\"',line)
    for s in matches:
        shorthand += [s]
shortset = set(shorthand)
if len(shortset)!=len(shorthand):
    print('Duplicated shorthand for item')
    print(shorthand)
    exit(1)
for s in shorthand:
    if s in ['PLY','GOY','SIY','GRM','REM','CLM']:
        print('Shorthand conflict with key or prism:',s)
        exit(1)
    if s in ['LER','CHN','PLE','LE+','CH+','PL+']:
        print('Shorthand conflict with armor:',s)
        exit(1)
    if s[:2] in ['PO','AM','FL']:
        print('Possible shorthand conflict with magic item:',s)
        exit(1)
print('Shorthand item strings OK.')
print("Found no errors.")
