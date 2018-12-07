//*****************************//
//      FISH DEFINITION        //
//*****************************//

class Fish {
  Body body;
  PImage image;        // Image to use for this fish
  Vec2 loc;
  float size;

  Fish(Vec2 loc_) {
    loc = loc_;
    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();

    size = random(20, 50);                             // Each image has marginally different size
    image = images.get(int(random(0, images.size())));  // Randomly select image

    // Build an array of vertices in Box2D coordinates
    // from the ArrayList we made
    Vec2[] vertices = new Vec2[4];
    vertices[0] = box2d.coordPixelsToWorld(new Vec2(loc.x, loc.y));
    vertices[1] = box2d.coordPixelsToWorld(new Vec2(loc.x+size, loc.y));
    vertices[2] = box2d.coordPixelsToWorld(new Vec2(loc.x+size, loc.y+size));
    vertices[3] = box2d.coordPixelsToWorld(new Vec2(loc.x, loc.y+size));

    // Create the chain!
    chain.createChain(vertices, vertices.length);

    // The edge chain is now attached to a body via a fixture
    BodyDef bd = new BodyDef();
    bd.position.set(0.0f, 0.0f);
    body = box2d.createBody(bd);
    // Shortcut, we could define a fixture if we
    // want to specify frictions, restitution, etc.
    body.createFixture(chain, 1);
  }
  
  
  void run() {
    
  }
  
  void update() {
    
  }

  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    // Show image with increasing opacity, flipped according to movement diretion
    if (dir < 0) {
      image(image, loc.x-size/2, loc.y-size/2, size, size/2);
    } else {
      pushMatrix();
      scale(-1, 1);
      image(image, -loc.x+size/2, loc.y-size/2, -size, size/2);
      popMatrix();
    }
  }
}