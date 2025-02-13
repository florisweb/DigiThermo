include <gearLib.scad>

$fn = 100;
PI = 3.14159;

housingThickness = 2;
bottomThickness = 1;

bigRadius = (182) / 2 / PI;
latchRadius = (150 + 1)/2/PI;
gripperRingRadius = (170 + 2)/2/PI;
gripperCount = 18;
gripperWidth = 6;


height = 19;
gripperRingHeight = 9;
gripperCutOut = 20;

screwRadius = 1.55;

difference() {
    component();
    translate([gripperRingRadius * 3/2, 0])
    cube([gripperRingRadius * 3, gripperRingRadius * 20, 50], true);
}

module component() {
    translate([0, 0, height - gripperRingHeight])
    gripperRing();
    

    difference() {
        //75, +9mm          // 94teeth, 43rad
        spur_gear(1, 150, 5, (bigRadius + housingThickness) * 2);
        translate([0, 0, 2])
        cylinder(5, r1=72, r2=72);
    }
    tube(height - gripperRingHeight, bigRadius, housingThickness);
    tube(bottomThickness, latchRadius, bigRadius + housingThickness - latchRadius);
   
    
    connPointHeight = 17;
    connPointWidth = 7;
    
    translate([0, bigRadius + housingThickness + connPointWidth / 2 - 1, height / 2])
    rotate([0, 0, 90])
    connectionPoint(connPointWidth, connPointHeight, 8, screwRadius);
    
    translate([0, -bigRadius - housingThickness - connPointWidth / 2 + 1, height / 2])
    rotate([0, 0, 90])
    connectionPoint(connPointWidth, connPointHeight, 8, screwRadius);

}
    

module gripperRing() {
    tube(gripperRingHeight, bigRadius, housingThickness);
    difference() 
    {
        tube(gripperRingHeight, gripperRingRadius, bigRadius - gripperRingRadius);
           
        for (i = [0:1:gripperCount])
        {
            rotate(i / gripperCount * 360)
            {
                translate([0, 0, + gripperRingHeight])
                cube([bigRadius * 2, gripperWidth, gripperRingHeight + 20], true);
            }
        }
    }
}


//translate([0, 0, -verticalBarHeight/2]) barClip();



module tube(height, radius, thickness) {
    difference() {
        cylinder(height, r=radius + thickness, true);
        translate([0, 0, -1])
        cylinder(height + 2, r=radius, true);
    }
}





module connectionPoint(width, height, thickness, radius) {
    rotate([90, 0, 0])
    difference() {
        cube([width, height, thickness], true);
        translate([0, 0, -thickness])
        cylinder(thickness * 2, r=radius, true);       
    }
}

