# Intro
This project is a 3D Printable posable action figure that resembles a robot.

# Generating the Parts
In order to generate the parts, an export script is provided. This script currently works on Windows only, but primarly uses `bash` and should be easy to modify to run on other platforms. The script assumes that you:
* are using `bash`, not `sh`
* are running it in the Windows Subsystem for Linux (WSL) with default settings
* have OpenSCAD installed in your windows Program Files directory
* have a `Desktop` folder in the default windows location

# Printing
This project is designed to be printed on standard consumer grade FDM printers. Most parts, with the exception of some hand options, should be printed without supports. PETG or similar filament with a 0.4mm nozzle and 0.15mm layer height is recommended. It may be possible to print some parts in PLA, however many parts may be too brittle for assembly, and the joints will loosen very fast because PLA deforms more under strain.

Excluding the hands, for which there are multiple options, all armature parts are in the `armature` folder, and all armor parts are in the `armor` folder. If mutiple copies of a part are needed, the folders will contain the correct number of copies, so you can simply plate all files in a given folder without worrying about adjusting the count of any parts.

Two main types of hands are availabe:
1. "simple" hands that are designed to be easy to print without supports. To use the simple hands, look for the `hands/hand_simple_[right/left].stl` and `hand_armor/hand_simple_armor.stl` files.
2. All the other hands which are posed in more dynamic positions, and must be printed with supports. For these hands, organic supports are recommended.

# Assembly
All parts are design to snap together or hold together using tension, and no tools or glue should be needed for assembly. Assemble the armature before putting on the armor, or it will be much harder to snap some parts in place.

Some parts look similar and it can be hard to tell the correct orientation. 

From left to right, the below image shows:
* The shoulder from the top.
* The should from the bottom. Note the deeper cut on the socket.
* The waist. Note the slightly longer stem on the ball and presence of two snap indents on the side, rather than one big one.

![](images/shoulder_and_waist.png?raw=true "Shoulder and waist sockets")

## Assembled views

### Without armor
![](images/assembled_no_armor.png?raw=true "Assembled view without armor")

### With armor
![](images/assembled_armor.png?raw=true "Assembled view with armor")

# Editing the Project
This project is writen in native OpenSCAD and can be edited without any additional software, however there are easier ways to edit it. Since OpenSCAD has a fairly limited text editor, particularly when working across multiple files, I recommend using an external editor with an OpenSCAD extension, such as VSCode. OpenSCAD supports automatically refreshing the preview whenever a file is updated, even if the updates come from an external tool. In this way, you can have multiple instances of OpenSCAD showing previews of different parts in different files, and have all previews refresh to show your edits whenever you save in VSCode, which makes viewing changes to assemblies of multiple parts much easier.

## Navigating the Files
* common.scad
  * Common shapes and math functions that are helpful across a large number of OpenSCAD projects. Also contains some shapes and functions not used in this project.
* assembled.scad
  * Provides an assembled view of the project.
* body.scad
  * Code for generating the three main torso segments.
* feet.scad
  * Code for generating the feet.
* globals.scad
  * Contains global variables for the project.
* hands.scad
  * Code for generating the hands.
* head.scad
  * Code for generating the head, neck segment, and lens.
* joints.scad
  * Code for all of balls, sockets, and pegs that makes the joints posable.
* limbs.scad
  * Shared code for the arms and legs.
* arms.scad
  * Code for generating the arms, including shoulder that connects to the torso.
* legs.scad
  * Code for generating the legs, including the hip that connects to the torso.
* print map.scad
  * Imports all the other parts and rotates them into correct orientations for printing in order to simplify the export script.
* robot common.scad
  * Some common modules that didn't fit well into other files.
* snaps.scad
  * Code for the snap bumps that help hold parts together.
