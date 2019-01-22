/* January 21st, 2019
 * WaterWall - ASAP Media Services
 * An interactive projection display of water pouring down from the top of the screen. */


//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

import shiffman.box2d.*;              // Physics library - https://github.com/shiffman/Box2D-for-Processing
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.*;


int mode = 0;                         // 0: Draw, 1: Erase

ArrayList<Vec2> pre = new ArrayList<Vec2>();             // Surface currently being drawn
ArrayList<Surface> surfaces = new ArrayList<Surface>();  // All active surfaces
//ArrayList<Fish> fishes = new ArrayList<Fish>();        // Not adding this yet, or at all
ArrayList<PImage> images = new ArrayList<PImage>();      // Used for fish (Useless currently)
ArrayList<Particle> particles;                           // Particles that will fall onto surfaces

// Reference to box2d world
Box2DProcessing box2d;

boolean drawBarrier = false;      // Currently making a surface or not
Vec2 previous = new Vec2(0, 0);   // Location of previously made surface (Used to minimize error when using Epson pens)


void setup() {
  fullScreen(P3D);
  smooth();

  // Load images to use for fish
  images.add(loadImage("yellowFish.png"));
  images.add(loadImage("blueFish.png"));
  images.add(loadImage("niceFish.png"));
  images.add(loadImage("detailedFish.png"));

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -20);          // Custom gravity

  // Create the empty list
  particles = new ArrayList<Particle>();

  // Create a surface at the bottom of the screen
  pre.add(new Vec2(0, height));
  pre.add(new Vec2(width/2, height));
  pre.add(new Vec2(width, height));
  surfaces.add(new Surface(pre));
  pre = new ArrayList<Vec2>();

  //fishes.add(new Fish(new Vec2(width/2, height/2)));
}


void draw() {
  if (frameRate > 35) {
    // Add particles only when the device can handle more particles
    float sz = random(2, 4);  // Slight variation in start location
    particles.add(new Particle(width/2, 0, sz));
  }

  // We must always step through time!
  box2d.step();


  background(200);

  // Draw all active barriers
  for (int i=0; i<surfaces.size(); i++) {
    surfaces.get(i).display();
  }

  // Draw all particles
  for (Particle p : particles) {
    p.display();
  }

  // Needed if fish are re-added in the future
  //for (Fish f : fishes) {
  //  f.display();
  //}


  beginShape();
  noFill();
  stroke(0, 50);
  strokeWeight(5);
  for (Vec2 v : pre) {  // Display surface that is currently being drawn
    vertex(v.x, v.y);
  }
  endShape();

  // Remove particles that leave the screen
  // (note they have to be deleted from both the box2d world and our list
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    if (p.done()) {         // Removes particle from world
      particles.remove(i);  // Removes from list
    }
  }


  // Adding new points to a surface in draw mode
  if (drawBarrier) {
    Vec2 newVec = new Vec2(mouseX, mouseY);
    if (dist(newVec.x, newVec.y, previous.x, previous.y) > 0.2 && dist(newVec.x, newVec.y, previous.x, previous.y) < 100 || previous.x == 0) {
      // Only add a new vector if it is within acceptable range of the previous (Minimize error when using Epson pens)
      pre.add(new Vec2(newVec));
      previous = newVec;
    }
  }


  // Usesul information in the top left corner
  String modeText;
  if (mode == 0) {
    modeText = "draw";
  } else {
    modeText = "erase";
  }
  fill(50);
  text("framerate: " + (int)frameRate +
    "\n# of particles: " + particles.size() +
    "\n# of surfaces: " + surfaces.size() +
    "\ncurrent mode: "+modeText, 12, 16);


  // ERASE button
  fill(255);
  rect(width-110, 10, 100, 100);


  // DRAW button
  fill(0);
  rect(width-110, 140, 100, 100);


  // Erasing
  if (mousePressed && mode == 1) {
    for (int o=0; o<surfaces.size(); o++) {
      Surface s = surfaces.get(o);                  // Current surface being checked
      boolean removed = false;                      // Whether a point needs to be removed or not
      ArrayList<Vec2> p1 = new ArrayList<Vec2>();   // Left side of resultant surface
      ArrayList<Vec2> p2 = new ArrayList<Vec2>();   // Right side of resultant surface

      for (int i=0; i<s.points.size(); i++) {
        Vec2 point = s.points.get(i);               // Current point being checked
        if (dist(mouseX, mouseY, point.x, point.y) < 5) {      // Is the mouse within 5 pixels?
          removed = true;

          if (s.points.size() > 1) {
            p1 = new ArrayList<Vec2>(s.points.subList(0, i));  // Set left surface
          }

          if (i < s.points.size()-2) {
            p2 = new ArrayList<Vec2>(s.points.subList(i+1, s.points.size()-1));  // Set right surface
          }

          break;
        }
      }

      if (removed) {
        s.killBody();        // Remove the current surface from the box2d world
        surfaces.remove(s);  // Also remove it from the list

        if (p1.size() > 1) {
          surfaces.add(new Surface(p1));  // Add the left surface
        }

        if (p2.size() > 1) {
          surfaces.add(new Surface(p2));  // Add the right surface
        }
      }
    }
  }
}


void mousePressed() {
  if (mouseX > width-100 && mouseX < width-10 && mouseY > 140 && mouseY < 240) {
    // Draw Surfaces (Barriers)
    mode = 0;
  }  
  if (mouseX > width-100 && mouseX < width-10 && mouseY > 10 && mouseY < 110) {
    // Erase
    mode = 1;
  } else if (mode == 0) {
    // Enter drawing mode
    drawBarrier = true;
  }
}

void mouseReleased() {
  if (mode == 0) {
    // Add the new surface
    if (pre.size() > 1) {
      surfaces.add(new Surface(pre));
    }

    // Leave drawing mode and reset variables
    drawBarrier = false;
    pre = new ArrayList<Vec2>();
    previous = new Vec2(0, 0);
  }
}