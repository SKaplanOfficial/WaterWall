//*****************************//
//      PLANT DEFINITION       //
//*****************************//

class Plant extends Lifeform {
  float maxHeight;
  float currentHeight = 1;

  Plant(float x_, float y_) {
    super(x_, y_);

    loc = new Vec3D(x_+random(-10, 10), y_-random(10, 20), 0);
    initialLoc = new Vec3D(x_, y_, 0);

    maxHeight = random(20, 200);
  }


  Plant(float x_, float y_, float maxHeight_) {
    super(x_, y_);

    loc = new Vec3D(x_, y_, 0);
    initialLoc = new Vec3D(x_, y_, 0);

    maxHeight = maxHeight_;
  }


  void bounce() {

    if (loc.x > initialLoc.x+maxHeight/5) {
      speed.x *= -1;
      loc.x = initialLoc.x+maxHeight/5-1;
    }

    if (loc.x < initialLoc.x-maxHeight/5) {
      speed.x *= -1;
      loc.x = initialLoc.x-maxHeight/5+1;
    }
  }


  void move() {
    speed.addSelf(acc);

    speed.limit(1);
    speed.y = 0;

    loc.addSelf(speed);

    acc.clear();

    if (speed.x < 0 && dir > -20) {
      dir--;
    } else if (speed.x > 0 && dir < 20) {
      dir++;
    }
  }

  void display() {
    if (currentHeight < maxHeight) {
      currentHeight *= 1.01;
    }

    strokeWeight(5);
    stroke(dist(loc.x, 0, 0, 0)/10, 255-dist(loc.x, 0, width/2, 0)/50, dist(loc.x, 0, width, 0)/10, 50);
    fill(dist(loc.x, 0, 0, 0)/10, 255-dist(loc.x, 0, width/2, 0)/50, dist(loc.x, 0, width, 0)/10, 200);
    bezier(initialLoc.x, initialLoc.y, loc.x, initialLoc.y-currentHeight, loc.x, initialLoc.y-currentHeight, initialLoc.x-1, initialLoc.y);
  }
}