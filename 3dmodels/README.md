# Pin 3D Models

Most Pogo Pin models are generated using the `create-steps.sh` script that
calls upon the `pogopins.scad` script. At this time they are not verified
against physical pins so measures may be incorrect.

There are other 3D Models available on the Web that are not provided in
this repository. They can be downloaded from the following sources and are
subject to their respective licences.

- https://grabcad.com/library/pogo-pins-1

# Actual Pogo-pins

- After inserting the P50-J1 pin in the R50-2W7 socket, the total extended
  length is about 21mm. The non moving part of the pin enters entirely in
  the socket. The moving part of the pin extends about 3.5mm from the end
  and retracts fully when pushed.\
  The R-50-2W7 is 13mm in length from the
  pin entry up to the retraction before the wire.\
  The Wire entry up to the
  retraction is 4.5mm, the total length of the socket is 17.5mm The
  extrusion on the R50-2W7 socket is 2.5mm from the edge

# TODO

- Add more pin heads;
- Also generate "compressed" versions of the PIN Models (i.e., versions
  where the pin extends less from the socket because it is compressed
  against a board).
