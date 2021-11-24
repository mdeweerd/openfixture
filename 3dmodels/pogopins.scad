/**
 * Author: Mario DE WEERD - https://github.com/mdeweerd
 *
 * License: CC-BY-SA
 *   See: by-sa-4.0.md or https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
 */
// This script generates POGOPIN models.
// Note: The result has not been compared with physical pins yet.
gold="#ffd700";

pin_type="B1";
//socket_type="1W";
//socket_type="2W";
socket_type="2W7";
//socket_type="4W";
//socket_type="5W";
//socket_type="2S";
//socket_type="4S";
//socket_type="4VW";
//socket_type="3T";
//family="R100";
family="R50";

pin_corps_d=(family=="R100")?1.36:
              (
               (family=="R50")?0.68:
                  -1
              );
pin_notch_off=(family=="R100")?7:
              (
               (family=="R50")?5: // Estimate
                  -1
              );
pin_corps_len=(family=="R100")?25:
              (
               (family=="R50")?13:
                  -1
              );


pin_head_diameter=((family=="R100")?1:((family=="R50")?0.48:-1));
pin_head_margin=0.02;
pin_corps_empty_diameter=pin_head_diameter+pin_head_margin;

pin_center_barrel_offset=10;
pin_center_barrel_ext_len=
          family=="R100"?6.35:
          (family=="R50"?2.65 // 2.65=average? - 3.5 measured
          :-1);
pin_center_barrel_len=pin_corps_len-pin_center_barrel_offset+pin_center_barrel_ext_len;

module pin_head() {

  // Pin outer cylinder
  difference() {
    cylinder(h=pin_corps_len,d=pin_corps_d,$fa=1,$fs=0.01,$fn=100);
    union() {
      // Remove center of cylinder
      translate([0,0,1]) // Bottom of 1mm
        cylinder(h=pin_corps_len,d=pin_corps_empty_diameter,$fa=1,$fs=0.01,$fn=100);
      if(0) // No notch was observed on the P50 pin type, disabling this.
      // Create "notch" in cylinder
      translate([0,0,pin_corps_len-pin_notch_off])
        difference() {
          translate([0,0,-0.5])
            cylinder(h=1,d=pin_corps_d,$fa=1,$fs=0.01,$fn=100);
          union() {
            cylinder(h=0.5,d2=pin_corps_d,d1=pin_corps_d*.85,$fa=1,$fs=0.01,$fn=100);
            mirror([0,0,1])
              cylinder(h=0.5,d2=pin_corps_d,d1=pin_corps_d*.85,$fa=1,$fs=0.01,$fn=100);
          }
        }
    }
  }


  translate([0,0,pin_center_barrel_offset])
    cylinder(h=pin_center_barrel_len,d=pin_head_diameter,$fa=1,$fs=0.01,$fn=100,center=false);

  pin_top_offset=pin_center_barrel_offset+pin_center_barrel_len;

  pin_top_diam=
    (family=="R100")?(
     (pin_type=="E2"||pin_type=="A2"||pin_type=="D2"||pin_type=="G2"||pin_type=="H2"||pin_type=="LM2"||pin_type=="Q2"||pin_type=="T2"||pin_type=="M3")
     ?1.5
    :(pin_type=="A3"||pin_type=="E3"||pin_type=="D3"||pin_type=="H3")
     ?1.8
     :(pin_type=="B1")
     ?0.99
     :(pin_type=="F1"||pin_type=="J1"||pin_type=="Q1"||pin_type=="G1")
     ?1.0
     :(pin_type=="H4")
     ?2.0
     :(pin_type=="H5")
     ?2.5
     :(pin_type=="H6")
     ?3.0
     :-1) // Invalid
   :
    (family=="R50")?
     (
      (pin_type=="E2"||pin_type=="A2"||pin_type=="D2"||pin_type=="E2"||pin_type=="G2"||pin_type=="H2"||pin_type=="LM2"||pin_type=="Q2"||pin_type=="T2")
     ?0.9 // 2
     :(pin_type=="B1"||pin_type=="F1"||pin_type=="F"||pin_type=="J1"||pin_type=="Q1"||pin_type=="G1")
      ?0.48 // 1
      :(pin_type=="E3"||pin_type==H3)
      ?1.20 // 3
      :(pin_type=="1D"||pin_type=="1E")
      ?0.6
     :-1 // Invalid
    ):-1;
  pin_top_h=
    (family=="R100")?(
     (pin_type=="M3")
     ?7.0
     :2.0)
    :((family=="R50")?
        ((pin_type=="B1"||pin_type=="J1"||pin_type=="Q1"||pin_type=="G1")
         ?0.7:0.9)
      :-1)
  ;

