import toxi.geom.*;

ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<Barrier> barriers = new ArrayList<Barrier>();

int maxParticles = 2000;

float startX, startY;

void setup() {
  size(200, 200);

  startX = width/2;
  startY = 0;
}

void draw() {
  loadPixels();
  background(255);

  if (particles.size() < maxParticles) {
    particles.add(new Particle(random(width), startY));
  }

  for (int i=0; i<particles.size(); i++) {
    particles.get(i).run();
  }

  for (int i=0; i<barriers.size(); i++) {
    barriers.get(i).run();
  }

  if (mousePressed) {
    if (mouseButton == LEFT) {
      boolean found = false;

      for (int i=0; i<barriers.size(); i++) {
        if (dist(mouseX, mouseY, barriers.get(i).loc.x, barriers.get(i).loc.y) < 0.01) {
          found = true;
        }
      }

      if (!found) {
        barriers.add(new Barrier(mouseX, mouseY));
      }
    }else{
      for (int i=0; i<barriers.size(); i++) {
        if (dist(mouseX, mouseY, barriers.get(i).loc.x, barriers.get(i).loc.y) < 5) {
          barriers.remove(i);
        }
      }
    }
  }
}