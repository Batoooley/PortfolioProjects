class Glyph {

  int [] arr;
  color tariffPurple = color(154, 89, 163);
  color tariffGreen = color(39, 177, 108);
  color red = color(255, 0, 0);
  color green = color(0, 255, 0); 
  float gradGrowth = 0;

  Glyph(int [] arry) {
    arry = arr;
  }

  void display(int [] arr) {

    int spacing = 4;
    int numOfBG = height/spacing + 2;

    for (int i = 0; i < numOfBG; i++) {

      color c;
      c  = lerpColor(red, green, gradGrowth); //(tariffPurple, tariffGreen, gradGrowth);

      if (i % 2 == 0) {
        gradGrowth = map(i, 0, numOfBG, 0.1 * arr[0], 0.9);
      } else {
        gradGrowth = map(i, 0, numOfBG, 0.1 * arr[3], 0.9);
      }
      // fill(c);
      stroke(c);
      strokeWeight(9);

      float locY = (1 * i) * spacing;
      line(width - 37, locY, width, locY);
    }
  }

  void symbol(int [] arr) {
    randomSeed(5);
    pushMatrix();
    pushStyle();
    //translate((width/4) * 3, height/5);
    noFill();
    //ellipse(0, 0, 10, 10);
    beginShape();
    vertex(20 * random(5), 20* arr[0]);
    vertex(20* random(5), 40* arr[1]);
    vertex(40* random(5), 40 * arr[2]);
    vertex(40* random(5), 20* arr[3]);
    //vertex(50, 60* arr[0]);
    //vertex(20, 60* arr[1]);
    endShape(CLOSE);
    popStyle();
    popMatrix();
  }
} //class closure. dont delete this one. 
