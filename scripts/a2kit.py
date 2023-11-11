'''simple front end for a2kit'''
import subprocess
import platform

def chk_vers(min_py_tup,min_a2_tup):
    '''are python and a2kit versions good'''
    pyvers = tuple(map(int,platform.python_version_tuple()))
    if pyvers < min_py_tup:
        print('script requires python',min_py_tup,'or higher')
        return False
    v = tuple(map(int,beg(['-V'],True).split()[1].split('.')))
    if v < min_a2_tup:
        print('script requires a2kit',min_a2_tup,'or higher')
        return False
    return True

def beg(args,txt=False):
    '''run a2kit and pipe the output'''
    compl = subprocess.run(['a2kit']+args,capture_output=True,text=txt)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout
def pipe(args,pipe_in,txt=False):
    '''run a2kit with piped input and output'''
    compl = subprocess.run(['a2kit']+args,input=pipe_in,capture_output=True,text=txt)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout
def end(args,pipe_in,txt=False):
    '''run a2kit with piped input and terminate output'''
    compl = subprocess.run(['a2kit']+args,input=pipe_in,text=txt)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout
