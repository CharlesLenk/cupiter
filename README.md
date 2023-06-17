# Intro
This project is a 3D Printable posable action figure that resembles a robot. Some parts are still undergoing refinement, but the current version is fully printable and can be assembled.

# Printing
This project is designed to be printed on standard consumer grade FDM printers without using supports.

PETG or similar filament is recommended. It may be possible to print this project in PLA, however many parts may be too brittle for assembly, and the joints will loosen very fast because PLA deforms more under strain.

In order to generate the parts, an export script is provided. The script must be run using `bash`, not `sh`. The script assumes that you:
* are running it in the Windows Subsystem for Linux (WSL) with default settings
* have OpenSCAD installed in your windows Program Files directory
* have a `Desktop` folder in the default windows location

# Assembly
Assemble the armature before putting on the armor, or it will be much harder to snap some parts in place.

Some parts look very similar and it can be hard to tell the correct orientation. 

From left to right, the below image shows:
* The shoulder from the top.
* The should from the bottom. Note the deeper cut on the socket.
* The waist. Note the slightly longer stem on the ball and presence of two snap indents on the side, rather than one big one.

![](images/shoulder_and_waist.png?raw=true "Should and waist sockets")

## Assemled views

### Without armor
![](images/assembled_no_armor.png?raw=true "Assembled view without armor")

### With armor
![](images/assembled_armor.png?raw=true "Assembled view with armor")

# Navigating the Project
* common.scad
  * Common shapes and math functions that are helpful across a large number of OpenSCAD projects. Also contains some shapes and functions not used in this project.
* assembled.scad
  * Provides an assembled view of the project.
* body.scad
  * Code for generating the three main torso segments.
* feet.scad
  * Code for generating the feet.
* globals.scad
  * Contains global variables for the project. Could be refined further, and still has some variables that could be moved closer to where they are used.
* hands.scad
  * Code for generating the hands. Also has work in progress for more posable hands.
* head.scad
  * Code for generating the head, neck segment, and lens.
* joints.scad
  * Code for all of balls, sockets, and pegs that makes the joints posable.
* limbs.scad
  * Code for the arms and legs, including the shoulder and hip parts that connect to the torso.
* print map.scad
  * Imports all the other parts and rotates them into correct orientations for printing in order to simplify the export script.
* robot common.scad
  * Some common shapes that didn't fit well into other files.
* robot imports.scad
  * Common imports to avoid a repeated block at the top of every file. Most of the files import all of the other files since OpenSCAD doesn't provide the concept of a package like you'd see in many programming languages.