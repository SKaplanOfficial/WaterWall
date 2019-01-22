//*****************************//
//  WATER PARTICLE DEFINITION  //
//*****************************//

class Particle {
  Body body;              // Physical collision mask
  float r;                // Radius

  Particle(float x, float y, float r_) {
    // POST: Particle initialized with radius r_, position (x, y)
    r = r_;
    makeBody(x, y, r);    // Establish the particle as an object of the Box2D world
  }


  void killBody() {
    // POST: Removes particle body from Box2D world, collisions no longer detected for this object
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    //translate(pos.x, pos.y);
    //rotate(-a);
    //noStroke();
    noFill();
    // strokeWeight(r*2);
    //ellipse(0,0,r*2,r*2);
    // Let's add a line so we can see the rotation

    stroke(20, 80, 240, 10);

    for (Particle p : particles) {
      Vec2 pos2 = box2d.getBodyPixelCoord(p.body);

      float velMag = abs(body.getLinearVelocity().x) + abs(body.getLinearVelocity().y);
      float dist = dist(pos.x, pos.y, pos2.x, pos2.y);

      strokeWeight(r*2);
      if (!p.equals(this)  && (velMag > 5 && dist < velMag && dist > r*2) && pos.y < pos2.y) {
        stroke(20, 80, 240, 100);
        curve((pos.x+pos2.x)/2, (pos.y+pos2.y)/2, pos.x, pos.y, pos2.x, pos2.y, (pos.x+pos2.x)/2, (pos.y+pos2.y)/2);
      } else if (velMag <= 5 && dist <= r*2) {
        stroke(20, 80, 240, 100);
        curve((pos.x+pos2.x)/2, (pos.y+pos2.y)/2, pos.x, pos.y, pos2.x, pos2.y, (pos.x+pos2.x)/2, (pos.y+pos2.y)/2);
      } else {
        stroke(20, 80, 240, 100);
        strokeWeight(r*4);
      }
    }

    point(pos.x, pos.y);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    body.setLinearVelocity(new Vec2(random(-0.01f, 0.01f), random(1f, 2f)));
    body.setAngularVelocity(random(-10, 10));
  }
}