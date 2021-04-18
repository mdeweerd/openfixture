#!/usr/bin/env python
#
# Kicad OpenFixture Generator
#
# TinyLabs Inc
# 2016
# CC-BY-SA 4.0
#
# Takes two arguments:
# 1. pcb_th (mm) - PCB thickness
# 2. mat_th (mm) - Laser cut material thickness
#
#   Args - Path to store
#          --layer <F.Cu|B.Cu>
#
#        Default is all pads with no paste mask are test points.
#        Add args for:
#            MANDATORY: pcb_th and mat_th and output directory
#            OPTIONAL: pivot_d, screw_len
import os
import sys
import argparse
from sys import platform as _platform
from pcbnew import *
import subprocess
import re

# Defaults
DEFAULT_PCB_TH = 1.6
DEFAULT_SCREW_D = 3.0
DEFAULT_SCREW_LEN = 14

if os.name == 'nt':
  PATHSEP = "\\"
  CLI_QUOTE = "\""
  SCADVARQUOTE = "\"\""
else:
  PATHSEP = "/"
  CLI_QUOTE = "'"
  SCADVARQUOTE = "\""

#if _platform == "cygwin":
#elif _platform == "nt":
#else:

print("OS:"+os.name+" Platform: "+_platform+" PATHSEP: "+PATHSEP+"\r\n")
KICAD_PYTHON = sys.executable
GENERATE_KICAD = os.path.dirname(os.path.realpath(__file__))+'/generate_kicad.py'

  
# Generate fixture class
class GenFixture:
    # Layers
    layer = F_Cu
    paste = F_Paste
    ignore_layer = Eco1_User
    force_layer = Eco2_User

    # Will be true if we're working on back points
    mirror = False

    # Fixture parameters
    mat_th = 0
    pcb_th = DEFAULT_PCB_TH
    screw_len = DEFAULT_SCREW_LEN
    screw_d = DEFAULT_SCREW_D

    # Global pointer to brd object
    brd = None

    # Path to generated dxf
    dxf_path = None
    prj_name = None

    # Optional arguments
    rev = None
    pogo_d = None
    washer_th = None
    kicad = False
    annular = 0.25
    nut_f2f = None
    nut_c2c = None
    nut_th = None
    pivot_d = None
    pcb_h = None
    border = None
    render = False
    logo = None

    # Board dimensions
    min_y = float("inf")
    origin = [float("inf"), float("inf")]
    dims = [0, 0]
    test_points = []
    test_points_mirror = []

    def __init__(self, prj_name, brd, mat_th):
        self.prj_name = prj_name
        self.brd = brd
        self.CleanBrd()
        self.mat_th = float(mat_th)
        self.scad_values = {}

    def __exit__(self, type, value, traceback):
        pass

    def __str__(self):
        return "Fixture: origin=(%.02f,%.02f) dims=(%.02f,%.02f) min_y=%.02f" % (self.origin[0],
                                                                                 self.origin[1],
                                                                                 self.dims[0],
                                                                                 self.dims[1],
                                                                                 self.min_y)

    # Generate openscad CLI option for numeric define
    def genNumDefine(self,key,fmt,value):
        self.scad_values[key] = fmt % value
        return (" -D"+key+"="+fmt) % value

    # Generate openscad CLI option for expression define
    def genExpDefine(self,key,fmt,value):
        self.scad_values[key]= fmt % value
        return (" -D"+key+"="+CLI_QUOTE+fmt+CLI_QUOTE) % value

    # Generate openscad CLI option for string define
    def genStrDefine(self,key,fmt,value):
        quotedvalue=value.replace('\\','\\\\')
        self.scad_values[key]=(('"'+fmt+'"')%quotedvalue)
        return (" -D"+key+"="+CLI_QUOTE+SCADVARQUOTE+fmt+SCADVARQUOTE+CLI_QUOTE) % quotedvalue

    def SetOptional(self, rev=None, pogo_d=None, washer_th=None, nut_f2f=None, nut_c2c=None, nut_th=None,
                    pivot_d=None, pcb_h=None, border=None, render=False, kicad=False,
                    annular=None,
                    exclude_size_refs = (),
                    pins=(), logo=None, logosize=(50,50)):
        self.rev = rev
        self.pogo_d = pogo_d
        self.washer_th = washer_th
        self.nut_f2f = nut_f2f
        self.nut_c2c = nut_c2c
        self.nut_th = nut_th
        self.pivot_d = pivot_d
        self.pcb_h = pcb_h
        self.border = border
        self.render = render
        self.kicad = kicad
        self.pins = pins
        self.exclude_size_refs = exclude_size_refs
        self.logo = logo
        self.logosize = logosize
        self.scad_values = {}
        if annular is not None:
            self.annular=annular

    def SetParams(self, pcb_th, screw_len, screw_d):
        if pcb_th is not None:
            self.pcb_th = float(pcb_th)
        if screw_len is not None:
            self.screw_len = float(screw_len)
        if screw_d is not None:
            self.screw_d = float(screw_d)

    def SetLayers(self, layer=-1, ilayer=-1, flayer=-1):
        if layer != -1:
            self.layer = layer
        if ilayer != -1:
            self.ignore_layer = ilayer
        if flayer != -1:
            self.force_layer = flayer

        # Setup paste layer
        if (self.layer == F_Cu):
            self.paste = F_Paste
        else:
            self.paste = B_Paste
            self.mirror = True

    def Round(self, x, base=0.01):
        return round(base * round(x / base), 2)


    #
    # Clean board from items to simplyfy processing
    #
    def CleanBrd(self):
        for item in self.brd.GetDrawings():
            if item.__class__.__name__ == "PCB_TARGET":
                item.DeleteStructure()

    def PlotDXF(self, path):

        # Save auxillary origin
        aux_origin_save = self.brd.GetAuxOrigin()

        # Set new aux origin to upper left side of board
        self.brd.SetAuxOrigin(wxPoint(FromMM(self.origin[0]), FromMM(self.origin[1])))

        # Get pointers to controllers
        # https://docs.kicad.org/doxygen-python/classpcbnew_1_1PLOT__CONTROLLER.html
        pctl = PLOT_CONTROLLER(self.brd)
        # https://docs.kicad.org/doxygen-python/classpcbnew_1_1PCB__PLOT__PARAMS.html
        popt = pctl.GetPlotOptions()

        # Setup output directory
        popt.SetOutputDirectory(path)

        # Set some important plot options:
        popt.SetDXFPlotUnits(DXF_PLOTTER.DXF_UNIT_MILLIMETERS)
        popt.SetDXFPlotPolygonMode(False)
        popt.SetPlotFrameRef(False)
        popt.SetLineWidth(FromMM(0.1))
        popt.SetAutoScale(False)
        popt.SetScale(1)
        popt.SetMirror(self.mirror)
        popt.SetUseGerberAttributes(False)
        popt.SetExcludeEdgeLayer(False)

        # Use auxillary origin
        popt.SetUseAuxOrigin(True)

        # This by gerbers only (also the name is truly horrid!)
        popt.SetSubtractMaskFromSilk(False)

        # Do the BRD edges in black
        popt.SetColor(COLOR4D(0, 0, 0, 1.0))  # color4d = RED, GREEN, BLUE, OPACITY

        # Open file
        pctl.SetLayer(Edge_Cuts)
        pctl.OpenPlotfile("outline", PLOT_FORMAT_DXF, "Edges")

        # Plot layer
        pctl.PlotLayer()

        # CLose plot
        pctl.ClosePlot()

        # Restore origin
        self.brd.SetAuxOrigin(aux_origin_save)


    def Generate(self, path):

        # Get origin and board dimensions
        self.GetOriginDimensions()

        # Get test points
        self.GetTestPoints()

        # Test for failure to find test points
        if len(self.test_points) == 0:
            print("WARNING, ABORTING: No test points found!")
            print("Verify that the pcbnew file has test points specified")
            print("or use the --flayer and/or --pins options to add test points")
            return

        # Plot DXF
        self.PlotDXF(path)

        # Get revision
        if self.rev is None:
            self.rev = "rev.%s" % self.brd.GetTitleBlock().GetRevision()
            if self.rev == "":
                self.rev = "rev.0"

        # Call openscad to generate fixture
        args =  self.genExpDefine("test_points","%s",self.GetScadTestPointStr())
        args += self.genNumDefine("tp_min_y","%.02f",self.min_y)
        args += self.genNumDefine("mat_th","%.02f",self.mat_th)
        args += self.genNumDefine("pcb_th","%.02f",self.pcb_th)
        args += self.genNumDefine("pcb_x","%.02f",self.dims[0])
        args += self.genNumDefine("pcb_y","%.02f",self.dims[1])
        outline_dxf=path + PATHSEP + self.prj_name + "-outline.dxf" 
        args += self.genStrDefine("pcb_outline","%s",outline_dxf)
        args += self.genNumDefine("screw_thr_len","%.02f",self.screw_len)
        args += self.genNumDefine("screw_d","%.02f",self.screw_d)
        args += self.genNumDefine("logo_w","%s",self.logosize[0])
        args += self.genNumDefine("logo_h","%s",self.logosize[1])

        # Set optional args
        if self.rev != None:
            args += self.genStrDefine("rev","%s",self.rev)
        if self.logo != None:
            args += self.genStrDefine("logo","%s",self.logo)
        if self.pogo_d != None:
            pogo_d=float(self.pogo_d)
            args += self.genNumDefine("pogo_r","%.02f",float(pogo_d/2))
        else:
            pogo_d=1.22
        if self.washer_th != None:
            args += self.genNumDefine("washer_th","%.02f",float(self.washer_th))
        if self.nut_f2f != None:
            args += self.genNumDefine("nut_od_f2f","%.02f",float(self.nut_f2f))
        if self.nut_c2c != None:
            args += self.genNumDefine("nut_od_c2c","%.02f",float(self.nut_c2c))
        if self.nut_th != None:
            args += self.genNumDefine("nut_th","%.02f",float(self.nut_th))
        if self.pivot_d != None:
            args += self.genNumDefine("pivot_d","%.02f",float(self.pivot_d))
        if self.pcb_h != None:
            args += self.genNumDefine("pcb_max_height_component","%.02f",float(self.pcb_h))

        # Note: on merge, not sure which parameter is needed, adding both:
        if self.border != None:
            args += self.genNumDefine("pcb_support_border","%.02f",float (self.border))
        if self.border != None:
            args += self.genNumDefine("border","%.02f",float(self.border))

        # Create output file name
        dxfout = path + PATHSEP + self.prj_name + "-fixture.dxf"
        dxf2out = path + PATHSEP + self.prj_name + "-v2-fixture.dxf"
        # For easy visualisation
        svgout = path + PATHSEP + self.prj_name + "-fixture.svg"
        svg2out = path + PATHSEP + self.prj_name + "-v2-fixture.svg"
        pngout = path + PATHSEP + self.prj_name + "-fixture.png"
        stlout = path + PATHSEP + self.prj_name + "-fixture.stl"
        testout = path + PATHSEP + self.prj_name + "-test.dxf"
        validateout = path + PATHSEP + self.prj_name + "-validate.dxf"
        standalonescad = path + PATHSEP + self.prj_name + ".scad"
        kicadoutpathout = path
        #standalonescad = self.prj_name + ".scad"  # In local directory to propery reference logos

        # This will take a while, print something
        print("Generating Fixture...")

        # Create standalone SCAD file (For instance, to convert to step with FreeCAD) 
        vars="//\n// Parameters from command line\n//\n"
        modeOpt=self.genStrDefine("mode","%s","3dmodel")
        for k, v in self.scad_values.items():
            #print("%s = %s" %(k,v))
            vars+="%s = %s;\n" %(k,v)

        with open('openfixture.scad', 'r') as f:
            src = f.read()
            result = src.replace("// HANDLE_DO_NOT_REMOVE",vars)
            file = open(standalonescad, 'w')
            file.write(result)
            file.close()

        # Create test part
        modeOpt=self.genStrDefine("mode","%s","testcut")
        cmdTestcut=("openscad %s "+modeOpt+" -o %s openfixture.scad") % (args, CLI_QUOTE + testout + CLI_QUOTE)
        #print(cmdTestcut)
        os.system(cmdTestcut)

        # Create testpoint validation
        modeOpt=self.genStrDefine("mode","%s","validate")
        cmdValidate=("openscad %s "+modeOpt+" -o %s openfixture.scad") % (args, CLI_QUOTE + validateout + CLI_QUOTE)
        #print(cmdValidate)
        os.system(cmdValidate)

        # Create laser cuttable fixture (before rendering, because this is faster)
        modeOpt=self.genStrDefine("mode","%s","lasercut")
        cmdLasercut=("openscad %s "+modeOpt+" -o %s -o %s openfixture.scad ") % (args, CLI_QUOTE+dxfout+CLI_QUOTE, CLI_QUOTE+svgout+CLI_QUOTE)
        #print(cmdLasercut)
        os.system(cmdLasercut)

        # Create laser v2 cuttable fixture (before rendering, because this is faster)
        modeOpt=self.genStrDefine("mode","%s","lasercut_v2")
        cmdLasercut=("openscad %s "+modeOpt+" -o %s -o %s openfixture.scad ") % (args, CLI_QUOTE+dxf2out+CLI_QUOTE, CLI_QUOTE+svg2out+CLI_QUOTE)
        #print(cmdLasercut)
        os.system(cmdLasercut)

        # Create rendering
        if self.kicad:
            kicad_tp=self.GetKicadGenTestPointStr(self.test_points_mirror)
            cmdKiCad="{python} {genexe} --testpins {testpins} --diameter {diam} --annular {annular} --name {prjname} {outline_dxf} {outpath}".format(
                  #python=CLI_QUOTE+KICAD_PYTHON+CLI_QUOTE,
                  python="'"+KICAD_PYTHON+"'",
                  genexe=CLI_QUOTE+GENERATE_KICAD+CLI_QUOTE,
                  testpins=kicad_tp,
                  prjname=prj_name,
                  diam=pogo_d,
                  annular=str(self.annular),
                  outline_dxf=CLI_QUOTE+outline_dxf+CLI_QUOTE,
                  outpath=CLI_QUOTE+kicadoutpathout+CLI_QUOTE
               )
            #print(cmdKiCad)
            #os.system(cmdKiCad)
            subprocess.call([
                  KICAD_PYTHON,
                  GENERATE_KICAD,
                  '--testpins',kicad_tp,
                  '--diameter',str(pogo_d),
                  '--annular',str(self.annular),
                  '--name',prj_name+"-Test",
                  outline_dxf,
                  kicadoutpathout,
                ])

        # Create rendering
        if self.render:
            modeOpt=self.genStrDefine("mode","%s","3dmodel")
            #cmdRender="openscad %s "+modeOpt+" --render -o %s -o openfixture.scad" % (args, pngout)
            cmdRender=("openscad %s "+modeOpt+" --render --imgsize=800,800 -o %s -o %s openfixture.scad") % (args, CLI_QUOTE+pngout+CLI_QUOTE, CLI_QUOTE+stlout+CLI_QUOTE)
            #print(cmdRender)
            os.system(cmdRender)

        # Print output
        print("Fixture generated: '%s'" % dxfout)

    def GetScadTestPointStr(self):
        tps = "["
        for tp in self.test_points:
            tps += "[%.02f,%.02f]," % (tp.get('x'), tp.get('y'))
        return (tps + "]")

    def GetKicadGenTestPointStr(self,test_points):
        tps = ""
        sep = ""
        for tp in test_points:
            tps += sep
            tps += "{iden}:{x}:{y}:{net}".format(
                 iden=tp.get('ref'),
                 net=tp.get('net'),
                 x=tp.get('x'),
                 y=tp.get('y'),
               )
            sep=','
        return tps

    def GetTestPoints(self):

        # Iterate over all pads
        for m in self.brd.GetModules():

            # Iterate over all pads
            for p in m.Pads():

                # Check that there is no paste and it's on selected copper layer
                if (p.IsOnLayer(self.layer) == True):
                    parent=p.GetParent() # Footprint

                    # print ("%s-%s-%s" % (parent.GetReference(), p.GetName(), parent.GetValue()))

                    # Are we forcing this pad?
                    if (p.IsOnLayer(self.force_layer) == True):
                        pass

                    # On ignore layer?
                    elif (p.IsOnLayer(self.ignore_layer) == True):
                        continue

                    # Is it a TestProbe component
                    elif (parent.GetValue() == "TestProbe"):
                        pass

                    # Is it in the desired component pin list?
                    elif  ("%s-%s" % (parent.GetReference(), p.GetName())) in self.pins:
                        pass

                    # else check ignore cases
                    elif (
                          (p.IsOnLayer(self.paste) == True) or
                          (p.GetAttribute() != PAD_ATTRIB_SMD)):
                        continue


                    # Print position
                    tp = ToMM(p.GetPosition())

                    # Round x and y, invert x if mirrored
                    xN = self.Round(tp[0] - self.origin[0])
                    xM = self.dims[0] - (self.Round(tp[0] - self.origin[0]))
                    if self.mirror is False:
                       x=xN
                       x_mirror=xM
                    else:
                       x=xM
                       x_mirror=xN
                    y = self.Round(tp[1] - self.origin[1])
                    #print "tp = (%f, %f)" % (x,y)
                    # Debug - print information about pad.
                    ref=parent.GetReference()
                    name=p.GetName()
                    if name != "1":
                       ref+="-"+name
                    net=p.GetNet().GetNetname()
                    print(net)
                    match=re.match(r'/(.*)',net)
                    if match != None:
                        net=match.group(1)

                    print("%s: %s\tTP(%0.2f,%0.2f)" % (parent.GetReference(), p.GetNet().GetNetname(), x, y))

                    # Check if less than min
                    if y < self.min_y:
                        self.min_y = y

                    # Save coordinates of pad
                    self.test_points.append({'x':x,'y':y,'ref':ref,'net':net})
                    self.test_points_mirror.append({'x':x_mirror,'y':y,'ref':ref,'net':net})

    def GetOriginDimensions(self):
        if (self.brd is None):
            return None

        # Init max variables
        max_x = 0
        max_y = 0

        # Get all drawings
        if 1==1:
          bb = self.brd.GetBoardEdgesBoundingBox()
          
          x = ToMM(bb.GetX())
          y = ToMM(bb.GetY())
          #w = ToMM(bb.GetWidth())
          #h = ToMM(bb.GetHeight())
          #print("x: {}; y: {}; w: {}; h: {} ".format(x,y,w,h))

          # Debug
          # print "(%f, %f)" % (x, y)

          # Min x/y will be origin
          if x < self.origin[0]:
             self.origin[0] = self.Round(x)
             #    self.origin[0] = x
          if y < self.origin[1]:
             self.origin[1] = self.Round(y)
             #    self.origin[1] = y

          # Max x.y will be dimensions
          if x > max_x:
             max_x = x
          if y > max_y:
             max_y = y
        else: 
          for line in self.brd.GetDrawings():

            if line.__class__.__name__ == "PCB_TARGET":
                continue
            # Check that it's in the outline layer
            if line.GetLayerName() == 'Edge.Cuts':
                # Get bounding box
                bb = line.GetBoundingBox()

                x = ToMM(bb.GetX())
                y = ToMM(bb.GetY())
                #w = ToMM(bb.GetWidth())
                #h = ToMM(bb.GetHeight())
                #print("x: {}; y: {}; w: {}; h: {} ".format(x,y,w,h))

                # Debug
                # print "(%f, %f)" % (x, y)

                # Min x/y will be origin
                if x < self.origin[0]:
                    self.origin[0] = self.Round(x)
                #    self.origin[0] = x
                if y < self.origin[1]:
                    self.origin[1] = self.Round(y)
                #    self.origin[1] = y

                # Max x.y will be dimensions
                if x > max_x:
                    max_x = x
                if y > max_y:
                    max_y = y
                    
        # Get all modules for bounding boxes
        print(', '.join(str(p) for p in self.exclude_size_refs))
        for modu in self.brd.GetModules():
            if modu.GetReference() in self.exclude_size_refs:
               continue
               
            #bb = modu.GetBoundingBox()
            bb = modu.GetFootprintRect()

            x = ToMM(bb.GetX())
            y = ToMM(bb.GetY())
            w = ToMM(bb.GetWidth())
            h = ToMM(bb.GetHeight())
            # print("{}: x: {}; y: {}; w: {}; h: {} ; ".format(modu.GetReference(), x, y, w, h))

            # Min x/y will be origin
            if x < self.origin[0]:
                # self.origin[0] = self.Round(x)
                self.origin[0] = x
            if y < self.origin[1]:
                #self.origin[1] = self.Round(y)
                self.origin[1] = y

            # Max x.y will be dimensions
            if x + w > max_x:
                max_x = x + w
            if y + h > max_y:
                max_y = y + h

        # Calculate dimensions
        self.dims[0] = self.Round(max_x - self.origin[0])
        self.dims[1] = self.Round(max_y - self.origin[1])
        print("dims0x: {} dims1y: {}".format(self.dims[0],self.dims[1]))


