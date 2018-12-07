//*****************************//
//  MOUSE AND KEYBOARD INPUT   //
//*****************************//

void mousePressed() {
  if (scene == 1 && mouseButton == LEFT) {
    if (mouseY > height-wB.getWaterLevel()) {
      // Add food at mouse position if user clicks in water
      food.add(new Food(mouseX, mouseY));
    } else {
      if (x1 == -1) {
        // Begin shape creation interaction
        posToRemove = barriers.size();
        x1 = mouseX;
        y1 = mouseY;
      } else if (x3 == -1) {
        // Third point detected -> Triangle
        x3 = mouseX;
        y3 = mouseY;
        timer = 100;
      }
    }
  }
}



void mouseDragged() {
  if (scene == 1) {
    timer = 100;
  }
}



void mouseReleased() {
  // Second point -> Line
  if (scene == 1 && x1 != -1 && x2 == -1) {
    x2 = mouseX;
    y2 = mouseY;
  }

  if (scene == 1 && x1 == x2) {
    resetInteraction();
  }
}



void keyPressed() {
  if (scene == 1 && key == 'A' || key == 'a') {  // 'A' or 'a' => 100 fish at mouse position
    for (int i=0; i<100; i++) {
      animals.add(new Animal(mouseX, mouseY));
    }
  }
}



void resetInteraction() {
  x1 = -1;
  x2 = -1;
  x3 = -1;

  y1 = -1;
  y2 = -1;
  y3 = -1;
  timer = -1;

  posToRemove = -1;
}