  if(pin_type=="E2"||pin_type=="E3") {
      translate([0,0,pin_top_offset])
        intersection() {
          cylinder(h=pin_top_h,d=pin_top_diam,$fa=1,$fs=0.01,$fn=100,center=false);
          // 90° cone
          cylinder(h=pin_top_h,d1=pin_top_h*2,d2=0,$fa=1,$fs=0.01,$fn=100,center=false);
        };
  } else if(pin_type=="A2"||pin_type=="A3") {
echo(pin_top_diam);
      translate([0,0,pin_top_offset])
        difference() {
          cylinder(h=pin_top_h,d=pin_top_diam,$fa=1,$fs=0.01,$fn=100,center=false);
          translate([0,0,pin_top_h+pin_top_diam/2])
            mirror([0,0,1])
              cylinder(h=pin_top_h,d1=pin_top_h*2,d2=0,$fa=1,$fs=0.01,$fn=100,center=false);
        };
  } else if(pin_type=="G2"||pin_type=="G1") {
      translate([0,0,pin_top_offset])
        cylinder(h=pin_top_h,d=pin_top_diam,$fa=1,$fs=0.01,$fn=100,center=false);
  } else if(pin_type=="B1") {
      //color("red")
      translate([0,0,pin_top_offset])
        cylinder(h=pin_top_diam*cos(45),d2=0,d1=pin_top_diam,$fa=1,$fs=0.01,$fn=100,center=false);
  }
}


  cil_top_h=(family=="R100"?25:(family=="R50"?13:-1));
  ring_mid_d=(family=="R100"?1.83:(family=="R50"?0.95:-1));
  ring_top_d=(family=="R100"?1.9:(family=="R50"?0.98:-1));
  cil_top_d=(family=="R100"?1.68:(family=="R50"?0.86:-1));
  cil_mid_h=(family=="R100"?5:(family=="R50"?4.5:-1)); // Same for R100,R50
  cil_mid_d=(family=="R100"?1.47:(family=="R50"?0.75:-1));
  cub_bot_side=0.64;
  bot_d=1;

  mid_cone_h=cil_mid_d*2;

  ring_mid_off= // Ring offet from top
    (socket_type=="1W"||socket_type=="2W"||socket_type=="2S"||socket_type=="2W7"||socket_type=="1W7"||socket_type=="2C")
       ?2 // Changed to 2 as observed on 2W7 measurement (was: 2.5)
    :(socket_type=="3T"||socket_type=="3C"||socket_type=="3S")?5
    :(socket_type=="4W"||socket_type=="4S"||socket_type=="4VW")
       ?7.5
    :(socket_type=="5W"||socket_type=="2S")
    ?10
    :-1;

  square_bot=
    (socket_type=="1W"||socket_type=="2W"||socket_type=="4W"||socket_type=="5W");
  circ_bot=(socket_type=="4VW"||socket_type=="3T");
  bot_h=(socket_type=="3T")?4.5:9;

module socket() {
  difference() {
    union() {
//color("red")
      // Top part of socket
      translate([0,0,-cil_top_h])
        cylinder(h=cil_top_h,d=cil_top_d,$fa=1,$fs=0.01,$fn=100);
      translate([0,0,-cil_top_h-cil_mid_h])
        union() {
          cylinder(h=cil_mid_h,d=cil_mid_d,$fa=1,$fs=0.01,$fn=100);
          translate([0,0,cil_mid_h-mid_cone_h])
            cylinder(h=mid_cone_h,d1=0,d2=cil_top_d,$fa=1,$fs=0.01,$fn=100);
        }
      // Bottom, depending on type
      if(square_bot) {
        translate([-cub_bot_side/2,-cub_bot_side/2,-cil_top_h-cil_mid_h-bot_h])
          cube([cub_bot_side,cub_bot_side,bot_h]);
      }
      if(circ_bot) {
        translate([0,0,-cil_top_h-cil_mid_h-bot_h])
          cylinder(d=bot_d,h=bot_h,$fa=1,$fs=0.01,$fn=100);
      }
      if(socket_type=="1W") {
        translate([0,0,-0.5/2])
          ring(d=cil_top_d+0.5/2,D=0.5);
      }
      translate([0,0,-ring_mid_off])
        ring(d=cil_top_d+0.5/2,D=0.5);
    };
    // Remove center of cilinder - allow pin to enter completely
    translate([0,0,-pin_corps_len+0.001])
      cylinder(h=pin_corps_len+pin_head_margin,d=pin_corps_d+0.02,$fa=1,$fs=0.01,$fn=100);
  }

}

module ring(D = 1, d = 10,$fn=100,center=true)
{
  rotate_extrude(angle=360)
    translate([d/2 - D/2, 0]) 
      circle(d=D);
}

z_zero_offset=0.1;
color(gold)
union() {
  // Combine socket and pin.
  translate([0,0,cil_top_h+z_zero_offset])
    socket();
  // The notch offset was removed as it was no observed on the physical pin.
  //translate([0,0,z_zero_offset+cil_top_h-pin_corps_len+pin_notch_off-ring_mid_off])
  // The non-moving part of the pin enters entirely in the socket
  translate([0,0,z_zero_offset+cil_top_h-pin_corps_len])
    pin_head();
}

