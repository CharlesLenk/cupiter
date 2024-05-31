import os
import platform
import shutil
from concurrent.futures import ThreadPoolExecutor
from subprocess import Popen, PIPE

part_groups = {
    'frame': {
        'lens': 1,
        'antenna_left': 1,
        'antenna_right': 1,
        'neck': 1,
        'chest': 1,
        'waist': 1,
        'pelvis': 1,
        'hip': 1,
        'arm_upper': 2,
        'arm_lower': 2,
        'leg_upper': 2,
        'leg_lower': 2,
        'shoulder': 2,
        'socket_with_snap_tabs': 3
    },
    'armor': {
        'head': 1,
        'chest_armor': 2,
        'waist_armor': 2,
        'pelvis_armor': 2,
        'hip_armor': 2,
        'arm_upper_armor_left': 2,
        'arm_upper_armor_right': 2,
        'arm_lower_armor_left': 2,
        'arm_lower_armor_right': 2,
        'leg_upper_armor_left': 2,
        'leg_upper_armor_right': 2,
        'leg_lower_armor_left': 2,
        'leg_lower_armor_right': 2,
        'shoulder_armor': 2,
        'foot': 2
    },
    'hand_complex_posed': {
        'hand_flat_right': 1,
        'hand_flat_left': 1,
        'hand_relaxed_right': 1,
        'hand_relaxed_left': 1,
        'hand_fist_right': 1,
        'hand_fist_left': 1,
        'hand_love_right': 1,
        'hand_love_left': 1,
        'hand_prosper_right': 1,
        'hand_prosper_left': 1,
        'hand_peace_right': 1,
        'hand_peace_left': 1,
        'hand_five_right': 1,
        'hand_five_left': 1,
        'hand_open_grip_right': 1,
        'hand_open_grip_left': 1
    },
    'hand_complex_grip': {
        'hand_grip_right': 1,
        'hand_grip_left': 1
    },
    'hand_complex_armor': {
        'hand_armor_right': 1,
        'hand_armor_left': 1
    },
    'hand_simple': {
        'hand_simple_right': 1,
        'hand_simple_left': 1
    },
    'hand_simple_armor': {
        'hand_simple_armor': 2
    }
}

def get_base_output_directory():
    return os.path.join(os.path.expanduser('~'), 'Desktop') + '/robot_export/'

def get_openscad_location():
    system = platform.system()
    location = ''
    if (system == 'Windows'):
        location = 'C:\\Program Files\\OpenSCAD (Nightly)\\openscad.exe'
    return location

def generate_part(openscad_location, output_directory, folder, part, count):
    part_file_name = part + '.stl'
    os.makedirs(output_directory, exist_ok=True)

    process = Popen([openscad_location,
                     '-Dpart="' + part + '"',
                     '-o' + output_directory + part_file_name,
                     'cad files/print map.scad'], stdout=PIPE, stderr=PIPE)
    out, err = process.communicate()

    output = ""
    if (process.returncode == 0):
        output += 'Finished generating: ' + folder + '/' + part_file_name
        for count in range(2, count + 1):
            part_copy_name = part + '_' + str(count) + '.stl'
            shutil.copy(output_directory + part_file_name, output_directory + part_copy_name)
            output += '\nFinished generating: ' + folder + '/' + part_copy_name
    else:
        output += 'Failed to generate: ' + folder + '/' + part_file_name + ', Error: ' + str(err)
    return output

def print_parts():
    with ThreadPoolExecutor(max_workers = os.cpu_count()) as executor:
        futures = []
        base_output_directory = get_base_output_directory()
        openscad_location = get_openscad_location()

        for folder, part_group in part_groups.items():
            output_directory = base_output_directory + folder + '/'
            for part, count in part_group.items():
                futures.append(executor.submit(generate_part, openscad_location, output_directory, folder, part, count))
        for future in futures:
            print(future.result())

print_parts()
