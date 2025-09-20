'''simple front end for a2kit'''
import subprocess
import platform

def verify_py(beg_vers: tuple, end_vers: tuple):
    '''Exit if python version falls outside range beg_vers..end_vers'''
    vers = tuple(map(int,platform.python_version_tuple()))
    if vers < beg_vers or vers >= end_vers:
        print("python version outside range",beg_vers,"..",end_vers)
        exit(1)

def verify_a2(beg_vers: tuple, end_vers: tuple):
    '''Exit if a2kit version falls outside range beg_vers..end_vers'''
    vers_raw = cmd(['-V']).decode('utf-8').split()[1].split('-')
    if len(vers_raw)>1:
        raise ValueError("this a2kit is a prerelease")
    vers = tuple(map(int, vers_raw[0].split('.')))
    if vers < beg_vers or vers >= end_vers:
        print("a2kit version outside range",beg_vers,"..",end_vers)
        exit(1)

def cmd(args, pipe_in=None):
    '''run a CLI command as a subprocess'''
    compl = subprocess.run(['a2kit']+args,input=pipe_in,capture_output=True,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout

def pack_bin(dat: bytes, load_addr: int, path: str, os: str):
    '''pack binary file into list of file images'''
    compl = subprocess.run(['a2kit','pack','-t','bin','-f',path,'-o',os,'-a',str(load_addr)],input=dat,capture_output=True,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout.decode('utf-8')

def pack_tok(dat: bytes, path: str, os: str):
    '''pack binary file into list of file images'''
    compl = subprocess.run(['a2kit','pack','-t','atok','-f',path,'-o',os],input=dat,capture_output=True,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout.decode('utf-8')

def pack_txt(dat: bytes, path: str, os: str):
    '''pack text file into list of file images'''
    compl = subprocess.run(['a2kit','pack','-t','txt','-f',path,'-o',os],input=dat,capture_output=True,text=False)
    if compl.returncode>0:
        print(compl.stderr)
        exit(1)
    return compl.stdout.decode('utf-8')

if __name__ == "__main__":
    print("this is a module, do not run directly")

