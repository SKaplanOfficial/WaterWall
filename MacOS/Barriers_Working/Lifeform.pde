//*****************************//
//  MOVING OBJECT DEFINITION   //
//*****************************//

abstract class Lifeform {
  float x, y;

  Vec3D loc = new Vec3D(0, 0, 0);
  Vec3D initialLoc = new Vec3D(0, 0, 0);
  Vec3D speed = new Vec3D(0, random(-1, 1), 0);
  Vec3D acc = new Vec3D();
  Vec3D grav = new Vec3D(0, 0.2, 0);

  float dir;

  Lifeform(float x_, float y_) {
    loc = new Vec3D(x_, y_, 0);
    initialLoc = new Vec3D(x_, y_, 0);
  }

  // Functions
  void render() {
    move();
    bounce();
    flock();
    display();
  }

  void flock() {
    separate(5);
    cohesion(0.001);
    align(0.1);
  }

  void align(float magnitude) {
    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<animals.size(); i++) {
      Animal other = (Animal) animals.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 40) {
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

  void cohesion(float magnitude) {
    Vec3D sum = new Vec3D();
    int count = 0;

    for (int i=0; i<animals.size(); i++) {
      Animal other = (Animal) animals.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 60) {
        sum.addSelf(other.loc);
        count++;
      }
    }

    if (count > 0) {
      sum.scaleSelf(1.0/count);
    }

    if (count > 0) {
      Vec3D steer = sum.sub(loc);
      steer.scaleSelf(magnitude);

      acc.addSelf(steer);
    } else {
      speed.scaleSelf(0.99);
    }
  }

  void separate(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<animals.size(); i++) {
      Animal other = (Animal) animals.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 30) {
        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/distance);

        steer.addSelf(diff);
        count++;
      }
    }

    Vec3D mouseLoc = new Vec3D(mouseX, mouseY, 0);
    float distance = loc.distanceTo(mouseLoc);

    if (distance > 0 && distance < 100) {
      Vec3D diff = loc.sub(mouseLoc);
      //diff.normalizeTo(1.0/distance);

      steer.addSelf(diff);
      count++;
    }



    Vec3D noiseLoc = new Vec3D(noise(nX)*width, noise(nY)*height/2, 0);
    distance = loc.distanceTo(noiseLoc);

    if (distance > 0 && distance < 300) {
      Vec3D diff = loc.sub(noiseLoc);
      steer.addSelf(diff);
      count++;
    }
    

    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }

  void lineBetween() {
    for (int i=0; i<animals.size(); i++) {
      Animal other = (Animal) animals.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 50) {
        stroke(dist(loc.x, 0, 0, 0)/4, dist(loc.x, 0, width, 0)/4, 255-dist(loc.x, 0, width/2, 0)/4, 100);
        strokeWeight(0.4);
        line(loc.x, loc.y, other.loc.x, other.loc.y);
      }
    }
  }

  void gravity() {
    speed.addSelf(grav);
  }

  void bounce() {
    // To be implemented by child classes
  }

  void move() {
    speed.addSelf(acc);

    speed.limit(1);

    loc.addSelf(speed);

    acc.clear();

    if (speed.x < 0 && dir > -20) {
      dir--;
    } else if (speed.x > 0 && dir < 20) {
      dir++;
    }
  }

  void display() {
    // Stuff
  }
}