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
    #you have to here fill in the path to your local repo here, where your api folder is
    apiFolder = "C:\\dev\\private\\repos\\Minecraft_TurtleApi\Api"
    programsFolder = "C:\\dev\\private\\repos\\Minecraft_TurtleApi\Programs"
    cwd = os.path.dirname(__file__)

    targetApi = os.path.join(os.getcwd(),"Api")
    os.symlink(apiFolder,targetApi)

    targetPrograms = os.path.join(os.getcwd(),"Programs")
    os.symlink(programsFolder,targetPrograms)

if is_admin():
    appMain()
    print("Created hard links to Api")
    print("Created hard links to Programs")
else:
    # Re-run the program with admin rights
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)

