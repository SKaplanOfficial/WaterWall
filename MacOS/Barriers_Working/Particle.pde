//*****************************//
//  WATER PARTICLE DEFINITION  //
//*****************************//

class Particle {
  boolean reachedBarrier = false;                    // Whether this particle is touching a barrier or not
  float opacity = 255;                               // Opacity (decreases over time)

  Vec3D loc = new Vec3D(0, 0, 0);                    // Location
  Vec3D speed = new Vec3D(random(-1, 1)/10, 0, 0);   // Velocity
  Vec3D acc = new Vec3D();                           // Acceleration
  Vec3D grav = new Vec3D(0, 0.2, 0);                 // Gravity

  color c;                                           // Color
  color cStorage;                                    // Color storage (to compare to changing color over time)

  Particle(float x_, float y_) {
    loc = new Vec3D(x_, y_, 0);
    c = color(0, 100, 170+random(55));
    cStorage = c;
  }


  void run() {
    move();
    bounce();
    gravity();
    flock();
    display();
  }


  Vec3D getPosition() {
    // Return Vec3D location
    return loc;
  }


  void flock() {
    separate((8-speed.y)*5);
    checkBarriers(speed.magnitude()*1000);

    if (acc.x > 0) {
      acc.x = random(0.2, 1);
    } else if (acc.x < 0) {
      acc.x = -random(0.2, 1);
    }
  }

  void checkBarriers(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<barriers.size(); i++) {
      Barrier other = barriers.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 20) {
        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/distance);

        steer.addSelf(diff);
        count++;

        other.resetPlants();
      } else if (distance < 200) {
        other.plantChance += 0.0001;
      }
    }

    if (count > 0) {
      steer.scaleSelf(1.0/count);
      reachedBarrier = true;
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }

  void gravity() {
    speed.addSelf(grav);
    speed.x *= 0.2;
  }

  void separate(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<particles.size(); i++) {
      Particle other = particles.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 8) {
        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/distance);

        steer.addSelf(diff);
        count++;
      }
    }

    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }

  void bounce() {
    if (loc.x > width || loc.x < 0) {
      particles.remove(this);
    }

    if (loc.y > height-wB.getWaterLevel()+10) {
      if (wB.getWaterLevel() < height/2) {
        wB.increaseLevel(0.2);
      }
      particles.remove(this);
    }
  }

  void move() {
    speed.addSelf(acc);
    if (abs(speed.y) > 0) {
      speed.y = constrain(speed.y, 0, 3);
    }
    
    speed.limit(3);
    
    loc.addSelf(speed);

    acc.clear();
  }

  Vec3D getLoc() {
    return loc;
  }

  void display() {
    if (abs(speed.x) > 0.1) {
      c = color(red(c), green(c), blue(c)+abs(speed.x));
    } else if (blue(c) > blue(cStorage)) {
      c = color(red(c), green(c), blue(c)/1.01);
    }

    opacity *= 0.999;

    if (opacity < 2) {
      particles.remove(this);
    }

    strokeWeight(5+speed.y);
    stroke(c, opacity);
    point(loc.x, loc.y);
  }
}