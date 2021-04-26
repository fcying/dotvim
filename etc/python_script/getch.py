class Getch:     
    def __init__(self):
        import platform
        
        sysstr = platform.system()
        if sysstr == "Windows":
            self.impl = _GetchWindows()
        elif sysstr == "Linux":
            self.impl = _GetchLinux()
        else:
            print ("unknown system, no work!!!")    
 
    def __call__(self): 
        return self.impl()
 
class _GetchLinux: 
    def __call__(self): 
        import tty, sys, termios # import termios now or else you'll get the Unix version on the Mac
 
        fd = sys.stdin.fileno() 
        old_settings = termios.tcgetattr(fd) 
        try:
            tty.setraw(fd)
            ch = sys.stdin.read(1) 
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
 
        return ch
 
class _GetchWindows:
    def __call__(self):
        import msvcrt
        return msvcrt.getch().decode("ascii")

        
if __name__ == '__main__': # a little test 
    import sys, time

    print('Press a key')

    inkey = Getch()
    while True:
        time.sleep(0.5)
        k=inkey()
        print('you pressed ',k, type(k))
        if k == 'q': 
            break
