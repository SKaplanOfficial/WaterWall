//*****************************//
//     BARRIER DEFINITION      //
//*****************************//

class Barrier {
  Vec3D loc;                // Location
  Vec3D speed;              // Speed
  int opacity;              // Opacity of the barrier
  int wait = 3000;          // Frame to wait until barrier dissolves
  float plantChance = 0;    // Slowly building chance of having a plant if barrier is near water
  boolean hasPlant = false; // Plant possession

  Barrier(float x_, float y_) {
    loc = new Vec3D(x_, y_, 0);
    speed = new Vec3D(random(-1, 1)/5, random(-1, 1)/5, 0);  // Speed only comes into play once wait is 0
    opacity = 100;
  }


  void run() {
    update();
    display();
  }


  void resetPlants() {
    // Remove this barrier's plant from the plants array, reset plant variables
    hasPlant = false;

    for (int i=0; i<plants.size(); i++) {
      Plant p = plants.get(i);

      if (p.initialLoc.x == loc.x && (p.initialLoc.y-loc.y) <= 10) {
        plants.remove(p);
      }
    }

    plantChance = 0;
  }


  void update() {
    if (wait < 1) {
      // Reset plants and move slightly, decrease opacity once wait is 0
      resetPlants();
      loc.addSelf(speed);
      opacity *= random(0.99999996, 0.99999999);
    } else {
      wait--;
    }


    if (opacity < 1) {
      // Remove the barrier once it fades away
      barriers.remove(this);
    }


    if (((plantChance > random(10, 30)) || (abs(height-wB.getWaterLevel()-loc.y) < 30 && plantChance == 0)) && !hasPlant) {
      // Add plants if near water for long enough time
      plants.add(new Plant(loc.x, loc.y-random(10), random(20, 80)));
      hasPlant = true;
    }
  }


  void display() {
    // Multiple points create "blur"/"glowing" effect -> Might not be necessary, could be implemented better
    strokeWeight(30);
    stroke(10, opacity/5);
    point(loc.x, loc.y);

    strokeWeight(25);
    stroke(8, opacity/2);
    point(loc.x, loc.y);

    strokeWeight(15);
    stroke(6, opacity/1.5);
    point(loc.x, loc.y);

    strokeWeight(10);
    stroke(4, opacity/1.1);
    point(loc.x, loc.y);

    strokeWeight(5);
    stroke(2, opacity);
    point(loc.x, loc.y);
  }
}