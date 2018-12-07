//*****************************//
//      ANIMAL DEFINITION      //
//*****************************//

class Animal extends Lifeform {
  PImage image;        // Image to use for this image
  float size;         // Size of image increases when food is consumed
  float opacity = 1;  // Opacity of image

  Animal(float x_, float y_) {
    super(x_, y_);                                     // Establish base moving functionality
    size = random(20, 50);                             // Each image has marginally different size
    image = images.get(int(random(0, images.size())));  // Randomly select image
  }
  

  void bounce() {
    // Bounce off of water boundaries
    if (loc.x > width-size) {                          // RIGHT BOUNDARY
      speed.x *= -1;
      acc.x *= -5;
      loc.x = width-size-1;
    }

    if (loc.x < size) {                                // LEFT BOUNDARY
      speed.x *= -1;
      acc.x *= -5;
      loc.x = size+1;
    }

    if (loc.y > height-size) {                         // BOTTOM BOUNDARY
      speed.y *= -5;
      acc.y *= -5;
      loc.y = height-size-1;
    }

    if (loc.y < height-wB.getWaterLevel()+20+size) {   // TOP BOUNDARY - based on water level
      speed.y *= -50;
      acc.y *= -5;
      loc.y = height-wB.getWaterLevel()+21+size;
    }
  }


  void separate(float magnitude) {
    // Maintain distance from other animals and mouse
    Vec3D steer = new Vec3D();
    int count = 0;

    // Other animals
    for (int i=0; i<animals.size(); i++) {
      Animal other = (Animal) animals.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < size) {
        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/distance);

        steer.addSelf(diff);
        count++;
      }
    }


    // Mouse
    Vec3D mouseLoc = new Vec3D(mouseX, mouseY, 0);
    float distance = loc.distanceTo(mouseLoc);

    if (distance > 0 && distance < size*3) {
      Vec3D diff = loc.sub(mouseLoc);

      steer.addSelf(diff);
      count++;
    }


    // Normalize direction
    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }


    // Set movement
    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }


  void align(float magnitude) {
    // Set speed similar to neighbors of similar image type
    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<animals.size(); i++) {
      Animal other = (Animal) animals.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 40 && other.image.equals(image)) {
        steer.addSelf(other.speed);
        count++;
      }
    }

    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }


  // Stay near neighbors of similar image type
  void cohesion(float magnitude) {
    Vec3D sum = new Vec3D();
    int count = 0;

    for (int i=0; i<animals.size(); i++) {
      Animal other = (Animal) animals.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 60 && other.image.equals(image)) {
        sum.addSelf(other.loc);
        count++;
      }
    }

    if (count > 0) {
      sum.scaleSelf(1.0/count);
    }

    Vec3D steer = sum.sub(loc);
    steer.scaleSelf(magnitude);

    acc.addSelf(steer);
  }


  void display() {
    // Increase size when food is in range, remove food object
    for (int i=0; i<food.size(); i++) {
      Vec3D fLoc = food.get(i).loc;

      if (fLoc.x > loc.x-size/2 && fLoc.x < loc.x+size/2 && fLoc.y > loc.y-size/2 && fLoc.y < loc.y+size/2) {
        food.remove(i);
        size += 0.5;
      }
    }

    pushStyle();
    tint(255, opacity);

    if (opacity < 255) {
      opacity *= 1.1;
    }


    // Show image with increasing opacity, flipped according to movement diretion
    if (dir < 0) {
      image(image, loc.x-size/2, loc.y-size/2, size, size/2);
    } else {
      pushMatrix();
      scale(-1, 1);
      image(image, -loc.x+size/2, loc.y-size/2, -size, size/2);
      popMatrix();
    }
    popStyle();
  }
}



//*****************************//
//       FOOD DEFINITION       //
//*****************************//

class Food {
  Vec3D loc;

  Food(float x, float y) {
    loc = new Vec3D(x, y, 0);
  }

  void render() {
    display();
    update();
  }

  void update() {
    if (loc.y < height-3) {          // Fall slowly
      loc.y *= 1.0008;
    } else if (loc.y > height-3) {   // Stick to bottom
      loc.y = height-3;
    }

    loc.x += random(-1, 1);          // Jitter
  }


  void display() {
    strokeWeight(4);
    stroke(134, 124, 10, 100);
    point(loc.x, loc.y);             // Center

    strokeWeight(6);
    stroke(134, 124, 10, 50);
    point(loc.x, loc.y);             // "Blur"
  }
}