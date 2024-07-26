import json
import shutil
import platform
import os
from functools import cache
from subprocess import Popen, PIPE

conf_file_name = 'export.conf'

def load_config():
    config = {}
    if shutil.which(conf_file_name) is not None:
        with open(conf_file_name, 'r') as file:
            config = json.load(file)
    return config

def prompt_for_user_override(friendly_name, default_value):
    print('Enter {}. Press Enter for default ({})'.format(friendly_name, default_value))
    entered_value = input()
    value = entered_value if entered_value and entered_value.strip() else default_value
    return value

def assign_config_value(config, field_name, value):
    print('Saving {}={} in export.conf'.format(field_name, value))

    config[field_name] = value
    with open(conf_file_name, 'w') as file:
        json.dump(config, file, indent=2)
    return value

def get_default_openscad_location():
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
    return location

def check_manifold_support():
    openscad_location = get_openscad_location()
    process = Popen([openscad_location, '-h'], stdout=PIPE, stderr=PIPE)
    _, out = process.communicate()
    return 'manifold' in str(out)

@cache
def get_openscad_location():
    field_name = 'openSCADLocation'
    config = load_config()
    if config.get(field_name):
        return config.get(field_name)
    else:
        default = get_default_openscad_location()
        value = prompt_for_user_override('OpenSCAD location', default)
        return assign_config_value(config, field_name, value)

@cache
def get_stl_output_directory():
    field_name = 'stlOutputDirectory'
    config = load_config()
    if config.get(field_name):
        return config.get(field_name)
    else:
        default = os.path.join(os.path.expanduser('~'), 'Desktop') + '/cupiter_export'
        value = prompt_for_user_override('STL output directory', default)
        return assign_config_value(config, field_name, value)

@cache
def get_manifold_support():
    field_name = 'supportsManifold'
    config = load_config()
    if config.get(field_name) is not None:
        return config.get(field_name)
    else:
        value = check_manifold_support()
        return assign_config_value(config, field_name, value)

def init_config():
    get_openscad_location()
    get_stl_output_directory()
    get_manifold_support()

init_config()
