import os
from concurrent.futures import ThreadPoolExecutor
from subprocess import Popen, PIPE
from export_config import get_openscad_location, get_manifold_support, get_project_root

images_map = {
    'alternate_hands':      '38,8,13,37,0,29,156',
    'socket_assembly_note': '-2,5,-2,230,0,113,67',
    'shoulder_note':        '-3,-16,1,224,0,251,126',

    'arm_frame_exploded':   '-2,36,-2,234,0,66,173',
    'arm_frame':            '-2,36,-2,234,0,66,173',
    'arm_upper_armor':      '-2,36,-2,234,0,66,173',
    'arm_lower_armor':      '-2,36,-2,234,0,66,173',
    'hand':                 '-2,36,-2,234,0,66,173',
    'hand_armor':           '-2,36,-2,234,0,66,173',
    'arm_assembled':        '-2,36,-2,234,0,66,173',

    'torso_frame_exploded': '-3,24,2,56,0,247,213',
    'torso_frame':          '-3,24,2,56,0,247,213',
    'pelvis_armor':         '-3,24,2,56,0,247,213',
    'waist_armor':          '-3,24,2,56,0,247,213',
    'torso_assembled':      '-3,24,2,56,0,247,213',

    'upper_body_arms_exploded':     '-1,13,4,17,0,182,300',
    'upper_body_arms':              '-1,13,4,17,0,182,300',
    'upper_body_chest_armor':       '-11,6,5,61,0,227,213',
    'upper_body_shoulder_armor':    '-1,13,4,17,0,182,300',
    'upper_body_assembled':         '-1,13,4,17,0,182,300',

    'leg_frame_exploded':   '-4,48,3,58,0,292,237',
    'leg_frame':            '-4,48,3,58,0,292,220',
    'leg_upper_armor':      '-4,48,3,58,0,292,220',
    'leg_lower_armor':      '-4,48,3,58,0,292,220',
    'foot_socket':          '-4,48,3,58,0,292,230',
    'foot':                 '-4,48,3,58,0,292,230',
    'leg_assembled':        '-4,48,3,58,0,292,230',

    'body_legs_exploded':   '-9,55,6,21,0,187,390',
    'body_legs_assembled':  '-9,55,6,21,0,187,390',
    'body_hip_armor':       '-9,55,6,21,0,187,390',
    'body_assembled':       '-9,55,6,21,0,187,390',
    'body_arms_lowered':    '-9,55,6,21,0,187,390',

    'camera_head_exploded':         '9,5,5,60,0,47,126',
    'camera_head_assembled':        '9,5,5,60,0,47,126',
    'body_camera_head_exploded':    '0,35,6,34,0,240,315',
    'body_camera_head_assembled':   '0,35,6,34,0,240,315',

    'space_head_exploded':          '-5,5,9,61,0,219,113',
    'space_head_assembled':         '-5,5,9,61,0,219,113',
    'body_space_head_exploded':     '0,35,6,34,0,240,315',
    'body_space_head_assembled':    '0,35,6,34,0,240,315',

    'wing_clip':                    '6,5,-4,55,0,217,83',
    'upper_body_chest_armor_wings': '-11,6,5,61,0,227,213',
}

def generate_image(image_name, camera_pos):
    image_file_name = image_name + '.png'

    args = [
        get_openscad_location(),
        '-Dpart="' + image_name + '"',
        '--camera=' + camera_pos,
        '--colorscheme=Tomorrow Night',
        '--imgsize=2000,1200',
        '-o' + get_project_root() + '/instructions/images/' + image_file_name,
        get_project_root() + '/src/scad/assembly image map.scad'
    ]

    if get_manifold_support():
        args.extend(['--enable=manifold', '--render=true'])
    else:
        args.extend(['-D$fs=0.4', '-D$fa=0.8'])

    process = Popen(args, stdout=PIPE, stderr=PIPE)
    _, err = process.communicate()

    output = ""
    if (process.returncode == 0):
        output += 'Finished generating: ' + image_file_name
    else:
        output += 'Failed to generate: ' + image_file_name + ', Error: ' + str(err)
    return output

def generate_images():
    with ThreadPoolExecutor(max_workers = os.cpu_count()) as executor:
        print('Starting image generation')
        futures = []
        for image_name, camera_pos in images_map.items():
            futures.append(executor.submit(generate_image, image_name, camera_pos))
        for future in futures:
            print(future.result())
        print('Done!')

generate_images()
