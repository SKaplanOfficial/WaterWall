//*****************************//
//      SHAPE DEFINITION       //
//*****************************//

class Shape {
  PShape shape;          // Actual shape object to be displayed
  int type;              // Type of shape... useful if more shapes other than triangles are added

  float minX, minY;      // Top and bottom positions
  float maxX, maxY;      // Right and left postions
  float area;            // Area of shape

  float xpos1, xpos2, xpos3, xpos4;  // X values of coordinates
  float ypos1, ypos2, ypos3, ypos4;  // Y values of coordinates

  // TRIANGLE
  Shape(float x1, float y1, float x2, float y2, float x3, float y3) {
    shape = createShape(TRIANGLE, x1, y1, x2, y2, x3, y3);

    xpos1 = x1;          // Set values of coordinates
    xpos2 = x2;
    xpos3 = x3;

    ypos1 = y1;
    ypos2 = y2;
    ypos3 = y3;

    minY = min(y1, y2);  // Minimum Y value
    minY = min(minY, y3);

    area = triangleArea(xpos1, ypos1, xpos2, ypos2, xpos3, ypos3);

    type = 1;
  }

  void run() {
    checkCollisions();
    display();
  }

  void checkCollisions() {
    if (mousePressed && mouseButton == RIGHT) {
      // Remove the triangle if mouse is right clicked within the bounds of the shape
      if (type == 1) {
        float area1 = triangleArea(mouseX, mouseY, xpos1, ypos1, xpos2, ypos2);
        float area2 = triangleArea(mouseX, mouseY, xpos2, ypos2, xpos3, ypos3);
        float area3 = triangleArea(mouseX, mouseY, xpos3, ypos3, xpos1, ypos1);

        if (area1 + area2 + area3 == area) {
          shapes.remove(this);
        }
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
    shape.setFill(color(200, 100));
    shape.setStroke(color(255, 50));
    shape.strokeWeight(5);
    shape(shape);
  }
}


float triangleArea(float x1, float y1, float x2, float y2, float x3, float y3) {
  // Three lines
  float d1 = dist(x1, y1, x2, y2);
  float d2 = dist(x2, y2, x3, y3);
  float d3 = dist(x3, y3, x1, y1);

  // Heron's formula
  float s = (d1+d2+d3)/2;
  float a = sqrt(s*(s-d1)*(s-d2)*(s-d3));

  return a;
}