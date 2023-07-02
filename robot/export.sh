
username=$(powershell.exe '$env:UserName' | tr -d '\n\r')
printf '%s\n' "$username"

out_dir=/mnt/c/Users/$username/Desktop/robot_export
printf '%s\n' "$out_dir"
mkdir -p $out_dir/armature
mkdir -p $out_dir/armor

win_out_dir=$(wslpath -w $out_dir)
printf '%s\n' "$win_out_dir"

declare -A armature_parts=(
    ["lens"]=1
    ["neck"]=1
    ["chest"]=1
    ["waist"]=1
    ["pelvis"]=1
    ["hip"]=2
    ["arm_upper"]=2
    ["arm_lower"]=2
    ["hand_right"]=1
    ["hand_left"]=1
    ["leg_upper"]=2
    ["leg_lower"]=2
    ["shoulder"]=2
    ["head_and_foot_socket"]=3
)

declare -A armor_parts=(
    ["head"]=1
    ["chest_armor"]=2
    ["waist_armor"]=2
    ["pelvis_armor"]=2
    ["hip_armor"]=2
    ["arm_upper_armor_left"]=2
    ["arm_upper_armor_right"]=2
    ["arm_lower_armor_left"]=2
    ["arm_lower_armor_right"]=2
    ["hand_armor"]=2
    ["leg_upper_armor_left"]=2
    ["leg_upper_armor_right"]=2
    ["leg_lower_armor_left"]=2
    ["leg_lower_armor_right"]=2
    ["shoulder_armor"]=2
    ["foot"]=2
)

for part in "${!armature_parts[@]}" 
do
    ("/mnt/c/Program Files/OpenSCAD/openscad.exe" -Dpart="\"$part\"" -q -o $win_out_dir/armature/$part.stl print\ map.scad; 
        echo "Finished generating: $part";
        for ((i=2;i<=${armature_parts[$part]};i++)) do 
            cp $out_dir/armature/$part.stl $out_dir/armature/$part\_$i.stl; echo "Finished generating: $part\_$i.stl"
        done
    ) &
done

for part in "${!armor_parts[@]}" 
do
    ("/mnt/c/Program Files/OpenSCAD/openscad.exe" -Dpart="\"$part\"" -q -o $win_out_dir/armor/$part.stl print\ map.scad; 
        echo "Finished generating: $part";
        for ((i=2;i<=${armor_parts[$part]};i++)) do 
            cp $out_dir/armor/$part.stl $out_dir/armor/$part\_$i.stl; echo "Finished generating: $part\_$i.stl"
        done
    ) &
done

wait

echo "Done!"
