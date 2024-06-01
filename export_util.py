import platform
import shutil

def get_openscad_location():
    system = platform.system()
    location = ''
    if (system == 'Windows'):
        nightly_path = 'C:\\Program Files\\OpenSCAD (Nightly)\\openscad.exe'
        if (shutil.which(nightly_path) is not None):
            location = nightly_path
        else:
            location = 'C:\\Program Files\\OpenSCAD\\openscad.exe'
    return location
