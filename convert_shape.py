#!/usr/bin/env /cygdrive/c/Program Files/FreeCAD 0.18/bin/python
#!/usr/bin/python
# From https://gist.github.com/slazav/4853bd36669bb9313ddb83f51ee1cb82 - slazav/convert_shape.py
#
# Shows how to convert from scad to step
#
#
# path to FreeCAD.so
import os
#

FREECADPATH = None

paths = [ '/usr/lib64/freecad/lib', 'C:/Program Files/FreeCAD 0.18/bin' ]
for p in paths:
  if(os.path.exists(p)):
    FREECADPATH = p
    break

import sys
if FREECADPATH!=None:
  print(FREECADPATH)
  sys.path.insert(0,FREECADPATH)
  os.environ["PYTHON_PATH"]=FREECADPATH;

if len(sys.argv)<3:
  print("Usage: %s <in_file> <out_file>" % (sys.argv[0]))
  sys.exit(1)

iname=sys.argv[1]
oname=sys.argv[2]

# support two export formats: step and iges.
# determine format from extension
if oname[-5:]==".iges":
  type="iges"
elif oname[-5:]==".step":
  type="step"
else:
  print("Output file should have .step or .iges extension")
  sys.exit(1)

import FreeCAD
import Part

# Openscad import settings according to
# https://forum.lulzbot.com/viewtopic.php?t=243
p=FreeCAD.ParamGet("User parameter:BaseApp/Preferences/Mod/OpenSCAD")
p.SetBool('useViewProviderTree',True)
p.SetBool('useMultmatrixFeature',True)
# For some reason conversion does not work with cylinders created from
# extruded 2d circles.
# So I set MaxFN large enough and use smaller $fn in my step files to
# export such cilinders as polygons.
# If you use only normal cylinders, no need to use so large number here.
p.SetInt('useMaxFN',50)

# This should read any type of file
FreeCAD.loadFile(iname)

# iterate through all objects
for o in App.ActiveDocument.Objects:
  # find root object and export the shape
  if len(o.InList)==0:
    if type=="step":   o.Shape.exportStep(oname)
    elif type=="iges": o.Shape.exportIges(oname)
    sys.exit(0)

print("Error: can't find any object")
sys.exit(1)
