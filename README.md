# Intro
This project is a 3D Printable posable action figure that resembles a robot.

# Generating the Parts
In order to generate the parts, an export script is provided. This script currently works on Windows only, but runs using `bash` and should be easy to modify to run on other platforms. The script assumes that you:
* are using `bash`, not `sh`
* are running it in the Windows Subsystem for Linux (WSL) with default settings
* have OpenSCAD installed in your windows Program Files directory
* have a `Desktop` folder in the default windows location

# Printing
This project is designed to be printed on standard consumer grade FDM printers with a 0.4mm nozzle and 0.15mm layer height. Most parts, with the exception of some hand options, should be printed without supports.

PETG or similar filament is recommended. It may be possible to print some parts in PLA, however many parts will be too brittle for assembly, and the joints will loosen very fast because PLA deforms more under strain.

Excluding the hands, for which there are multiple options, all frame parts are in the `frame` folder, and all armor parts are in the `armor` folder. If mutiple copies of a part are needed, the folders will contain the correct number of copies, so you can simply plate all files in a given folder without worrying about adjusting the count of any parts.

Two main types of hands are availabe:
1. "simple" hands that are designed to be easy to print without supports. To use the simple hands, look for the `hands/hand_simple_[right/left].stl` and `hand_armor/hand_simple_armor.stl` files.
2. All the other hands which are posed in more dynamic positions, and must be printed with supports. For these hands, organic supports are recommended.
