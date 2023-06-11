
username=$(powershell.exe '$env:UserName' | tr -d '\n\r')
printf '%s\n' "$username"

out_dir=/mnt/c/Users/$username/Desktop/robot_export
printf '%s\n' "$out_dir"
mkdir -p $out_dir/armature
mkdir -p $out_dir/armor

win_out_dir=$(wslpath -w $out_dir)
printf '%s\n' "$win_out_dir"

armature_parts=(
    "lens" "neck" "torso" "waist"
    "hips" "hip"
    "arm_upper" "arm_lower"
    "hand_right" "hand_left"
    "leg_upper" "leg_lower"
    "shoulder" "head_and_foot_socket"
)

armor_parts=(
    "head"
    "torso_armor" "waist_armor" "hips_armor" "hip_armor"
    "arm_upper_armor_top" "arm_upper_armor_bottom"
    "arm_lower_armor_top" "arm_lower_armor_bottom"
    "hand_armor"
    "leg_upper_armor_top" "leg_upper_armor_bottom"
    "leg_lower_armor_top" "leg_lower_armor_bottom"
    "shoulder_armor"
    "foot"
)

for part in "${armature_parts[@]}"
do
    ("/mnt/c/Program Files/OpenSCAD/openscad.exe" -Dpart="\"$part\"" -q -o $win_out_dir/armature/$part.stl print\ map.scad; echo "Finished generating: $part") &
done

for part in "${armor_parts[@]}"
do
    ("/mnt/c/Program Files/OpenSCAD/openscad.exe" -Dpart="\"$part\"" -q -o $win_out_dir/armor/$part.stl print\ map.scad; echo "Finished generating: $part")  &
done

wait

echo "Done!"
