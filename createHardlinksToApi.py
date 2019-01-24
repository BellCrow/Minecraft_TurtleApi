import win32file
import win32api
import os
import ctypes, sys
    
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def appMain():
    apiFolder = "E:\computerCraftCode\Minecraft_TurtleApi\Api"
    cwd = os.path.dirname(__file__)
    targetApi = os.path.join(os.getcwd(),"Api")
    os.symlink(apiFolder,targetApi)

if is_admin():
    appMain()
else:
    # Re-run the program with admin rights
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)

