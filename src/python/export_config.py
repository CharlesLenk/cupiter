import json
import shutil
import platform
import os
from functools import cache

conf_file_name = 'export.conf'

def load_config():
    config = {}
    if shutil.which(conf_file_name) is not None:
        with open(conf_file_name, 'r') as file:
            config = json.load(file)
    return config

def assign_config_value(config, friendly_name, config_field_name, default_value):
    print('Enter {}. Press Enter for default ({})'.format(friendly_name, default_value))
    entered_value = input()
    value = entered_value if entered_value and entered_value.strip() else default_value
    print('Saving {}={} in export.conf'.format(config_field_name, value))

    config[config_field_name] = value
    with open(conf_file_name, 'w') as fp:
        json.dump(config, fp, indent=2)
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

@cache
def get_openscad_location():
    config = load_config()
    if config.get('openSCADLocation'):
        return config.get('openSCADLocation')
    else:
        default = get_default_openscad_location()
        return assign_config_value(config, 'OpenSCAD location', 'openSCADLocation', default)

@cache
def get_stl_output_directory():
    config = load_config()
    if config.get('stlOutputDirectory'):
        return config.get('stlOutputDirectory')
    else:
        default = os.path.join(os.path.expanduser('~'), 'Desktop') + '/cupiter_export/'
        return assign_config_value(config, 'STL output directory', 'stlOutputDirectory', default)
