include <gearLib.scad>
$fn = 50;


boltDiameter = 5.1;
boltHeight = 18;
height = 5;
translate([.5/2+2, 0, boltHeight / 2])
cube([.5, 3, boltHeight], true);



//spur_gear(1, 15, height, boltDiameter);
spur_gear(1, 20, height, boltDiameter);

translate([0, 0, height - 1])
difference() {
    cylinder(boltHeight - height + 1, r=4);
    translate([0, 0, -1])
    cylinder(boltHeight - height + 2, r=boltDiameter/2);
}