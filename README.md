# Charlie the Robot

Charlie the robot is a 3D Printable posable action figure that resembles a robot. In this repository you'll full source code for all parts of this project, a script for exporting the parts, and [assembly instructions](assembly/README.md).

![](images/main_image.png)

# Generating the Parts

There are two options for generating the parts. Either through a provided export script, or manually through the OpenSCAD UI.

As of 2024, the OpenSCAD development preview uses a new rendering engine called Manifold, which is many times faster. When exporting or working on this project, it's recommended that you use a development snapshot of OpenSCAD with Manifold enabled. This project is tested as working with version `2024.05.02 (git 1057a82e9)` specifically, in the event that issues are encountered with newer versions.

## Option One - Export Script

In order to generate the parts, a [Python](https://www.python.org/) export script is provided. This script currently works on Windows only, but should be easy to modify to run on other platforms. The script assumes that you:
* have a version OpenSCAD installed in the default folder.
* have a `Desktop` folder that can be written to.

When exporting the project, the following folders will be generated:
* `frame`
  * Contains the stick-figure frame for the robot, plus a couple additional parts like the lens for the eye which can look good printed in the same color. For best results, enable adaptive layer height for the lens if your slicer supports it.
* `armor`
  * Contains all the armor parts that clip over the frame.
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

## Option Two - Manually

`print map.scad` is invoked by the export script to generate each part. The part selector can be manually edited to select each part, which can then be rendered and exported through the OpenSCAD UI like any other project. This is very

# Printing

This project is designed to be printed on standard consumer grade FDM printers with a 0.4mm nozzle and 0.15mm layer height. Most parts, with the exception of some hand options, should be printed without supports or brims for the best result.

PETG or similar filament is recommended. It may be possible to print some parts in PLA, however many parts will be too brittle for assembly, and the joints will loosen very fast because PLA deforms more under strain.

# About

I've been working on this project off and on for several years. At first, my goal was just to create a very simple desk toy inspired by Lego Bionicles. The project got away from me though, and turned into something much larger.

![](images/progress.png)

## Inspirations


