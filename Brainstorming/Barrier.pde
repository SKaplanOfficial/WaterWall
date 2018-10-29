class Barrier {
  Vec3D loc;
  color c;

  Barrier(float x_, float y_) {
    loc = new Vec3D(x_, y_, 0);
    c = color(100);
  }

  void run() {
    display();
  }

  void display() {
    strokeWeight(20);
    
    float waterLevel = wB.getWaterLevel();
    
    if (height-waterLevel < loc.y){
      stroke(red(c)/2, green(c)/2, blue(c)/2);
    }else{
      stroke(c);
    }
    point(loc.x, loc.y);
  }
}