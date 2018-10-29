import toxi.geom.*;

ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<Barrier> barriers = new ArrayList<Barrier>();

int maxParticles = 2000;

float startX, startY;

WaterBox wB;

void setup() {
  size(1024, 768, P2D);

  startX = width/2;
  startY = 0;

  wB = new WaterBox();
}

void draw() {
  noStroke();
  beginShape(POLYGON);
  fill(color(200+cos(frameCount/100.0)*55));
  vertex(0, 0);
  fill(color(200+sin(frameCount/100.0)*55));
  vertex(width, 0);
  fill(color(200-cos(frameCount/100.0)*55));
  vertex(width, height);
  fill(color(200-sin(frameCount/50.0)*55));
  vertex(0, height);
  endShape(CLOSE);

  if (particles.size() < maxParticles) {
    particles.add(new Particle(startX, startY));
  }

  for (int i=0; i<particles.size(); i++) {
    particles.get(i).run();
  }

  wB.display();

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
    } else {
      for (int i=0; i<barriers.size(); i++) {
        if (dist(mouseX, mouseY, barriers.get(i).loc.x, barriers.get(i).loc.y) < 5) {
          barriers.remove(i);
        }
      }
    }
  }
}