// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// An uneven surface boundary

class Surface {
  // We'll keep track of all of the surface points
  ArrayList<Vec2> points;
  ArrayList<Float> chance;
  Body body;

  Surface(ArrayList<Vec2> s) {
    points = s;
    chance = new ArrayList<Float>(points.size());

    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();

    // Build an array of vertices in Box2D coordinates
    // from the ArrayList we made
    Vec2[] vertices = new Vec2[points.size()];
    for (int i = 0; i < vertices.length; i++) {
      Vec2 edge = box2d.coordPixelsToWorld(points.get(i));
      vertices[i] = edge;

      chance.add(0.0);
    }

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

  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    strokeWeight(5);
    noFill();

    beginShape();
    for (Vec2 v : points) {

      int index = points.indexOf(v);

      for (int i=0; i<particles.size(); i++) {
        Vec2 particleLoc = box2d.getBodyPixelCoord(particles.get(i).body);

        float dist = dist(v.x, v.y, particleLoc.x, particleLoc.y);

        float current = chance.get(index);
        if (dist < 8) {
          chance.set(index, current+1);
        } else {
          chance.set(index, current-1/(dist*3+1));
        }
      }

      if (chance.get(index) > 10) {
        stroke(180, 60, 30, 200);
      } else {
        stroke(50, 200);
      }

      vertex(v.x, v.y);
    }
    endShape();
  }
}