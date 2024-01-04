#!/usr/bin/env /cygdrive/c/Program Files/FreeCAD 0.21/bin/python
#!/usr/bin/env /cygdrive/c/Program Files/FreeCAD 0.20/bin/python
#!/usr/bin/env python3
#!/usr/bin/env /cygdrive/c/Program Files/FreeCAD 0.20/bin/FreeCAD
#!/usr/bin/env /cygdrive/c/Program Files/FreeCAD 0.20/bin/FreeCADCmd
#!/usr/bin/freecad
#!/usr/bin/python
# (Options above for reminder, easy exchange of lines to adapt to local platform).
# /!\ Launch this script using the python provided/used by FreeCAD
#     (Select/add the appropriate line above)
#
#
# "Quick" and dirty script to convert from one format to the other,
#  including OpenSCAD to STEP conversion
# For STEP output with color, this script must be run using FreeCAD, not FreeCADCmd, not python .
#   Also works with the latter two, but without color in STEP output.
#
# Original https://gist.github.com/slazav/4853bd36669bb9313ddb83f51ee1cb82 - slazav/convert_shape.py
# Fork (this version): https://gist.github.com/d14274ac53b64f23d983b5fdabed8f9e
#
#
import atexit
import os
import re
import sys


# Exit this program when we can catch an error
def at_exit():
    sys.exit(3)


# Register the exit script (does not catch everything though).
atexit.register(at_exit)

# Says if this was run with the FreeCAD Gui available.
hasGui = False
guiIsPossible = False

# Check if running from the Gui, cleanup sys.argv .

freecadPattern = re.compile(r"FreeCAD(Cmd)?(\.exe)?$", re.IGNORECASE)
freecadCmdPattern = re.compile(r"freecadcmd(\.exe)?$", re.IGNORECASE)
if freecadPattern.search(sys.argv[0]):
    if not freecadCmdPattern.search(sys.argv[0]):
        hasGui = True
    # Remove freecad's path
    sys.argv.pop(0)
    # TODO: remove other arguments (-c, --console, etc) - workaround: do not use them
else:
    paths = [
        "/usr/lib64/freecad/lib",
        "C:/Program Files/FreeCAD 0.21/bin",
        "C:/Program Files/FreeCAD 0.20/bin",
        "C:/Program Files/FreeCAD 0.19/bin",
        "C:/Program Files/FreeCAD 0.18/bin",
    ]
    for p in paths:
        if os.path.exists(p):
            FREECADPATH = p
            break

    if FREECADPATH is not None:
        print("Using FreeCAD.so from " + FREECADPATH)
        sys.path.insert(0, FREECADPATH)
        os.environ["PYTHON_PATH"] = FREECADPATH
    guiIsPossible = True

author = "MDW"
company = "https://gist.github.com/d14274ac53b64f23d983b5fdabed8f9e"
if os.getenv("AUTHOR") is not None:
    author = os.getenv("AUTHOR")
if os.getenv("COMPANY") is not None:
    company = os.getenv("COMPANY")

# Check if started with appropriate parameters
if len(sys.argv) < 3:
    print(
        "Usage: %s <in_file> <out_file>" % (sys.argv[0]),
    )
    sys.exit(1)

iname = sys.argv[1]
oname = sys.argv[2]


import FreeCAD

# Further checking of the parameters, especially the output

isMesh = False
# determine format from extension
if oname[-5:] == ".iges":
    file_type = "iges"
elif oname[-5:] == ".step":
    file_type = "step"
    if guiIsPossible:
        import FreeCADGui

        FreeCADGui.showMainWindow()
        hasGui = True
elif oname[-4:] == ".dae":
    file_type = "dae"
elif oname[-4:] == ".wrl":
    file_type = "wrl"
    isMesh = True
else:
    print("Output file should have .step, .dae, .wrl or .iges extension")
    sys.exit(1)

# Export the parameters to a file (debug):
# p=FreeCAD.ParamGet("User parameter:BaseApp")
# p.Export("e.tmp")

