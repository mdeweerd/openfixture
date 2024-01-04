# OpenFixture

![Alt text](/../images/screencap.png?raw=true)
![Alt text](/../images/laser_dxf.png?raw=true)
![Alt text](/../images/sample.jpg?raw=true)

## Goal

The motivation of OpenFixture was to make a parametric fixturing system
that could take fully generated inputs from kicad and produce a test
fixture with minimal effort. The easiest way to use it is through the kicad
python scripting interface.

The project has been extended with Test PCB Schematic generation - you may
want to generate only that without building the proposed fixture.

## Parameters

For most projects (if using the standard BOM) the only parameters you'll
need to set are mat_th and pcb_th. Something like the following should be
sufficient:

```
usage: GenFixture.py [-h] --board BOARD --mat_th MAT_TH --out OUT
                     [--pcb_th PCB_TH] [--pcb_h PCB_H] [--screw_len SCREW_LEN]
                     [--screw_d SCREW_D] [--layer LAYER] [--flayer FLAYER]
                     [--ilayer ILAYER] [--rev REV] [--pogo_d POGO_D]
                     [--washer_th WASHER_TH] [--nut_f2f NUT_F2F]
                     [--nut_c2c NUT_C2C] [--nut_th NUT_TH] [--pivot_d PIVOT_D]
                     [--border BORDER] [--render] [--kicad]
                     [--annular ANNULAR] [--logo LOGO] [--logo-w LOGO_W]
                     [--logo-h LOGO_H] [--pins PINS]
                     [--exclude-size EXCLUDE_SIZE]

optional arguments:
  -h, --help            show this help message and exit
  --board BOARD         <board_name.kicad_pcb>
  --mat_th MAT_TH       material thickness (mm)
  --out OUT             output directory
  --pcb_th PCB_TH       pcb thickness (mm)
  --pcb_h PCB_H         pcb component height (mm)
  --screw_len SCREW_LEN
                        Assembly screw thread length (default = 16mm)
  --screw_d SCREW_D     Assembly screw diameter (default=3mm)
  --layer LAYER         F.Cu | B.Cu
  --flayer FLAYER       Eco1.User | Eco2.User
  --ilayer ILAYER       Eco1.User | Eco2.User
  --rev REV             Override revision
  --pogo_d POGO_D       Pogo hole diameter (default=1.22mm)
  --washer_th WASHER_TH
                        Washer thickness for hinge
  --nut_f2f NUT_F2F     hex nut flat to flat (mm)
  --nut_c2c NUT_C2C     hex nut corner to corner (mm)
  --nut_th NUT_TH       hex nut thickness (mm)
  --pivot_d PIVOT_D     Pivot diameter (mm)
  --border BORDER       Board (ledge) under pcb (mm)
  --render              Generate a 3d render of the final fixture
  --kicad               Generate a KiCad project
  --annular ANNULAR     Annular ring width for PADS on PCB
  --logo LOGO           Override logo
  --logo-w LOGO_W       Set logo width, mm
  --logo-h LOGO_H       Set logo height, mm
  --pins PINS           Extra pins to include (THT/SMD) REF-PINNBR - comma
                        separated
  --exclude-size EXCLUDE_SIZE
                        Module refs to exclude from board size - comma
                        separated
```

The resulting output is:

- A 3D model of the test fixture for visualization (optional, with
  '--render')
- 2D DXF files that can be directly lasercut for assembly (several
  organisations)
- A kicad project for a test board (optional)

## Requirements

- Setup your path to run KiCad's python (or a python with pcbnew).
- You may need to install some modules.\
  Either to your personal directory
  (example for ezdxf module, required for KiCad
  generation):\
  `pip install --user ezdxf`\
  Either
  globally:\
  `pip install ezdxf`

## Recommended workflow for KiCad

1. Clone this repo if you haven't already
2. Setup a project specific bash script (use genfixture.sh as an example),
   and/or add a `fixture.conf` file to your project.
3. Enter board specific info, fixture hardware, material thickness, etc.
4. Whenever the layout changes call ./genfixture.sh (from repo) and pass
   path to .kicad_pcb file.
5. Fixture will be generated in $OUTPUT folder.

