class Blob {
  Vec3D loc = new Vec3D(0, 0, 0);
  Vec3D speed = new Vec3D(random(-1, 1)/10, 0, 0);
  Vec3D acc = new Vec3D();
  Vec3D grav = new Vec3D(0, 0.05, 0);

  color c;
  float opacity;
  boolean reachedBarrier =false;

  Blob (float x_, float y_, float z_) {
    loc = new Vec3D(x_, y_, z_);
    speed = new Vec3D(random(-1, 1), 0, 0);
    acc = new Vec3D();
    grav = new Vec3D(0, -1*random(5,7), 0);

    c = color(20, 100, 150+frameCount%155);
    opacity = 255;
  }

  void run() {
    update();
    move();
    bounce();
    gravity();

    //checkBarriers(100);
    //separate(0.2);

    display();
  }

  void bounce() {
    //if (loc.x > width || loc.x < 0) {
      // speed.x *= -1;
      //loc.x = width-loc.x;
      //blobs.remove(this);
    //}

    if (loc.y > height*4.5 || loc.y < -height*4.5) {
      //  speed.y *= -1;
      //loc.y = height-loc.y;
      speed.y = 0;
      loc.y = -height*4.5+1;
      //blobs.remove(this);
    }
  }


  void gravity() {
    speed.addSelf(grav);
  }

  void checkBarriers(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<barriers.size(); i++) {
      Barrier other = barriers.get(i);

      float distance = dist(loc.x*1.5, loc.y*1.5, other.loc.x, other.loc.y);

      if (distance > 0 && distance <= 200) {
        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/distance);

        steer.addSelf(diff);
        count++;
      }
    }

    if (count > 0) {
      steer.scaleSelf(1.0/count);
      speed.clear();
      reachedBarrier = true;
    }

    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }

  void separate(float magnitude) {

    Vec3D steer = new Vec3D();
    int count = 0;

    for (int i=0; i<blobs.size(); i++) {
      Blob other = blobs.get(i);

      float distance = loc.distanceTo(other.loc);

      if (reachedBarrier && other.reachedBarrier && distance > 0 && distance < 8) {
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

  void move() {
    speed.addSelf(acc);
    //speed.limit(2);
    loc.addSelf(speed);

    acc.clear();
  }

  void update() {
    //opacity *= 0.99;

    if (blobs.size() > limit && opacity < 2) {
      blobs.remove(this);
    } else if (blobs.size() < limit && opacity < 2) {
      opacity *= 0.8;
    }
  }

  void display() {
    strokeWeight(5-loc.z/700.0);
    stroke(loc.z/50.0, green(c), blue(c), opacity);

    point(loc.x, loc.y, loc.z);
  }
}