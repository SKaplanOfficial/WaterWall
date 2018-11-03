class Shape {
  PShape shape;

  float minX, minY;
  float maxX, maxY;

  float cX;
  
  color c;

  float xpos1, xpos2, xpos3, xpos4;
  float ypos1, ypos2, ypos3, ypos4;

  float area;

  int type;

  // TRIANGLE
  Shape(float x1, float y1, float x2, float y2, float x3, float y3) {
    c = color(random(255), random(255), random(255));
    shape = createShape(TRIANGLE, x1, y1, x2, y2, x3, y3);

    xpos1 = x1;
    xpos2 = x2;
    xpos3 = x3;

    ypos1 = y1;
    ypos2 = y2;
    ypos3 = y3;

    cX = max(y1, y2);
    cX = max(cX, y2);
    
    minY = min(y1, y2);
    minY = min(minY, y3);
    
    if (cX == y1) {
      cX = x1;
    } else if (cX == y2) {
      cX = x2;
    } else if (cX == y3) {
      cX = x3;
    }

    area = triangleArea(xpos1, ypos1, xpos2, ypos2, xpos3, ypos3);

    type = 1;
  }

  void run() {
    checkCollisions();
    display();
  }

  void checkCollisions() {
    if (mousePressed && mouseButton == RIGHT) {
      if (type == 1) {
        float area1 = triangleArea(mouseX, mouseY, xpos1, ypos1, xpos2, ypos2);
        float area2 = triangleArea(mouseX, mouseY, xpos2, ypos2, xpos3, ypos3);
        float area3 = triangleArea(mouseX, mouseY, xpos3, ypos3, xpos1, ypos1);

        if (area1 + area2 + area3 == area) {
          shapes.remove(this);
        }
      } else if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY) {
        shapes.remove(this);
      }
    }

    if (type == 1) {
      for (int i=0; i<particles.size(); i++) {
        Particle other = particles.get(i);
        Vec3D loc = other.loc;

        float area1 = triangleArea(loc.x, loc.y, xpos1, ypos1, xpos2, ypos2);
        float area2 = triangleArea(loc.x, loc.y, xpos2, ypos2, xpos3, ypos3);
        float area3 = triangleArea(loc.x, loc.y, xpos3, ypos3, xpos1, ypos1);

        float area4 = triangleArea(loc.x+4, loc.y, xpos1, ypos1, xpos2, ypos2);
        float area5 = triangleArea(loc.x+4, loc.y, xpos2, ypos2, xpos3, ypos3);
        float area6 = triangleArea(loc.x+4, loc.y, xpos3, ypos3, xpos1, ypos1);

        if (abs((area1 + area2 + area3)-area) < 20) {
          if (abs((area4 + area5 + area6)-area) > 0.1) {
            other.speed.x += 4;
          } else {
            other.speed.x -= 4;
          }

          other.speed.y *= -1;
          loc.y -= 5;
        }
      }
    }
  }

  void display() {
    shape.setFill(color(c, 100));
    shape.setStroke(color(c, 50));
    strokeWeight(10);
    shape(shape);
  }
}


float triangleArea(float x1, float y1, float x2, float y2, float x3, float y3) {
  float d1 = dist(x1, y1, x2, y2);
  float d2 = dist(x2, y2, x3, y3);
  float d3 = dist(x3, y3, x1, y1);

  float s = (d1+d2+d3)/2;

  float a = sqrt(s*(s-d1)*(s-d2)*(s-d3));

  return a;
}