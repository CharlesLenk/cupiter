# About the Code
Because OpenSCAD is designed for parametric CAD, but the visual design for Cupiter is part sculpting, the code is a mix of well designed parameterized functions, and magic number hacks because something looked better if it was 0.2 millimeters larger. Where possible, I've attempted to have parts scale and adjust appropriately, but many edits will require manual tweaks for visual design.

## Cloning the Repository

This project uses a submodule for some common OpenSCAD code. If the submodule is not initialized, the `openscad-utilities` directory will be empty, and the project won't compile. To get the submodule code when cloning, add the `--recurse-submodules` option to the clone command. If you've already cloned the project, run the command `git submodule update --init` in the project root to pull down the submodule.

## Editing the Project
This project is written in native OpenSCAD and can be edited without any additional software, however I recommend using [VSCode](https://code.visualstudio.com/) with Leathong's [OpenSCAD extension](https://marketplace.visualstudio.com/items?itemName=Leathong.openscad-language-support).

OpenSCAD has an "Automatic Reload and Preview" option that will refresh the preview whenever a file is updated, even if the updates come from an external tool. In this way, you can have multiple instances of OpenSCAD showing previews of different parts in different files, and have all previews refresh to show your edits whenever you save in VSCode, which makes viewing changes to assemblies of multiple parts much easier.

### Navigating the Files
* arms.scad
  * Code for generating the arms, including the shoulder that connects to the torso.
* assembly image map.scad
  * Provides a selector between multiple assembly views. Used by the script that exports assembly instruction images.
* assembly.scad
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
* legs.scad
  * Code for generating the legs, including the hip that connects to the torso.
* limbs.scad
  * Shared code for the arms and legs.
* print map.scad
  * Imports all the other parts and rotates them into correct orientations for printing in order to simplify the export script.
* robot common.scad
  * Some common modules that didn't fit well into other files.
* snaps.scad
  * Code for the snap bumps that help hold parts together.

## Generating the Parts

There are two options for generating the parts. Either through a provided export script, or manually through the OpenSCAD UI.

As of 2024, the OpenSCAD development preview uses a new rendering engine called Manifold, which is many times faster. When exporting or working on this project, it's recommended that you use a development snapshot of OpenSCAD with Manifold enabled. This project is tested as working with version `2024.05.02 (git 1057a82e9)` specifically, in the event that issues are encountered with newer versions.

### Exporting with the Script

In order to generate the parts, a [Python](https://www.python.org/) export script is provided in `src/python/stl_export.py`.

If running using VSCode, set the `Execute in File Dir` option for Python. VSCode will run the script from the currently open folder by default, but for the folder pathing to work correctly the script is meant to be run from the `python` folder.

When first run, the export script will prompt for the location of OpenSCAD on your system, and what location the files should be output to. As long as OpenSCAD is installed in the standard applications directory for your system and you have a Desktop folder, the defaults provided should work without customization. The values are saved to `export.conf`, which can be edited directly if you need to change the OpenSCAD location or output directory. If `export.conf` is deleted, the script will reprompt when next run.

The export will have the folder structure given in the [instructions](../instructions/README.md)

### Exporting Manually

This option is not recommended. `print map.scad` is invoked by the export script to generate each part. In this file, there is a large `if/else` condition where the call to generate each part can be seen. You can either write OpenSCAD code using these calls to build up a print plate, or the part selector can be manually edited to select each part, which can then be rendered and exported through the OpenSCAD UI like any other project.
