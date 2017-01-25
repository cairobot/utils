#cairo/utils: utilities for development and installation

##desc
This repo contains utilities to generate walkfiles, install the software and some init scripts for autoloading of the software.

###setup.sh + repos.txt
Execute setup.sh on the device and the software is installed.

###devel/csv2walk.sh
Converts a csv containing the walk directives into a walkfile ready for use.

###devel/opt-walk.sh
Optimizes the generated walkfile from devel/csv2walk.sh.

###spider/cairo-serverstart
Init.d script which starts the main_controller.

###spider/cairocon
Shell script for controlling the server if it has been set up with a fifo as input (spider/cairo-serverstart does that).