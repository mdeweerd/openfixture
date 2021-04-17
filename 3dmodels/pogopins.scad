pin_type="E2";
pin_corps_d=1.36;
pin_notch_off=7;
pin_corps_len=25;

//socket_type="1W";
//socket_type="2W";
//socket_type="4W";
//socket_type="5W";
//socket_type="2S";
socket_type="4S";
//socket_type="4VW";
//socket_type="3T";

pin_head_diameter=1;
pin_head_margin=0.02;
pin_corps_empty_diameter=pin_head_diameter+pin_head_margin;

pin_center_barrel_offset=10;
pin_center_barrel_ext_len=6.35;
pin_center_barrel_len=pin_corps_len-pin_center_barrel_offset+pin_center_barrel_ext_len;

module pin_head() {

  // Pin outer cylinder
  difference() {
    cylinder(h=pin_corps_len,d=pin_corps_d,$fa=1,$fs=0.01,$fn=100);
    union() {
      // Remove center of cilinder
      translate([0,0,1]) // Bottom of 1mm
        cylinder(h=pin_corps_len,d=pin_corps_empty_diameter,$fa=1,$fs=0.01,$fn=100);
      // Create "notch" in cylinder
      translate([0,0,pin_corps_len-pin_notch_off])
        difference() {
          translate([0,0,-0.5])
            cylinder(h=1,d=pin_corps_d,$fa=1,$fs=0.01,$fn=100);
          union() {
            cylinder(h=0.5,d2=pin_corps_d,d1=pin_corps_d-0.25,$fa=1,$fs=0.01,$fn=100);
            mirror([0,0,1])
              cylinder(h=0.5,d2=pin_corps_d,d1=pin_corps_d-0.25,$fa=1,$fs=0.01,$fn=100);
          }
        }
    }
  }


  translate([0,0,pin_center_barrel_offset])
    cylinder(h=pin_center_barrel_len,d=pin_head_diameter,$fa=1,$fs=0.01,$fn=100,center=false);

  pin_top_offset=pin_center_barrel_offset+pin_center_barrel_len;

  if(pin_type=="E2") {
    pin_top_diam=1.5;
    pin_top_h=2.0;
    color("blue")
      translate([0,0,pin_top_offset])
        intersection() {
          cylinder(h=pin_top_h,d=pin_top_diam,$fa=1,$fs=0.01,$fn=100,center=false);
          // 90° cone
          cylinder(h=pin_top_h,d1=pin_top_h*2,d2=0,$fa=1,$fs=0.01,$fn=100,center=false);
        };
  } else if(pin_type=="A2") {
  }
}


  cil_top_h=25;
  ring_mid_d=1.83;
  ring_top_d=1.9;
  cil_top_d=1.68;
  cil_mid_h=5;
  cil_mid_d=1.47;
  cub_bot_side=0.64;
  bot_d=1;

  mid_cone_h=cil_mid_d*2;

  ring_mid_off= // Ring offet from top
    ((socket_type=="1W")||(socket_type=="2W"||socket_type=="2S"))
       ?2.5
    :(socket_type=="3T")?5
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
      translate([0,0,-cil_top_h])
        cylinder(h=cil_top_h,d=cil_top_d,$fa=1,$fs=0.01,$fn=100);
      translate([0,0,-cil_top_h-cil_mid_h])
        union() {
          cylinder(h=cil_mid_h,d=cil_mid_d,$fa=1,$fs=0.01,$fn=100);
          translate([0,0,cil_mid_h-mid_cone_h])
            cylinder(h=mid_cone_h,d1=0,d2=cil_top_d,$fa=1,$fs=0.01,$fn=100);
        }
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
    translate([0,0,-cil_top_h+1])
      cylinder(h=cil_top_h+1,d=pin_corps_d+0.02,$fa=1,$fs=0.01,$fn=100);
  }

}

module ring(D = 1, d = 10,$fn=100,center=true)
{
  rotate_extrude(angle=360)
    translate([d/2 - D/2, 0]) 
      circle(d=D);
}

  translate([0,0,cil_top_h+0.1])
    socket();
  translate([0,0,0.1+pin_notch_off-ring_mid_off])
    pin_head();
