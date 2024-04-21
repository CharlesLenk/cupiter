username=$(powershell.exe '$env:UserName' | tr -d '\n\r')
out_dir=/mnt/c/Users/$username/Desktop/robot_export
win_out_dir=$(wslpath -w $out_dir)
printf 'Output directory: %s\n' "$win_out_dir"

declare -A armature=(
    ["lens"]=1
    ["antenna_left"]=1
    ["antenna_right"]=1
    ["neck"]=1
    ["chest"]=1
    ["waist"]=1
    ["pelvis"]=1
    ["hip"]=2
    ["arm_upper"]=2
    ["arm_lower"]=2
    ["leg_upper"]=2
    ["leg_lower"]=2
    ["shoulder"]=2
    ["head_and_foot_socket"]=3
)

declare -A armor=(
    ["head"]=1
    ["chest_armor"]=2
    ["waist_armor"]=2
    ["pelvis_armor"]=2
    ["hip_armor"]=2
    ["arm_upper_armor_left"]=2
    ["arm_upper_armor_right"]=2
    ["arm_lower_armor_left"]=2
    ["arm_lower_armor_right"]=2
    ["leg_upper_armor_left"]=2
    ["leg_upper_armor_right"]=2
    ["leg_lower_armor_left"]=2
    ["leg_lower_armor_right"]=2
    ["shoulder_armor"]=2
    ["foot"]=2
)

declare -A hands=(
    ["hand_simple_right"]=1
    ["hand_simple_left"]=1
    ["hand_grip_right"]=1
    ["hand_grip_left"]=1
    ["hand_flat_right"]=1
    ["hand_flat_left"]=1
    ["hand_relaxed_right"]=1
    ["hand_relaxed_left"]=1
    ["hand_fist_right"]=1
    ["hand_fist_left"]=1
    ["hand_love_right"]=1
    ["hand_love_left"]=1
    ["hand_prosper_right"]=1
    ["hand_prosper_left"]=1
    ["hand_peace_right"]=1
    ["hand_peace_left"]=1
    ["hand_five_right"]=1
    ["hand_five_left"]=1
    ["hand_open_grip_right"]=1
    ["hand_open_grip_left"]=1
)

declare -A hand_armor=(
    ["hand_simple_armor"]=2
    ["hand_armor_right"]=1
    ["hand_armor_left"]=1
)

function generate_parts {
    for name in "$@"
    do
        mkdir -p $out_dir/$name
        declare -n parts=$name
        for part in "${!parts[@]}"
        do
            ("/mnt/c/Program Files/OpenSCAD/openscad.exe" -Dpart="\"$part\"" -q -o $win_out_dir/$name/$part.stl print\ map.scad;
                printf 'Finished generating: %s/%s.stl\n' "$name" "$part";
                for ((i=2;i<=${parts[$part]};i++)) do
                    cp $out_dir/$name/$part.stl $out_dir/$name/$part\_$i.stl; printf 'Finished generating: %s/%s_%s.stl\n' "$name" "$part" "$i"
                done
            ) &
        done
    done
}

generate_parts armature armor hands hand_armor
wait
echo "Done!"
