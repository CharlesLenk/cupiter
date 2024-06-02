import os
import shutil
from concurrent.futures import ThreadPoolExecutor
from subprocess import Popen, PIPE
from export_util import get_openscad_location

part_groups = {
    'hand_simple_armor': {
        'hand_simple_armor': 2
    }
}

def get_base_output_directory():
    return os.path.join(os.path.expanduser('~'), 'Desktop') + '/robot_export/'

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
