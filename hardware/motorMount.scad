$fn = 100;

housingThickness = 2;


barRadius = 11;
height = 70;
motorHeight = 44;
width = 40;
motorDepth = 40;


screwRadius = 1.55;
screwRadiusSmooth = 1.65;


tailWidth = 44; // 45 -> 
tailOffset = -12.5;
tailLength = 67 + barRadius;


difference() 
{
    build();
    
    //Cut it in half
//    translate([0, -300/2, -500/2]) // Left
    translate([-500, -300/2, -500/2]) // Right
    cube([500, 300, 500]);
}


module build() {  
    difference() {
        rawStructure();
        cylinder(height, r=barRadius);
    }
}

module rawStructure() {

    difference() 
    {
        tube(height, barRadius, housingThickness);
        translate([-width/2, 0, (height - motorHeight)/2])
        cube([width, motorDepth, motorHeight]);
    }

    motorHousing();
    tail();
}



module motorHousing() {
    translate([-width/2, motorDepth + barRadius, (height - motorHeight)/2])
    motorMount(width, motorHeight);
    
    extraLength = 15;
    difference() 
    {
        translate([-width/2, -extraLength, 0])
        {
            translate([0, 0, (height - motorHeight)/2 - housingThickness])
            cube([width, motorDepth + barRadius + housingThickness + extraLength, housingThickness]);
            translate([0, 0, height - (height - motorHeight)/2])
            cube([width, motorDepth + barRadius + housingThickness + extraLength, housingThickness]);
        }
        
        translate([barRadius - 1.5, -barRadius * 1.37, 0])
        rotate([0, 0, -30])
        cube([50, 50, height]);

        translate([-barRadius + .3, -barRadius * 1.37, 0])
        rotate([0, 0, 30+90])
        cube([50, 50, height]);
    }
    
    
    connPointHeight = 7;
    connPointWidth = 10;
    translate([0, barRadius + connPointWidth / 2, (height - motorHeight)/2 - housingThickness - connPointHeight / 2])
    rotate([0, 0, 90])
    connectionPoint(connPointWidth, connPointHeight, 8, screwRadius);
    
    translate([0, barRadius + connPointWidth / 2, height - (height - motorHeight)/2 + housingThickness + connPointHeight / 2])
    rotate([0, 0, 90])
    connectionPoint(connPointWidth, connPointHeight, 8, screwRadius);
    
    


    translate([0, motorDepth + barRadius - connPointWidth / 2 + housingThickness, (height - motorHeight)/2 - housingThickness - connPointHeight / 2])
    rotate([0, 0, 90])
    connectionPoint(connPointWidth, connPointHeight, 8, screwRadius);
    
    translate([0, motorDepth + barRadius - connPointWidth / 2 + housingThickness, height - (height - motorHeight)/2 + housingThickness + connPointHeight / 2])
    rotate([0, 0, 90])
    connectionPoint(connPointWidth, connPointHeight, 8, screwRadius);
    
    
}
    

module motorMount(width, height) {
    holeDistance = 31;

    thickness = 2;
    motorHoleRadius = 12;
    xPadding = (width - (holeDistance + screwRadius * 2))/2;
    yPadding = (height - (holeDistance + screwRadius * 2))/2;

    
    difference() {
        cube([
            width,
            thickness, 
            height
        ]);
        
        translate([xPadding + screwRadius, thickness + 1, yPadding + screwRadius])
        {
            rotate([90, 0, 0]) cylinder(thickness + 2, r=screwRadius, true);

            translate([holeDistance, 0, 0])
            rotate([90, 0, 0]) cylinder(thickness + 2, r=screwRadius, true);
            translate([0, 0, holeDistance])
            rotate([90, 0, 0]) cylinder(thickness + 2, r=screwRadius, true);
            translate([holeDistance, 0, holeDistance])
            rotate([90, 0, 0]) cylinder(thickness + 2, r=screwRadius, true);
                
            translate([holeDistance / 2, 0, holeDistance / 2])
            rotate([90, 0, 0]) cylinder(thickness + 2, r=motorHoleRadius, true);
        }
    }
}


module tail() {
    difference() {
        difference() {
            translate([-tailWidth/2, -tailLength, (height - motorHeight)/2 - housingThickness])
            {
                difference() 
                {
                    tailThicknessAtEnd = 10;
                    difference() 
                    {
                        translate([tailOffset, 0, 0])
                        cube([tailWidth, tailLength, motorHeight + housingThickness * 2]);
                        
                        radius = tailLength + 20;
                        translate([-tailWidth/2, 0, -radius + motorHeight / 2 - tailThicknessAtEnd / 2])
                        rotate([90, 0, 90])
                        cylinder(tailWidth * 2, r=radius);
                        translate([-tailWidth/2, 0, radius + motorHeight / 2 + tailThicknessAtEnd / 2])
                        rotate([90, 0, 90])
                        cylinder(tailWidth * 2, r=radius);
                    }
                    
                    radius = tailLength + 40;
                    inset = width / 2;

                    translate([-radius + tailWidth / 2 - inset / 2, tailLength, 0])
                    cylinder(tailWidth * 2, r=radius);
                    translate([radius + tailWidth / 2 + inset / 2, tailLength, 0])
                    cylinder(tailWidth * 2, r=radius);
                }
            }
            
            translate([-50, -18, height / 2 - screwRadiusSmooth])
            rotate([0, 90, 0])
            cylinder(100, r=screwRadiusSmooth);
        }
        

        triSize = 18;
        translate([150, -33, height / 2 - 2])
        rotate([90, 0, -90])
        cylinder(300, r=triSize, $fn = 3);
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



module tube(height, radius, thickness) {
    difference() {
        cylinder(height, r=radius + thickness, true);
        translate([0, 0, -1])
        cylinder(height + 2, r=radius, true);
    }
}








//    difference() {
//        translate([0, -horizontalBarLength, -45/2])
//        motorMount(horizontalBarRadius + housingThickness + 40, 45, screwRadius);
//            
//        translate([0, 20, 0])
//        rotate([90, 0, 0])
//        cylinder(50, r=horizontalBarRadius + housingThickness);
//    }




module barClip() {
    difference() {
        halfTube(verticalBarHeight, verticalBarRadius, housingThickness);
    }

   



    translate([
        housingThickness / 2, 
        -verticalBarRadius - 8, 
        verticalBarHeight / 2 + horizontalBarRadius + housingThickness + 5/2
    ]) {
        rotate([0, 0, 90]) connectionPoint(5, 5, housingThickness, screwRadius);
        
        translate([0, 0, -(horizontalBarRadius + housingThickness) * 2 - 5])
        rotate([0, 0, 90]) connectionPoint(5, 5, housingThickness, screwRadius);
    }



    translate([
        housingThickness / 2, 
        verticalBarRadius + 4.5, 
        verticalBarHeight / 2
    ])
    rotate([0, 0, 90]) 
    connectionPoint(5, 5, housingThickness, screwRadius);
}
    



module halfTube(height, radius, thickness) {
    difference() {     
        difference() {
            cylinder(height, r=radius + thickness, true);
            translate([0, 0, -1])
            cylinder(height + 2, r=radius, true);
        }
         // Cut off the right half
        translate([-radius, 0, height / 2]) 
        cube([radius * 2, radius * 2.5, height + 2], true);
    }
}



