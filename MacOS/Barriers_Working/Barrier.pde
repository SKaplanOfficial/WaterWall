class Barrier {
  Vec3D loc;
  color c;

  Barrier(float x_, float y_) {
    loc = new Vec3D(x_, y_, 0);
    c = color(80, random(100,150), 10, 50);
  }

  void run() {
    display();
  }

  void display() {
    strokeWeight(20);
    
    float waterLevel = wB.getWaterLevel();
    
    if (height-waterLevel < loc.y){
      stroke(color(100, 60, 10, 50));
    }else{
      stroke(c);
    }
    point(loc.x, loc.y);
  }
}