if __name__ == '__main__':

    # Create parser
    parser = argparse.ArgumentParser()

    # Add required arguments
    parser.add_argument('--board', help='<board_name.kicad_pcb>', required=True)
    parser.add_argument('--mat_th', type=float, help='material thickness (mm)', required=True)
    parser.add_argument('--out', help='output directory', required=True)

    # Add optional arguments
    parser.add_argument('--pcb_th', type=float, help='pcb thickness (mm)')
    parser.add_argument('--pcb_h', type=float, help='pcb component height (mm)')
    parser.add_argument('--screw_len', type=float, help='Assembly screw thread length (default = 16mm)')
    parser.add_argument('--screw_d', type=float, help='Assembly screw diameter (default=3mm)')
    parser.add_argument('--layer', help='F.Cu | B.Cu')
    parser.add_argument('--flayer', help='Eco1.User | Eco2.User')
    parser.add_argument('--ilayer', help='Eco1.User | Eco2.User')
    parser.add_argument('--rev', help='Override revision')
    parser.add_argument('--pogo_d', type=float, help='Pogo hole diameter (default=1.22mm)')
    parser.add_argument('--washer_th', type=float, help='Washer thickness for hinge')
    parser.add_argument('--nut_f2f', type=float, help='hex nut flat to flat (mm)')
    parser.add_argument('--nut_c2c', type=float, help='hex nut corner to corner (mm)')
    parser.add_argument('--nut_th', type=float, help='hex nut thickness (mm)')
    parser.add_argument('--pivot_d', type=float, help='Pivot diameter (mm)')
    parser.add_argument('--border', type=float, help='Board (ledge) under pcb (mm)')
    parser.add_argument('--render', help='Generate a 3d render of the final fixture', action='store_true')
    parser.add_argument('--kicad', help='Generate a KiCad project', action='store_true')
    parser.add_argument('--annular', type=float, help='Annular ring width for PADS on PCB', default=.25)
    parser.add_argument('--logo', help='Override logo')
    parser.add_argument('--logo-w', type=float, help='Set logo width, mm', default=50)
    parser.add_argument('--logo-h', type=float, help='Set logo height, mm', default=50)
    parser.add_argument('--pins', help='Extra pins to include (THT/SMD) REF-PINNBR - comma separated')
    parser.add_argument('--exclude-size', help='Module refs to exclude from board size - comma separated')

    # Get args
    args = parser.parse_args()

    # Convert path to absolute
    out_dir = os.path.abspath(args.out)

    # If output directory doesn't exist create it
    if not os.path.exists(out_dir):
        os.makedirs(out_dir)

    # Load up the board file
    brd = LoadBoard(args.board)

    # Extract project name
    prj_name = os.path.splitext(os.path.basename(args.board))[0]

    # Save internal parameters
    layer = brd.GetLayerID(args.layer)
    flayer = brd.GetLayerID(args.flayer)
    ilayer = brd.GetLayerID(args.ilayer)

    # Check for pcb thickness
    if args.pcb_th is None:
        args.pcb_th = 1.6

    if args.pins is not None:
        pins = args.pins.split(',')
    else:
        pins = []

    if args.exclude_size is not None:
        exclude_size_refs = args.exclude_size.split(',')
    else:
        exclude_size_refs = []

    # Create a fixture generator
    fixture = GenFixture(prj_name, brd, args.mat_th)

    # Set parameters
    fixture.SetParams(args.pcb_th, args.screw_len, args.screw_d);

    # Setup layers
    fixture.SetLayers(layer=layer, flayer=flayer, ilayer=ilayer)

    # Set optional arguments
    fixture.SetOptional(rev=args.rev,
                        washer_th=args.washer_th,
                        nut_f2f=args.nut_f2f,
                        nut_c2c=args.nut_c2c,
                        nut_th=args.nut_th,
                        pcb_h=args.pcb_h,
                        pogo_d=args.pogo_d,
                        pivot_d=args.pivot_d,
                        border=args.border,
                        render=args.render, 
                        kicad=args.kicad, 
                        annular=args.annular, 
			pins=pins,
			exclude_size_refs=exclude_size_refs,
                        logo=args.logo, 
                        logosize=(args.logo_w, args.logo_h)
    )

    # Generate fixture
    fixture.Generate(out_dir)
    # print fixture
