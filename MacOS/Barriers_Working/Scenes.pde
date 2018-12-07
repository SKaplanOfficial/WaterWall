//*****************************//
//    START SCREEN SCENE (0)   //
//*****************************//

// Start screen background line settings
// These should really be attributes of a class
ArrayList<Float> sY = new ArrayList<Float>();  // Start y-position
ArrayList<Float> eY = new ArrayList<Float>();  // End y-position
ArrayList<Float> r = new ArrayList<Float>();   // Red value
ArrayList<Float> g = new ArrayList<Float>();   // Green value
ArrayList<Float> b = new ArrayList<Float>();   // Blue value

void showStartScreen() {
  if (frameCount == 1) {
    // Populate settings on the first frame
    for (float xpos=0; xpos<width; xpos+=1.5) {
      sY.add(random(height));
      eY.add(random(height));
      r.add(20+random(40));
      g.add(80+random(50));
      b.add(200+random(50));
    }
  }


  if (frameCount < 50) {
    // Dark background
    background(0);

    // Display lines with increasing opacity as frameCount increases
    for (int i=0; i<sY.size(); i++) {
      float _x = i*1.5;
      float _y1 = sY.get(i);
      float _y2 = eY.get(i);
      float _r = r.get(i);
      float _g = g.get(i);
      float _b = b.get(i);
      float _w = 6.0;

      stroke(_r, _g, _b, (frameCount*20)/dist(_x, (_y1+_y2)/2, width/2, height/2));
      strokeWeight(_w);
      line(_x, _y1, _x, _y2);
    }

    // Title text
    textAlign(CENTER, CENTER);
    textSize(150);
    fill(255, 130);
    text("W A T E R W A L L", 0, 0, width, height);

    // Instructional text
    if (frameCount > 30) {
      textSize(30);
      fill(255, 50);
      text("Tap anywhere to begin.", 0, 300, width, height);
    }

    // Add filters
    fx.render()
      .sobel()
      .bloom(.9, 400, 100)
      .compose();
  }


  // Proceed to next scene after mouse click
  if (mousePressed) {
    // Memory management
    sY.clear();
    eY.clear();
    r.clear();
    g.clear();
    b.clear();

    // Initialize waterbox
    wB = new WaterBox(0, height, width, 0);

    // Add dust/star/background particles
    for (float x=0; x<=100; x++) {
      dustParticles.add(new DustParticle(random(width), random(height/2.5)));
    }

    // Next scene (Waterfall)
    scene = 1;
  }
}



//*****************************//
//     WATERFALL SCENE (1)     //
//*****************************//

void showWaterfall() {
  // Set background - avoid issues PostFX "residue"
  background(0);


  // Gradient background changes over time, necessitates P2D or P3D render
  noStroke();
  beginShape(POLYGON);
  fill(color(55+sin(frameCount/500.0)*55, 55+sin(frameCount/500.0)*55, 100+sin(frameCount/500.0)*55));
  vertex(0, 0);

  fill(color(55+sin(frameCount/500.0)*55, 55+sin(frameCount/500.0)*55, 100+sin(frameCount/500.0)*55));
  vertex(width, 0);

  fill(color(55+cos(frameCount/500.0)*55));
  vertex(width, height);

  fill(color(55+cos(frameCount/500.0)*55));
  vertex(0, height);
  endShape(CLOSE);


  // Add two water particles each frame - Left/Right side of screen
  if (particles.size() < maxParticles) {                              // Stop adding particles once limit is reached
    particles.add(new Particle(startX+random(-5, 5), startY));        // Left
    particles.add(new Particle(width-startX+random(-5, 5), startY));  // Right
  }

  // Update and display water particles
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


  // Two bubble columns with random offsets
  if (wB.getWaterLevel() > 10 && frameCount%int(random(1, 8)) == 0) {
    bubbles.add(new Bubble(width/2+noise(frameCount/10.0)*50, height));
  }

  if (wB.getWaterLevel() > 100 && frameCount%int(random(1, 8)) == 0) {
    bubbles.add(new Bubble(width/1.5+noise(frameCount/20.0)*50, height));
  }

  // Update and display bubbles
  for (int i=0; i<bubbles.size(); i++) {
    bubbles.get(i).render();
  }


  // Update and display dust/star/background particles
  for (int i=0; i<dustParticles.size(); i++) {
    dustParticles.get(i).render();
  }


  // Update and display food
  for (int i=0; i<food.size(); i++) {
    food.get(i).render();
  }


  // Add animals randomly once the water level is high enough
  if (wB.getWaterLevel() >= height/4 && animals.size() < 30) {
    if (random(10) > 8) {
      animals.add(new Animal(random(width), height-random(wB.getWaterLevel())));
    }
  }

  // Update and display animals
  for (int i=0; i<animals.size(); i++) {
    animals.get(i).render();
  }


  // Update and display plants
  for (int i=0; i<plants.size(); i++) {
    plants.get(i).render();
  }

  // Add plants randomly once the water level is high enough
  if (wB.getWaterLevel() >= height/4 && plants.size() < 300) {
    plants.add(new Plant(random(width), height));
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
      barriers.get(barriers.size()-1).resetPlants();
      barriers.remove(barriers.size()-1);
    }

    // Reset interaction variables
    resetInteraction();
  } else {
    // Later: Have fill based on proximity to water, or add material selection
    noStroke();
    fill(0, 50);

    // Display triangle/rectangle preview before actually adding to shapes array
    if (y3 != -1) {
      triangle(x1, y1, x2, y2, x3, y3);
    }

    timer--;
  }


  // Continuous click detection
  if (mousePressed && mouseY < height-wB.getWaterLevel()) {
    if (mouseButton == LEFT) {
      boolean found = false;

      for (int i=0; i<barriers.size(); i++) {
        if (dist(mouseX, mouseY, barriers.get(i).loc.x, barriers.get(i).loc.y) < 0.01) {
          found = true;
        }
      }

      // Add a barrier if it is another barrier isn't in the same location already
      if (!found && particles.size() > 0) {
        barriers.add(new Barrier(mouseX, mouseY));
      }
    } else {
      // Right click - Remove nearby barrier(s)
      for (int i=0; i<barriers.size(); i++) {
        if (dist(mouseX, mouseY, barriers.get(i).loc.x, barriers.get(i).loc.y) < 5) {
          barriers.get(i).resetPlants();
          barriers.remove(i);
        }
      }
    }
  }
}