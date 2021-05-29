'''This program reads a binary and saves it
as lines to be typed into the Apple ][ Monitor.
The saved file is intended to be used by AppleScript
to enter the binary data into Virtual ][.
This is far faster than trying to do it directly
in AppleScript.

usage: python binary2monitor.py <path> [<addr>]
optional <addr> is in decimal.
if <addr> not given or 0 we get it from CiderPress postfix.'''

import sys

src = sys.argv[1]
if len(sys.argv) < 3:
    addr = 0
else:
    addr = int(sys.argv[2])
if addr==0:
    addr = int(src.split('#')[-1][2:],16)

with open(src,'r+b') as f:
    bytes = f.read()

n = len(bytes)
octets = int(n/8)
remainder = n % 8

out = ''
for i in range(octets):
    out += str(hex(addr + i*8))[2:].upper() + ':'
    for b in bytes[i*8:(i+1)*8]:
        out += ' ' + str(hex(b))[2:].upper()
    out += '\n'

if remainder>0:
    out += str(hex(addr + octets*8))[2:].upper() + ':'
    for b in bytes[octets*8:octets*8+remainder]:
        out += ' ' + str(hex(b))[2:].upper()

print(addr)
print(n)
print(out,end='')
