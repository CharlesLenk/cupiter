# Editing the Project
This project is writen in native OpenSCAD and can be edited without any additional software, however there are easier ways to edit it. Since OpenSCAD has a fairly limited text editor, particularly when working across multiple files, I recommend using an external editor with an OpenSCAD extension, such as VSCode. OpenSCAD supports automatically refreshing the preview whenever a file is updated, even if the updates come from an external tool. In this way, you can have multiple instances of OpenSCAD showing previews of different parts in different files, and have all previews refresh to show your edits whenever you save in VSCode, which makes viewing changes to assemblies of multiple parts much easier.

## Navigating the Files
* arms.scad
  * Code for generating the arms, including shoulder that connects to the torso.
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