## Helper script

`genfixture.sh` is a helper script that you can call with just the path to
the PROJET.kicad_pcb file. You can add more options which will be appended
to the call to `GenFixture.py`.

On windows, that script can be used under cygwin. The `cygwin.setpath`
include script shows how you can set the system paths.

`genfixture.sh` also checks the directory where the project file is located
for a `fixture.conf` configuration file and includes the contents of that
file as a bash include script.

## Hints

- Examine the `genfixture.sh` helper script to learn about option.
- If you want smaller pogo pin holes for the test fixture than the PCB,
  perform multiple generations with different parameters.

## KiCAD Test Schematic & Board Generation

The `generate_kicad.py` script is called from `GenFixture.py` when the
`--kicad` option is added.

This generates a schematic sheet with the test pins connected to global
netnames corresponding to the netnames on the original schematic. It also
generates a board that puts the test pins in the right locations.

You can edit the board to change the EDGES to make a bigger board for
instance. You can edit the schematic to add other connectors for test
purposes or electronics for test purposes.

The best method would be the use of hierarchical sheets so that the POGOPIN
schematic can be regenerated.

## Hardware

- All that is needed is 14xM3 (14mm+) screws, 14xM3 hex nuts, and lasercut
  parts
- Nylon bushings in the main pivot with m3 screws for a smoother joint can
  be used, but this is optional

## Documentation

https://tinylabs.io/openfixture

## BOM

Material needed to build the Fixture: https://tinylabs.io/openfixture-bom

- 15 M3 nuts
- 15 M3 hex nuts
- Pogo sockets
- Pogo pins
- Glue

Pogo pins come in different sizes, and are composed of a socket and a pin.
There are R100 sockets, as well as R50 sockets and other sized. The drill
sizes change accordingly. You can find them from different sources. You can
find several source by looking for `R100-2S` or `R50-2W7`

- DirtyPCBs proposes R100-\* type sockets. Make sure that you use the
  corresponding P100-\* pins
  https://dirtypcbs.com/store/designer/details/ian/12/dirty-pogo-pins
- Aliexpress, Alibaba, Amazon, CDiscount are marketplaces where you can
  find many other vendors.

## STEP export

A standalone scad file is generated.\
Copy the logos and font to the
directory where the generated scad file is located. Or, copy the SCAD file
to the script directory. You can perform
`./convert_shape.py <SCADFILE> out.step` to convert to STEP for instance.

There is a bug in FreeCad 0.19 that prevents generation (on Windows)

## STL export

A standalone scad file is generated.\
Copy the logos and font to the
directory where the generated scad file is located. Or, copy the SCAD file
to the script directory. You can perform
`openscad --render -o out.stl <SCADFILE>` to convert to STL for instance.

## Testpoint validation

To verify that all your testpoints are within the PCB area, you can check
that no checkpoint appears in the `*-validate.dxf` file.

## Assembly

More info including detailed assembly instructions at
https://tinylabs.io/openfixture-assembly

## Dependencies

- Newer version of openscad >= 2015.03-1
- kicad or other EDA software. Please email me if you have instructions for
  other packages so I can add them.

## Known Issues

- When loading the fonts file a new small window opens in Ubuntu. Seems
  innocuous but still annoying \[Only seen on ubuntu 14.04\]
- STEP generation with FreeCAD is not entirely functional

## License

Creative Commons (CC BY-SA 4.0)

## Contributors

- Elliot Buller - Tiny Labs Inc
- Mario DE WEERD - Ynamics

(?) Please email with any pull requests or new feature requests
elliot@tinylabs.io

## Resources

KiCAD PCB generation script initiated from
https://github.com/jaseg/pogojig.git

## Work in progress / possible features

- The generation of a hierchical sheet is work in progress
- 3D models of test sockets and pins are generated. They must be verified
  and could be integrated as KiCad components.
- Mechanical holes should also be "exported" to the KiCad project to allow
  adding guides.
- Add a filter to exclude specific pins.
- KiCad integration (in a distant future)

# Old stuff

## KiCAD export

https://tinylabs.io/openfixture-kicad-export

Getting the test pins from the kicad schematic is integrated in this
project.
