class WaterBox {
  float x, y, w, h;

  WaterBox() {
    x = 0;
    y = height;
    w = width;
  }


  WaterBox(float x_, float y_) {
    x = x_;
    y = y_;
  }

  WaterBox(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
  }

  void run() {
    display();
  }

  void display() {
    pushMatrix();
    translate(0, 0, 1);
    noStroke();
    fill(0, 100, 100+noise(frameCount/50.0)*150, 150);
    //rect(x, y, w, -h);

    beginShape();
    vertex(x, y-h);

    for (float i=x; i<x+w; i+=(x+w)/50) {
      curveVertex(i, y-h+noise(i+frameCount/100.0)*constrain(h/10, 0, 20));
    }

    fill(0, 100, 100+noise(frameCount/50.0)*150, 150);
    vertex(w, y-h);

    fill(0, 100, 100+noise(frameCount/50.0)*150, 150);
    vertex(w, y);

    fill(0, 100, 100+noise(frameCount/50.0)*150, 150);
    vertex(x, y);
    endShape(CLOSE);

    if (h > h-15) {
      decreaseLevel(0.01);
    } else {
      decreaseLevel(0.001);
    }

    popMatrix();
  }

  void increaseLevel(float amt) {
    h += amt;
  }

  void decreaseLevel(float amt) {
    h -= amt;
  }

  float getWaterLevel() {
    return h;
  }
}