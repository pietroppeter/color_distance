# Package

version       = "0.1.0"
author        = "Pietro Peterlongo"
description   = "Implementation of CIEDE2000 color distance"
license       = "MIT"
srcDir        = "src"



# Dependencies

requires "nim >= 1.2.0"
requires "chroma >= 0.1.0"


# Tasks

task test, "run tests for color_distance":
  exec "nim c -r src/color_distance"