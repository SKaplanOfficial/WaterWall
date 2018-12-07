//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

import shiffman.box2d.*;              // Physics library - https://github.com/shiffman/Box2D-for-Processing
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.*;


int mode = 0;

ArrayList<Vec2> pre = new ArrayList<Vec2>();
ArrayList<Surface> surfaces = new ArrayList<Surface>();
//ArrayList<Fish> fishes = new ArrayList<Fish>();
ArrayList<PImage> images = new ArrayList<PImage>();

// A reference to our box2d world
Box2DProcessing box2d;

boolean drawBarrier = false;
Vec2 previous = new Vec2(0, 0);

// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;

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
  // We are setting a custom gravity
  box2d.setGravity(0, -20);

  // Create the empty list
  particles = new ArrayList<Particle>();


  //fishes.add(new Fish(new Vec2(width/2, height/2)));
}

void draw() {
  if (frameRate > 35) {
    float sz = random(2, 4);
    particles.add(new Particle(width/2, 0, sz));
  }

  // We must always step through time!
  box2d.step();


  background(200);


  for (int i=0; i<surfaces.size(); i++) {
    // Draw the surface
    surfaces.get(i).display();
  }

  // Draw all particles
  for (Particle p : particles) {
    p.display();
  }

  //for (Fish f : fishes) {
  //  f.display();
  //}


  beginShape();
  noFill();
  stroke(0, 50);
  strokeWeight(5);
  for (Vec2 v : pre) {
    vertex(v.x, v.y);
  }
  endShape();

  // Particles that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    if (p.done()) {
      particles.remove(i);
    }
  }


  if (drawBarrier) {
    Vec2 newVec = new Vec2(mouseX, mouseY);
    if (dist(newVec.x, newVec.y, previous.x, previous.y) > 0.2 && dist(newVec.x, newVec.y, previous.x, previous.y) < 100 || previous.x == 0) {
      pre.add(new Vec2(newVec));
      previous = newVec;
    }
  }

  // Just drawing the framerate to see how many particles it can handle
  fill(0);
  text("framerate: " + (int)frameRate, 12, 16);


  fill(255);
  rect(width-110, 10, 100, 100);

  fill(0);
  rect(width-110, 140, 100, 100);


  if (mousePressed) {
    if (mode == 1) {
      for (int o=0; o<surfaces.size(); o++) {
        Surface s = surfaces.get(o);
        boolean removed = false;
        ArrayList<Vec2> p1 = new ArrayList<Vec2>();
        ArrayList<Vec2> p2 = new ArrayList<Vec2>();

        for (int i=0; i<s.points.size(); i++) {
          Vec2 point = s.points.get(i);
          if (dist(mouseX, mouseY, point.x, point.y) < 5) {
            removed = true;

            if (s.points.size() > 1) {
              p1 = new ArrayList<Vec2>(s.points.subList(0, i));
            }

            if (i < s.points.size()-2) {
              p2 = new ArrayList<Vec2>(s.points.subList(i+1, s.points.size()-1));
            }


            break;
          }
        }

        if (removed) {
          s.killBody();
          surfaces.remove(s);

          if (p1.size() > 1) {
            surfaces.add(new Surface(p1));
          }

          if (p2.size() > 1) {
            surfaces.add(new Surface(p2));
          }
        }
      }
    }
  }
}


void mousePressed() {
  if (mouseX > width-100 && mouseX < width-10 && mouseY > 140 && mouseY < 240) {
    mode = 0;
  }  if (mouseX > width-100 && mouseX < width-10 && mouseY > 10 && mouseY < 110) {
    mode = 1;
  } else if (mode == 0) {
    drawBarrier = true;
  }
}

void mouseReleased() {
  if (mode == 0) {
    if (pre.size() > 1) {
      surfaces.add(new Surface(pre));
    }

    drawBarrier = false;
    pre = new ArrayList<Vec2>();

    previous = new Vec2(0, 0);
  }
}