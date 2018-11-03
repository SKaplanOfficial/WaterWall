// Library for Vec3D - https://bitbucket.org/postspectacular/toxiclibs/downloads/
import toxi.geom.*;


// More particles -> Higher water level
int maxParticles = 1500;

// Start position for particles (see setup())
float startX, startY;


// Shape detection
float x1 = -1;
float x2 = -1;
float x3 = -1;

float y1 = -1;
float y2 = -1;
float y3 = -1;

int timer = -1;
int posToRemove = -1;


// Water level/waves object
WaterBox wB;


// Object collections
ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<Barrier> barriers = new ArrayList<Barrier>();
ArrayList<Shape> shapes = new ArrayList<Shape>();


void setup() {
  // P3D is most capable renderer
  //size(1024, 768, P3D);
  fullScreen(P3D);

  // Position of particles when initialized
  startX = width/2;
  startY = 0;

  wB = new WaterBox(0, height, width, 50);
}


void draw() {
  // Gradient background changes over time, necessitates P2D or P3D render
  noStroke();
  beginShape(POLYGON);
  fill(color(cos(frameCount/500.0)*55));
  vertex(0, 0);

  fill(color(sin(frameCount/500.0)*55));
  vertex(width, 0);

  fill(color(cos(frameCount/500.0)*55));
  vertex(width, height);

  fill(color(sin(frameCount/500.0)*55));
  vertex(0, height);
  endShape(CLOSE);


  // Add one particle each frame
  if (particles.size() < maxParticles) {
    for (int i=0; i<2; i++) {
      particles.add(new Particle(startX+random(-10, 10), startY));
    }
  }


  // Update and display particles
  for (int i=0; i<particles.size(); i++) {
    particles.get(i).run();
  }

  // Update and display water box
  wB.run();

  // Update and display barriers
  for (int i=0; i<barriers.size(); i++) {
    barriers.get(i).run();
  }

  // Update and display shapes
  for (int i=0; i<shapes.size(); i++) {
    shapes.get(i).run();
  }


  // Show transparent line when use begins shape-creation interaction
  if (x2 != -1 && x3 == -1) {
    strokeWeight(10);
    stroke(0, 10);
    line(x1, y1, x2, y2);
  }

  if (x1 != -1 && x2 == -1) {
    strokeWeight(10);
    stroke(20, 100);
    line(x1, y1, mouseX, mouseY);
  }

  // Reset shape-creation interaction variables if timer ends
  if (timer == 0 && x2 != -1 && x3 == -1) {
    resetInteraction();
  }

  if (timer == 0 && y3 != -1) {
    // Add triangle when 3 points are defined and timer runs out
    shapes.add(new Shape(x1, y1, x2, y2, x3, y3));

    // Remove excess barriers
    while (barriers.size() > posToRemove) {
      barriers.remove(barriers.size()-1);
    }

    // Reset interaction variables
    resetInteraction();
  } else {
    // Later: Have fill based on proximity to water, or add material selection
    noStroke();
    fill(255, 0, 0);

    // Display triangle/rectangle preview before actually adding to shapes array
    if (y3 != -1) {
      triangle(x1, y1, x2, y2, x3, y3);
    }

    timer--;
  }


  // Continuous click detection
  if (mousePressed) {
    if (mouseButton == LEFT) {
      boolean found = false;

      for (int i=0; i<barriers.size(); i++) {
        if (dist(mouseX, mouseY, barriers.get(i).loc.x, barriers.get(i).loc.y) < 0.01) {
          found = true;
        }
      }

      // Add a barrier if it is another barrier isn't in the same location already
      if (!found) {
        barriers.add(new Barrier(mouseX, mouseY));
      }
    } else {
      // Right click - Remove nearby barrier(s)
      for (int i=0; i<barriers.size(); i++) {
        if (dist(mouseX, mouseY, barriers.get(i).loc.x, barriers.get(i).loc.y) < 5) {
          barriers.remove(i);
        }
      }
    }
  }
}



void mousePressed() {
  if (mouseButton == LEFT) {
    if (x1 == -1) {
      // Begin interaction
      posToRemove = barriers.size();
      x1 = mouseX;
      y1 = mouseY;
    } else if (x3 == -1) {
      // Third point -> Triangle
      x3 = mouseX;
      y3 = mouseY;
      timer = 100;
    }
  }
}


void mouseDragged() {
  timer = 100;
}


void mouseReleased() {
  // Second point -> Line
  if (x1 != -1 && x2 == -1) {
    x2 = mouseX;
    y2 = mouseY;
  }

  if (x1 == x2) {
    resetInteraction();
  }
}



void resetInteraction() {
  x1 = -1;
  x2 = -1;
  x3 = -1;

  y1 = -1;
  y2 = -1;
  y3 = -1;
  timer = -1;

  posToRemove = -1;
}