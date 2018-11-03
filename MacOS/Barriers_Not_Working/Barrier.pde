class Barrier {
  Vec3D loc;
  color c;

  Barrier(float x_, float y_) {
    loc = new Vec3D(x_, y_, 0);
    c = color(0);
  }

  void run() {
    display();
  }

  void display() {
    strokeWeight(10);
    stroke(c);
    point(loc.x, loc.y);
  }
}