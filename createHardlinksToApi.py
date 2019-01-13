import win32file
import win32api
import os
import ctypes, sys
    
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

if is_admin():
    apiFolder = "E:\computerCraftCode\Minecraft_TurtleApi"

    apiIdentifierString = "API_"

    for fileName in os.listdir(apiFolder):
        if(fileName.startswith(apiIdentifierString)):
            sourceFilePath = os.path.join(apiFolder,fileName)
            targetFilePath = os.path.join(os.getcwd(),fileName)
            if os.path.islink(targetFilePath):
                os.unlink(targetFilePath)
                
            os.symlink(sourceFilePath,targetFilePath)
else:
    # Re-run the program with admin rights
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)
