import json
import shutil
import platform
import os
import sys
from functools import cache
from subprocess import Popen, PIPE
from pathlib import PurePath
from threading import Lock

conf_file_name = 'export.conf'
lock = Lock()

projectRoot = 'projectRoot'
openSCADLocation = 'openSCADLocation'
stlOutputDirectory = 'stlOutputDirectory'
supportsManifold = 'supportsManifold'

def is_openscad_location_valid(location):
    return shutil.which(location) is not None

def _get_openscad_location():
    system = platform.system()
    location = ''
    if (system == 'Windows'):
        nightly_path = 'C:\\Program Files\\OpenSCAD (Nightly)\\openscad.exe'
        if (shutil.which(nightly_path) is not None):
            location = nightly_path
        else:
            location = 'C:\\Program Files\\OpenSCAD\\openscad.exe'
    elif (system == 'Darwin'):
        location = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD.app'
    elif (system == 'Linux'):
        location = 'openscad'

    while not is_openscad_location_valid(location) and location.strip() != 'q':
        print("OpenSCAD not found at {}".format(location))
        location = input('Enter OpenScad location or "q" to exit: ')

    if location == 'q':
        return ''
    else:
        return location

def check_manifold_support(openscad_location):
    if openscad_location:
        process = Popen([openscad_location, '-h'], stdout=PIPE, stderr=PIPE)
        _, out = process.communicate()
        return 'manifold' in str(out)
    else:
        return False

def validate_config(config):
    error = '{} is invalid. Please set {} in export.conf'
    if not os.path.isdir(config[projectRoot]):
        sys.exit(error.format(projectRoot, projectRoot))
    if not is_openscad_location_valid(config[openSCADLocation]):
        sys.exit(error.format(openSCADLocation, openSCADLocation))
    if not os.path.isdir(config[stlOutputDirectory]):
        sys.exit(error.format(stlOutputDirectory, stlOutputDirectory))

@cache
def load_config():
    project_root = PurePath(__file__).parents[2]
    conf_file = project_root / conf_file_name
    config = {}
    if shutil.which(conf_file) is not None:
        with open(conf_file, 'r') as file:
            config = json.load(file)
    else:
        config[projectRoot] = str(project_root)
        config[openSCADLocation] = _get_openscad_location()
        config[stlOutputDirectory] = os.path.join(os.path.expanduser('~'), 'Desktop', 'cupiter_export')
        config[supportsManifold] = check_manifold_support(config[openSCADLocation])
        for field_name, value in config.items():
            print('Saving {}={} in {}'.format(field_name, value, conf_file_name))
        with open(conf_file, 'w') as file:
            json.dump(config, file, indent=2)

    validate_config(config)
    return config

def get_project_root():
    with lock:
        return load_config().get(projectRoot)

def get_openscad_location():
    with lock:
        return load_config().get(openSCADLocation)

def get_stl_output_directory():
    with lock:
        return load_config().get(stlOutputDirectory)

def get_manifold_support():
    with lock:
        return load_config().get(supportsManifold)
