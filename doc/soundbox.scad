// Based on Customizable snap-fit electronics project box enclosure by 0707070
// CC-BY · https://www.thingiverse.com/thing:2866563

// Which one would you like to see?
part = "both"; // [box:Box only, top: Top cover only, both: Box and top cover]

// Size of your printer's nozzle in mm
nozzle_size = 0.4;

// Number of walls the print should have
number_of_walls = 4; // [1:5]

// Tolerance (use 0.2 for FDM)
tolerance = 0.2; // [0.1:0.1:0.4]

// Outer x dimension in mm
x=85+2*number_of_walls*nozzle_size+2*3*nozzle_size;

// Outer y dimension in mm
y=85+2*number_of_walls*nozzle_size+2*3*nozzle_size;

// Outer z dimension in mm
z=80+2*number_of_walls*nozzle_size+2*3*nozzle_size;

// Radius for rounded corners in mm
radius=4; // [1:20]

/* Hidden */
$fn=100;

wall_thickness=nozzle_size*number_of_walls;
hook_thickness = 3*nozzle_size;

top_cover_wall_thickness = hook_thickness + wall_thickness;

module bottom_box2 () {
    difference(){
        // Solid box
        linear_extrude(z-wall_thickness){
            minkowski(){
                square([x-radius*2,y-radius*2], center=true);
                circle(radius, center=true);
            }
        }
        
        // Hollow out
        translate([0,0,wall_thickness]) linear_extrude(z){
            minkowski(){
                square([x-radius*2-wall_thickness*2+wall_thickness*2,y-radius*2-wall_thickness*2+wall_thickness*2], center=true);
                circle(radius-wall_thickness);
            }
        }
    }
    left_hook(); // left hook
    rotate([180,180,0]) left_hook(); // right hook
    front_hook(); // front hook
    rotate([180,180,0]) front_hook(); // back hook
    // TODO: hooks on the other two sides
}

module bottom_box () {
    difference(){
        bottom_box2();
        translate([-30, -30, -5]) cylinder(10, 2, 2);
        translate([-30, 30, -5]) cylinder(10, 2, 2);
        translate([30, -30, -5]) cylinder(10, 2, 2);
        translate([30, 30, -5]) cylinder(10, 2, 2);
        
        for ( x=[0:20], y=[0:20]) {
            translate([-25.5 + x*2.5, -25.5 + y*2.5, -5]) cylinder(10, .75, .75);
        }
    }
}

module left_hook () {
    
    translate([(x-2*wall_thickness)/2,-y/2+radius*2,z-wall_thickness]) rotate([0,90,90]) {
        difference(){
            linear_extrude(y-2*radius*2){
    polygon(points=[[0,0],[2*hook_thickness,0],[hook_thickness,hook_thickness]], center=true);
        }
             translate([hook_thickness, hook_thickness, 0]) rotate([45,0,0]) cube(2*hook_thickness, center=true);
             translate([hook_thickness, hook_thickness, y-2*radius*2]) rotate([45,0,0]) cube(2*hook_thickness, center=true);        
        }
    }
}
    

module front_hook () {
    translate([(-x+4*radius)/2,-y/2+wall_thickness,z-wall_thickness]) rotate([90,90,90]) {
        difference(){
        linear_extrude(x-2*radius*2){
    polygon(points=[[0,0],[2*hook_thickness,0],[hook_thickness,hook_thickness]], center=true);
    }
             translate([hook_thickness, hook_thickness, 0]) rotate([45,0,0]) cube(2*hook_thickness, center=true);
             translate([hook_thickness, hook_thickness, x-2*radius*2]) rotate([45,0,0]) cube(2*hook_thickness, center=true);
        }
    }
}


module right_grove () {
    translate([-tolerance/2+(x-2*wall_thickness)/2,-y/2+radius,wall_thickness+hook_thickness*2]) rotate([0,90,90]) linear_extrude(y-2*radius){
    polygon(points=[[0,0],[2*hook_thickness,0],[hook_thickness,hook_thickness]], center=true);
    }
}


module front_grove () {
    translate([(-x+2*radius)/2,-y/2+wall_thickness+tolerance/2,wall_thickness+hook_thickness*2]) rotate([90,90,90]) linear_extrude(x-2*radius){
    polygon(points=[[0,0],[2*hook_thickness,0],[hook_thickness,hook_thickness]], center=true);
    }
}

module top_cover2 () {

    
        {
            // Top face
            linear_extrude(wall_thickness){
                minkowski(){
                    square([x-radius*2,y-radius*2], center=true);
                    circle(radius, center=true);
                }
            }
            
            difference(){
                // Wall of top cover
                linear_extrude(wall_thickness+hook_thickness*2){
                    minkowski(){
                        square([x-radius*2-wall_thickness*2-tolerance+wall_thickness*2,y-radius*2-wall_thickness*2-tolerance+wall_thickness*2], center=true);
                        circle(radius-wall_thickness, center=true);
                    }
                }
                
                // Hollow out
                // TODO: If radius is very small, still hollow out

                translate([0,0,wall_thickness]) linear_extrude(z){
                    minkowski(){
                        square([x-radius*2-wall_thickness*2-2*top_cover_wall_thickness-tolerance+wall_thickness*2+top_cover_wall_thickness*2,y-radius*2-wall_thickness*2-2*top_cover_wall_thickness-tolerance+wall_thickness*2+top_cover_wall_thickness*2], center=true);
                    circle(radius-wall_thickness-top_cover_wall_thickness);
                    }
                }
            right_grove();
            rotate([180,180,0]) right_grove();
            front_grove();
            rotate([180,180,0])  front_grove();
                
            }
    }

}

module top_cover() {
    difference() {
            top_cover2();
            translate([0, 0, -15])
                cylinder(25, 11.50, 11.50);
    }
}

// left_hook();
print_part();

module print_part() {
	if (part == "box") {
		bottom_box();
	} else if (part == "top") {
		top_cover();
	} else if (part == "both") {
		both();
	} else {
		both();
	}
}

module both() {
	translate([0,-(y/2+wall_thickness),0]) bottom_box();
    translate([0,+(y/2+wall_thickness),0]) top_cover();
}
