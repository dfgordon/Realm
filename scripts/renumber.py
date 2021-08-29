'''Do equivalent of APA's renumber command.
Ignores branches to other programs by looking for relevant POKE.
Branches from other programs must be fixed by hand.
Handles GOTO, GOSUB, THEN, accounting for ON patterns.'''

import glob
import re
import sys

if len(sys.argv)!=5:
    print('Usage: python renumber.py <file> <first> <step> <old first>')
    exit(0)

pathname = sys.argv[1]
first_line = int(sys.argv[2])
step = int(sys.argv[3])
old_first = int(sys.argv[4])
if old_first > first_line:
    raise ValueError('This might lead to duplicates or interleaving.')
line_now = first_line
line_map = {}

with open(sys.argv[1],'r') as f:
    text = f.read()

# Create the mapping and check line ordering

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
            if nums[-1]<old_first:
                line_map[nums[-1]] = nums[-1]
            else:
                line_map[nums[-1]] = line_now
                line_now += step
        except ValueError:
            print('WARNING: first word not a number')
            print(line)

nums = nums[1:]
str_line_nums = list(map(str,nums))

# Make sure no existing errors
# We have to do the following by line so we can exclude branches to another program

for line in lines:
    external_branch = re.search(r'POKE\s+103,',line)
    if not external_branch:
        matches = re.findall(r'[\s:](GOTO|GOSUB|THEN)\s+([0-9]+)',line)
        for s in matches:
            if s[1] not in str_line_nums:
                print(s[0],'non existant line',s[1])
                exit(1)

# Now create the renumbered program

def replace_line_nums(m):
    ans = m.group(1)
    ans += m.group(2)
    ans += ' '
    # This loop accounts for ON..GOTO patterns
    for s in m.group().split():
        for n in s.split(','):
            if n.strip().isnumeric():
                ans += str(line_map[int(n)]) + ','
    return ans[:-1]

new_lines = ""
for line in lines:
    if len(line)>0:
        try:
            # First the line number itself
            num = int(line.split()[0])
            new_line = re.sub(r'[0-9]+\s+(.+)',str(line_map[num])+r' \1',line)
            # Then branches
            external_branch = re.search(r'POKE\s+103,',line)
            if not external_branch:
                new_line = re.sub(r'([\s:])(GOTO|GOSUB|THEN)\s+([0-9]+\s*\,?\s*){1,}',replace_line_nums,new_line)
            new_lines += new_line + '\n'
        except ValueError:
            # Not an ordinary line, keep it with warning above
            new_lines += line + '\n'
    else:
        # Preserve blank lines
        new_lines += '\n'

print(new_lines)
