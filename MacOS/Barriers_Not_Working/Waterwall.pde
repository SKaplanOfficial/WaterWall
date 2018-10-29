/*
 * Stephen Kaplan 2018
 */

import SimpleOpenNI.*;
import toxi.geom.*;

SimpleOpenNI context;

float zoomF = 0.3f;
float rotX = radians(180);
float rotY = random(0);
int limit = 50000;

ArrayList<Blob> blobs = new ArrayList<Blob>();
ArrayList<Barrier> barriers = new ArrayList<Barrier>();

void setup() {
  size(1020, 768, P3D);
  //fullScreen(P3D);

  context = new SimpleOpenNI(this);

  // Exit program if Kinect cannot be found
  if (context.isInit() == false) {
    println("Unable to initialize. Kinect is not connected.");
    exit();
    return;
  }

  // Disable mirror -- Why?
  context.setMirror(false);

  // Enable depth map
  context.enableDepth();

  smooth();
}

void draw() {
  // Update camera
  context.update();

  background(12);

  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);

  translate(0, 0, -1000);

  int[] depthMap = context.depthMap();
  int step = 5; // Draw every 10th point, decrease for more detail (Also more lag)
  int scale = 10;
  int index;
  PVector loc3D;


  PVector[] realWorldMap = context.depthMapRealWorld();
  for (int y=0; y<context.depthHeight(); y+=step) {
    for (int x=0; x<context.depthWidth(); x+=step) {
      index = x+y*context.depthWidth();

      if (depthMap[index] > 0) {
        loc3D = context.depthMapRealWorld()[index];

        if (loc3D.z < 1000 && random(10)<5) {
          blobs.add(new Blob(loc3D.x*scale, loc3D.y*scale, loc3D.z*scale));
          if (blobs.size() > limit) {
            blobs.remove(0);
          }
        }
      }
    }
  }

  for (int i=0; i<blobs.size(); i++) {
    blobs.get(i).run();
  }

  popMatrix();

  for (int i=0; i<barriers.size(); i++) {
    barriers.get(i).run();
  }

  if (mousePressed) {
    if (mouseButton == LEFT) {
      boolean found = false;

      for (int i=0; i<barriers.size(); i++) {
        if (dist(mouseX, mouseY, barriers.get(i).loc.x, barriers.get(i).loc.y) < 0.01) {
          found = true;
        }
      }

      if (!found) {
        barriers.add(new Barrier(mouseX, mouseY));
      }
    } else {
      for (int i=0; i<barriers.size(); i++) {
        if (dist(mouseX, mouseY, barriers.get(i).loc.x, barriers.get(i).loc.y) < 10) {
          barriers.remove(i);
        }
      }
    }
  }
}