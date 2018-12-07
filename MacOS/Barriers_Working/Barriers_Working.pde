//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

import toxi.geom.*;                   // Library for Vec3D - https://bitbucket.org/postspectacular/toxiclibs/downloads/

import ch.bildspur.postfx.builder.*;  // Library for filters - https://github.com/cansik/processing-postfx/
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;


int scene = 0;            // 0=Start screen, 1=Waterfall


int maxParticles = 1500;  // More particles -> Higher water level
float startX = 100;       // Start position for water particles
float startY = 0;
WaterBox wB;              // Water level/waves object


PostFX fx;                // Filters


// Shape detection - Three points -> Triangle barrier
float x1 = -1;            // mouseX of first point clicked        
float x2 = -1;            // mouseX of second point released
float x3 = -1;            // mouseX of third point clicked 

float y1 = -1;            // mouseX of first point clicked 
float y2 = -1;            // mouseX of second point released
float y3 = -1;            // mouseX of third point clicked 


float nX = 0.1;
float nY = 0;

int timer = -1;           // Time to listen for third point
int posToRemove = -1;     // Normal barrier objects to remove after shape is formed


// Object collections
ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<Barrier> barriers = new ArrayList<Barrier>();
ArrayList<Shape> shapes = new ArrayList<Shape>();
ArrayList<Animal> animals = new ArrayList<Animal>();
ArrayList<Plant> plants = new ArrayList<Plant>();
ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
ArrayList<Food> food = new ArrayList<Food>();
ArrayList<DustParticle> dustParticles = new ArrayList<DustParticle>();

ArrayList<PImage> images = new ArrayList<PImage>();



//*****************************//
//            SETUP            //
//*****************************//

void setup() {
  // P3D is most capable renderer
  //size(1024, 768, P3D);
  fullScreen(P3D);

  // Initialize PostFX for use in start screen
  fx = new PostFX(this);

  // Load images to use for fish
  images.add(loadImage("yellowFish.png"));
  images.add(loadImage("blueFish.png"));
  images.add(loadImage("niceFish.png"));
  images.add(loadImage("detailedFish.png"));
}



//*****************************//
//            DRAW             //
//*****************************//

void draw() {
  // Show active scene
  switch (scene) {
  case 0:
    showStartScreen();
    break;
  case 1:
    showWaterfall();
    break;
  }
  
  
  // Move point that above-water plants react to
  nX += random(0.1);
  nY += random(0.05);
}