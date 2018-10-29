class Particle {
  // Global Variables

  boolean reachedBarrier = false;
  float opacity = 255;

  Vec3D loc = new Vec3D(0, 0, 0);
  Vec3D speed = new Vec3D(random(-1, 1)*5, 0, 0);
  Vec3D acc = new Vec3D();
  Vec3D grav = new Vec3D(0, 5, 0);

  color c;

  // Constructor
  Particle(float x_, float y_) {
    loc = new Vec3D(x_, y_, 0);
    c = color(0, 100, 150+frameCount%55);
  }

  // Functions
  void run() {
    move();
    bounce();
    gravity();
    flock();
    display();
  }

  Vec3D getPosition() {
    return loc;
  }

  void flock() {
    checkBarriers(speed.magnitude()*20);
    separate(speed.magnitude()*20);
  }

  void checkBarriers(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<barriers.size(); i++) {
      Barrier other = barriers.get(i);

      float distance = loc.distanceTo(other.loc);

      if (distance > 0 && distance < 15) {
        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/distance);

        steer.addSelf(diff);
        count++;
      }
    }

    if (count > 0) {
      steer.scaleSelf(1.0/count);
      reachedBarrier = true;
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }

  void separate(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<particles.size(); i++) {
      Particle other = particles.get(i);

      float distance = loc.distanceTo(other.loc);

      if (reachedBarrier && other.reachedBarrier && distance > 0 && distance < 0.4) {
        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/distance);

        steer.addSelf(diff);
        count++;
      }
    }

    if (count > 0) {
      steer.scaleSelf(1.0/count);
      speed.scaleSelf(0.9/count);
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }

  void gravity() {
    speed.addSelf(grav);
  }

  void bounce() {
    if (loc.x > width || loc.x < 0) {
      // speed.x *= -1;
      //loc.x = width-loc.x;
      particles.remove(this);
    }

    if (loc.y > height || loc.y < 0) {
      //  speed.y *= -1;
      //loc.y = height-loc.y;
      particles.remove(this);
    }
  }

  void move() {
    speed.addSelf(acc);
    speed.limit(2);
    loc.addSelf(speed);

    acc.clear();
  }

  void display() {
    //if (reachedBarrier != true) {
    opacity *= 0.999;
    //}
    strokeWeight(5);
    stroke(c, opacity);
    point(loc.x, loc.y);
  }
}
