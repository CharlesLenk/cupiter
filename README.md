# Charlie the Robot

Charlie the robot is a 3D Printable posable action figure that resembles a robot. In this repository you'll full source code for all parts of this project, a script for exporting the parts, and [assembly instructions](assembly/README.md).

# Generating the Parts

There are two options for generating the parts. Either through a provided export script, or manualy through the OpenSCAD UI.

As of 2024, the OpenSCAD development preview has a new rendering engine called Manifold, which is many times faster. When exporting or working on this project, it's recommended that you use the development snapshot of OpenSCAD with Manifold enabled. This project is tested as working with version `2024.05.02 (git 1057a82e9)` specifically, in the event that issues are encountered with newer versions.

## Option One - Export Script

In order to generate the parts, a Python export script is provided. This script currently works on Windows only, but should be easy to modify to run on other platforms. The script assumes that you:
* have the OpenSCAD preview version installed in your windows Program Files directory.
* have a `Desktop` folder.

When exporting the project, the following folders will be generated:
* `frame`
  * Contains stick-figure frame for the robot, plus a couple additional parts like the lense for the eye which can look good printed in the same color. For best results, enable adaptive layer height for the lens if your slicer supports it.
* `armor`
  * Contains all the armor parts.
* `hand_simple`
  * A blocky hand in a grip pose that is designed to print without supports.
* `hand_simple_armor`
  * Armor that goes on the back of the simple hand.
* `hand_complex_grip`
  * A more detailed hand in a grip pose. Requires supports to print; Organic supports will produce the best result.
* `hand_complex_posed`
  * A series of alternate, more detailed hands in variety of poses. Each pose has a right and left hand version so they can be mixed and matched. All options require supports to print; Organic supports will produce the best result.
* `hand_complex_armor`
  * Armor for the back of the complex hands. Print one set for each pair of complex hands you choose to print.

If mutiple copies of a part are needed, the folders will contain the correct number of copies, so you can simply plate all files in a given folder without worrying about adjusting the count of any parts.

# Printing

This project is designed to be printed on standard consumer grade FDM printers with a 0.4mm nozzle and 0.15mm layer height. Most parts, with the exception of some hand options, should be printed without supports or brims for the best result.

PETG or similar filament is recommended. It may be possible to print some parts in PLA, however many parts will be too brittle for assembly, and the joints will loosen very fast because PLA deforms more under strain.
