
innerRadiusA = 29.5;
innerRadiusB = 27.85;
outerRadius = innerRadiusA + 2;
wrapperHeight = 30;

gearHeight = 5;
innerRadiusGear = 60;
outerRadiusGear = 62;
teethCount = 100;

teethSize = 2 * PI * innerRadiusGear / teethCount / 1.73; // 1.73 = tan(60)
teethDepth = 3;

connectingSegmentHeight = 2;


translate([0, 0, wrapperHeight / 2])
    difference() {
       cylinder(wrapperHeight, outerRadius, outerRadius, center=true);
       cylinder(wrapperHeight * 1.001, innerRadiusA, innerRadiusB, center=true);
    }
translate([0, 0, wrapperHeight - connectingSegmentHeight / 2])
    difference() {
       cylinder(connectingSegmentHeight, outerRadiusGear, outerRadiusGear, center=true);
       cylinder(connectingSegmentHeight * 1.001, innerRadiusA, innerRadiusB, center=true);
    }

    

translate([0, 0, gearHeight / 2])
    union() {
        translate([0, 0, wrapperHeight])
            difference() {
                cylinder(gearHeight, outerRadiusGear, outerRadiusGear, center=true);
                cylinder(gearHeight * 1.001, innerRadiusGear, innerRadiusGear, center=true);
            }

        for (i = [0:1:teethCount])
        {
            angle = 360 * i / teethCount;
            rotate(angle)
                translate([innerRadiusGear - teethDepth / 2, 0, wrapperHeight])
                    teeth(angle, true);
            
        }
    }



  
module teeth(angle, insideGear) {
    //rotate(25)
      //  cube([teethSize, teethSize, gearHeight], center=true);
    linear_extrude(height = gearHeight, center = true)
        scale([teethDepth / teethSize, 1, 1])
            rotate(insideGear ? 180 : 0)
                circle(teethSize,$fn=3);
}

/*

smallGearRadius = 10 - teethDepth * .9;
smallGearCircumference = smallGearRadius * 2 * PI;
smallGearTeethCount = floor(smallGearCircumference / teethSize / 1.8);

translate([48, 0, 2.5])
rotate(10)
    union() {
        translate([0, 0, wrapperHeight])
            cylinder(gearHeight, smallGearRadius, smallGearRadius, center=true);
         

        for (i = [0:1:teethCount])
        {
            angle = 360 * i / smallGearTeethCount;
            rotate(angle)
                translate([smallGearRadius + teethDepth / 2 - teethDepth * .1, 0, wrapperHeight])
                    teeth(angle, false);
            
        }
    }*/