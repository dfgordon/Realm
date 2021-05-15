'''When editing BASIC on a modern editor we lose what little
error checking there was on the Apple II.
This script does some basic checks.'''

import glob
import re

files = sorted(glob.glob("../source/*.bas") + glob.glob("../prodos/*.bas"))

for path in files:

    print('Checking',path.split('/')[-1].split('.')[0])

    with open(path,'r') as f:
        text = f.read()
    lines = text.split('\n')

    nums = [-1]
    for line in lines:
        words = line.split()
        if len(words)>0:
            try:
                nums += [int(line.split()[0])]
                if nums[-1]<=nums[-2]:
                    print('Problem on line',nums[-1])
                    print('Fix this line and the run again.')
                    exit(1)
            except ValueError:
                print('WARNING: first word not a number')
                print(line)

    str_line_nums = list(map(str,nums))

    # We have to do the following by line so we can exclude branches to another program
    for line in lines:
        match = re.search(r'POKE\s+103,',line)
        if not match:
            matches = re.findall(r'[\s:](GOTO|GOSUB|THEN)\s+([0-9]+)',line)
            for s in matches:
                if s[1] not in str_line_nums:
                    print(s[0],'non existant line',s[1])
                    exit(1)

print("Found no errors.")