if iname[-5:] == ".scad":
    # OpenSCAD import settings according to
    # https://forum.lulzbot.com/viewtopic.php?t=243
    p = FreeCAD.ParamGet("User parameter:BaseApp/Preferences/Mod/OpenSCAD")
    p.SetBool("useViewProviderTree", True)
    p.SetBool("useMultmatrixFeature", True)
    # For some reason conversion does not work with cylinders created from
    # extruded 2d circles.
    # So I set MaxFN large enough and use smaller $fn in my step files to
    # export such cylinders as polygons.
    # If you use only normal cylinders, no need to use so large number here.
    p.SetInt("useMaxFN", 50)

p = FreeCAD.ParamGet("User parameter:BaseApp/Preferences/Mod/Part/STEP")
p.SetString("Author", author)
p.SetString("Company", company)

p = FreeCAD.ParamGet("User parameter:BaseApp/Preferences/Mod/Import/hSTEP")
p.SetBool("ReadShapeCompoundMode", False)
p = FreeCAD.ParamGet("User parameter:BaseApp/Preferences/Mod/Import")
p.SetBool("ExportLegacy", False)
p.SetBool("ExpandCompound", False)
p.SetInt("ImportMode", 0)

# Set a scheme for the STEP output:
# p.SetString("Scheme","AP203")
# p.SetString("Scheme", "AP214CD")
# p.SetString("Scheme","AP214DIS")
# p.SetString("Scheme","AP214IS")
p.SetString("Scheme", "AP242DIS")

# Export modified parameters to a file:
# p=FreeCAD.ParamGet("User parameter:BaseApp")
# p.Export("final.tmp")


# This should read any file_type of file
FreeCAD.loadFile(iname)

data = None

if False:
    for p in App.ActiveDocument.RootObjects:
        # find root object and export the shape
        if len(p.InList) == 0:
            print(p.__class__.__name__)

# iterate through all objects
allObjects = []
for o in App.ActiveDocument.RootObjects:
    # find root object and export the shape
    if len(o.InList) == 0 and hasattr(o, "Shape") and o.Visibility:
        # print(o.__class__.__name__)
        # print (o.Visibility)
        if data is None:
            data = o
        allObjects.append(o)

# print(allObjects)

# Transform meshes (not perfect, WIP)
mesh = None
if data is not None and isMesh:
    import Import
    import MeshPart

    # shape = data[0][0].Shape
    shape = data.Shape

    mesh = MeshPart.meshFromShape(
        Shape=shape, LinearDeflection=0.1, Segments=True
    )

    if 0:
        shape_colors = data[0][1]
        face_colors = [(0, 0, 0)] * mesh.CountFacets

        for i in range(mesh.countSegments()):
            color = shape_colors[i]
            segm = mesh.getSegment(i)
            for j in segm:
                face_colors[j] = color
    # mesh.write(Filename="new_example.obj", Material=face_colors, Format="obj")


#
# Generate the output
if data is None:
    print("Error: can't find any object")
    sys.exit(1)
else:
    # print("Trying to write '{}'".format(oname))
    if file_type == "step":
        done = False
        if hasGui:
            # Try our best option first!
            try:
                import ImportGui

                ImportGui.export(
                    allObjects, name=oname, keepPlacement=True
                )  # , legacy=True, keepPlacement=True, exportHidden=True)
                done = True
            except Exception as e:
                print("export using ImportGui did not work", e)

        if not done:
            try:
                data.Shape.exportStep(oname)
                done = True
            except Exception as e:
                print("exportStep on shape did not work", e)

        if not done:
            try:
                import Import

                Import.export(
                    obj=[data],
                    name=oname,
                    legacy=True,
                    keepPlacement=True,
                    exportHidden=True,
                )
                done = True
            except Exception as e:
                print("export using Import did not work", e)

    elif file_type == "iges":
        data.Shape.exportIges(oname)
    elif file_type == "dae":
        import importDAE

        # mesh.write(Filename=oname)
        importDAE.export(data, oname)  # .write(Filename=oname)
    elif file_type == "wrl":
        mesh.write(Filename=oname)
    sys.exit(0)

sys.exit(2)
