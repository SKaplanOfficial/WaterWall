//*****************************//
//      BUBBLE DEFINITION      //
//*****************************//

class Bubble {
  float size, sizeStorage;                          // Random size, max size based on size
  float opacity = 10;                               // Initial opacity
 
  Vec3D loc = new Vec3D(0, 0, 0);                   // Location        
  Vec3D speed = new Vec3D(random(-.1, .1), 0, 0);   // Random horizontal speed
  Vec3D acc = new Vec3D();                          // Acceleration
  Vec3D grav = new Vec3D(0, -0.02, 0);              // Negative acceleration

  Bubble (float x_, float y_) {
    loc = new Vec3D(x_, y_, 0);
    size = random(1, 5);
    sizeStorage = size;
  }


  void render() {
    update();
    gravity();
    move();
    display();
  }


  void update() {
    // Increase size as time increases
    if (size < sizeStorage*3) {
      size *= 1.1;
    }

    // Decrease opacity as the bubble gets closer to the water's surface
    float d = dist(0, loc.y, 0, height-wB.getWaterLevel()+10);
    opacity = map(d, 0, height/2, 0, 10);

    // Remove the bubble when it reaches the surface
    if (loc.y < height-wB.getWaterLevel()+10) {
      bubbles.remove(this);
    }
  }


  void gravity() {
    // Accelerate upward
    speed.addSelf(grav);
  }


  void move() {
    // Move upward
    speed.addSelf(acc);
    loc.addSelf(speed);
    acc.clear();
  }


  void display() {
    // Show bubble with high border opacity and low fill opacity
    strokeWeight(2);
    stroke(0, 200, 255, opacity*5);
    fill(0, 200, 255, opacity);
    ellipse(loc.x, loc.y, size, size);
  }
}


//*****************************//
//  DUST PARTICLE DEFINITION   //
//*****************************//

class DustParticle {
  float x, y, z;
  float yorigin;

  DustParticle(float x_, float y_) {
    x = x_;
    y = y_;

    yorigin = y;
  }


  void render() {
    display();
  }


  void display() {
    // Multiple points create "blur"/"glowing" effect -> Could be implemented better
    stroke(255, 2);
    strokeWeight(14);
    point(x, y, z);

    stroke(255, 4);
    strokeWeight(8);
    point(x, y, z);

    stroke(255, 8);
    strokeWeight(3);
    point(x, y, z);

    stroke(255, 16);
    strokeWeight(2);
    point(x, y, z);

    stroke(255, 32);
    strokeWeight(1);
    point(x, y, z);

    stroke(255, 64);
    strokeWeight(0.5);
    point(x, y, z);
  }
}