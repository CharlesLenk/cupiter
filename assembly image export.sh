username=$(powershell.exe '$env:UserName' | tr -d '\n\r')
out_dir="assembly/images"
mkdir -p $out_dir
win_out_dir=$(wslpath -w $out_dir)
printf 'Output directory: %s\n' "$win_out_dir"

declare -A assembly_images=(
    ["socket_assembly_note"]=-2,5,-2,230,0,113,67
    ["shoulder_note"]=-3,-16,1,224,0,251,126

    ["arm_frame_exploded"]=-2,36,-2,234,0,66,173
    ["arm_frame"]=-2,36,-2,234,0,66,173
    ["arm_upper_armor"]=-2,36,-2,234,0,66,173
    ["arm_lower_armor"]=-2,36,-2,234,0,66,173
    ["hand"]=-2,36,-2,234,0,66,173
    ["hand_armor"]=-2,36,-2,234,0,66,173
    ["arm_assembled"]=-2,36,-2,234,0,66,173

    ["torso_frame_exploded"]=1,14,-3,234,0,247,263
    ["torso_frame"]=1,14,-3,234,0,247,200
    ["pelvis_armor"]=1,14,-3,234,0,247,200
    ["waist_armor"]=1,14,-3,234,0,247,200
    ["torso_assembled"]=1,14,-3,234,0,247,200

    ["upper_body_arms_exploded"]=-1,13,4,17,0,182,300
    ["upper_body_arms"]=-1,13,4,17,0,182,300
    ["upper_body_chest_armor"]=-11,6,5,61,0,227,213
    ["upper_body_shoulder_armor"]=-1,13,4,17,0,182,300
    ["upper_body_assembled"]=-1,13,4,17,0,182,300

    ["leg_frame_exploded"]=-4,48,3,58,0,292,237
    ["leg_frame"]=-4,48,3,58,0,292,220
    ["leg_upper_armor"]=-4,48,3,58,0,292,220
    ["leg_lower_armor"]=-4,48,3,58,0,292,220
    ["foot_socket"]=-4,48,3,58,0,292,230
    ["foot"]=-4,48,3,58,0,292,230
    ["leg_assembled"]=-4,48,3,58,0,292,230

    ["body_legs_exploded"]=-9,55,6,21,0,187,390
    ["body_legs_assembled"]=-9,55,6,21,0,187,390
    ["body_hip_armor"]=-9,55,6,21,0,187,390
    ["body_assembled"]=-9,55,6,21,0,187,390
    ["body_arms_lowered"]=-9,55,6,21,0,187,390

    ["head_exploded"]=9,5,5,60,0,47,126
    ["head_assembled"]=9,5,5,60,0,47,126
    ["body_head_exploded"]=0,35,6,34,0,240,315
    ["assembled"]=0,35,6,34,0,240,315
)

function generate_images {
    for name in "$@"
    do
        declare -n parts=$name
        for part in "${!parts[@]}"
        do
            ("/mnt/c/Program Files/OpenSCAD/openscad.exe" -Dpart="\"$part\"" -D\$fs=0.4 -D\$fa=0.8 --camera=${parts[$part]} -q --colorscheme=Tomorrow\ Night --imgsize=2000,1200 -o $out_dir/$part.png "cad files"/assembly\ image\ map.scad;
                printf 'Finished generating: %s.png' "$part";
            ) &
        done
    done
}

generate_images assembly_images

wait
printf "\nDone!\n"
