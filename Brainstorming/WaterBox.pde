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

  void display() {
    noStroke();
    fill(0, 100, 150+frameCount%55);
    rect(x, y, w, -h);
  }
  
  void increaseLevel(float amt){
    h += amt;
  }
  
  float getWaterLevel(){
    return h;
  }
}