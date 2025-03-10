# Instructions

## Printing

All parts are designed to be printed on standard consumer grade FDM printers with a 0.4mm nozzle and 0.15mm layer height. Most parts, with the exception of some hand options, should be printed without supports or brims for the best result.

PETG or similar filament is recommended. It may be possible to print some parts in PLA, however many parts will be too brittle for assembly, and the joints will loosen very fast because PLA deforms more under strain.

### Project Folders

The parts are divided into a number of folders, some of which contain optional parts. If multiple copies of a part are needed, the folders will contain the correct number of copies, so you can simply plate all files in a given folder without worrying about adjusting the count of any parts.

The `frame` and `armor` folders contain all parts other than the hand options.
* `frame`
  * Contains the stick-figure frame for the robot, plus a couple additional parts like the lens for the eye which can look good printed in the same color. For best results, enable adaptive layer height for the lens if your slicer supports it.
* `armor`
  * Contains all the armor parts that clip over the frame.

Two main options are available for hands, and the best one to choose depends on the capabilities of your printer. Pick at least one set of hands.
* `hand_simple`
  * A blocky hand in a grip pose that is designed to print without supports. `hand_simple_armor` contains the armor for the back of the hands.
* `hand_complex_grip`
  * A more detailed hand in a grip pose. Requires supports to print; Organic supports will produce the best result. `hand_complex_armor` contains the armor for the back of the hands

The `alternatives` folder contains additional options for some parts.
* `hand_complex_posed`
  * A series of alternate, more detailed hands in a variety of poses. Each pose has a right and left hand version so they can be mixed and matched. All hand require supports to print; Organic supports will produce the best result. One set of `hand_complex_armor` should be printed for each set of hands.
  ![](images/alternate_hands.png)
* `space_head`
  * An alternate head option that can be used instead of the camera head. The `accessories` folder contains the required antenna and visor.
  ![](images/space_head_assembled.png)

## Assembly

All parts are designed to snap together or hold together using tension, and no tools or glue are needed for assembly.

Some parts can be much harder to assemble based on the order in which they are assembled. Following the steps below is recommended, or at least assembling the frame before attaching the armor.

### Assembly Tips

Snapping together the ball and socket joints is easier if you angle the flat side of the ball toward the edge of the socket.

![](images/socket_assembly_note.png)

Some parts look similar and it can be hard to tell the correct orientation. From left to right, the below image shows:
* The shoulder from the top.
* The shoulder from the bottom. Note the deeper cut on the socket. This part should face toward the armpit when the arm is assembled.
* The waist. Note the slightly longer stem on the ball, double snap indent, and cross-brace to prevent slipping.

![](images/shoulder_note.png)

### Arm Assembly (2x)
![](images/arm_frame_exploded.png)
![](images/arm_frame.png)
![](images/arm_upper_armor.png)
![](images/arm_lower_armor.png)
![](images/hand.png)
![](images/hand_armor.png)
![](images/arm_assembled.png)

### Upper Body Assembly
![](images/torso_frame_exploded.png)
![](images/torso_frame.png)
![](images/pelvis_armor.png)
![](images/waist_armor.png)
![](images/torso_assembled.png)
![](images/upper_body_arms_exploded.png)
![](images/upper_body_arms.png)
![](images/upper_body_chest_armor.png)
![](images/upper_body_shoulder_armor.png)
![](images/upper_body_assembled.png)

### Leg Assembly (2x)
![](images/leg_frame_exploded.png)
![](images/leg_frame.png)
![](images/leg_upper_armor.png)
![](images/leg_lower_armor.png)
![](images/foot_socket.png)
![](images/foot.png)
![](images/leg_assembled.png)

### Body Assembly
![](images/body_legs_exploded.png)
![](images/body_legs_assembled.png)
![](images/body_hip_armor.png)
![](images/body_assembled.png)
![](images/body_arms_lowered.png)

### Head Assembly
![](images/camera_head_exploded.png)
![](images/camera_head_assembled.png)
![](images/body_camera_head_exploded.png)
![](images/body_camera_head_assembled.png)

## Alternate Parts

### Space Head Assembly
![](images/space_head_exploded.png)
![](images/space_head_assembled.png)
![](images/body_space_head_exploded.png)
![](images/body_space_head_assembled.png)

### Wing Clip
![](images/wing_clip.png)
![](images\upper_body_chest_armor_wings.png)
