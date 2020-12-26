

class PWindow extends PApplet {
  int leng = 200;
  int stp = leng/n;
  int ctr;
  int mar = 20;
  PVector box = new PVector (leng + mar, leng + mar);

  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    //size(900, 700);
    fullScreen();
  }

  void setup() { //SimpleReceiptPrinter P
    frameRate(5);
    ctr = 0;
    fill(0);
    rect(mar + leng, mar + leng, width, height);
  }

  void draw() { 
  
    pushStyle();
    fill(255);
    noStroke();
    rect(0, 0, width, leng + mar);
    rect(0, 0, leng + mar, height);
    popStyle();

    ctr++;
    
    fill(0);
    text(ctr, mar + 5, mar - 5);

    pushMatrix();
    translate(mar, mar);
    layout();

    pushStyle();
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid.length; j++) {

        grid[i][j] = vals[(j * n) + i];

        int idx = grid[i][j] - 1; //counter:
        PVector n = new PVector ( 30 + (i * stp), 30 + (j * stp) ); //positions

        posArr[idx] = new PVector(n.x, n.y); 

        textAlign(CENTER);
        textSize(12);
        fill(0);
        text(grid[i][j], n.x, n.y);
      }
    }
    popStyle();

    pushStyle();
    noFill();
    strokeJoin(ROUND);

    //HORIZONTAL PATH
    beginShape();
    for (int dr = 0; dr < posArr.length; dr++) {
      float poX = 65 + (stp * 3) + (dr * (width / 30)); //FIX ON SCREEN
      float poY = posArr[dr].y; 

      rectMode(CENTER);
      vertex(poX, poY);
      line(20 + poX + stp/3, 0, 20 + poX + stp/3, leng + mar);
      rect(poX, poY, stp/2, stp/2);

      if (dr == 0) {
        pushStyle();
        fill(0);
        ellipse(poX, poY, 10, 10); 
        popStyle();
      } 
      if (dr == 15) {
        rect(poX, poY, 10, 10); 
      }
    }
    endShape();

    ///VERTICAL PATH
    beginShape();

    for (int dr = 0; dr < posArr.length; dr++) {
      float poX = posArr[dr].x;  
      float poY = 65 + (stp * 3) + dr * (height / 22); //posArr[dr].y;

      rectMode(CENTER);
      vertex(poX, poY);
      line(0, 10 + poY + stp/3, leng + mar, 10 + poY + stp/3);
      rect(poX, poY, stp/2, stp/2);

      if (dr == 0) {
        pushStyle();
        fill(0);
        ellipse(poX, poY, 10, 10); 
        popStyle();
      } 
      if (dr == 15) {
        rect(poX, poY, 10, 10); 
      }
    }
    endShape();

    //2D SHAPE
    pushStyle();
    strokeWeight(3);
    beginShape();
    for (int dr = 0; dr < posArr.length; dr++) {
      float poX = posArr[dr].x; 
      float poY = posArr[dr].y; 

      rectMode(CENTER);
      vertex(poX, poY);

      if (dr == 0) {
        pushStyle();
        fill(0);
        ellipse(poX, poY, 10, 10); 
        popStyle();
      } 
      if (dr == 15) {
        rect(poX, poY, 10, 10); 
      }
    }
    endShape();
    popStyle();

    popStyle();
    popMatrix();

    if (semiMagic || magic) {
      pushMatrix();
      small2D();
      delay(15000);
      box.x += leng/2; 
      popMatrix();
    }
    if (box.x >= width ) { 
      box.x = leng + mar;
      box.y += leng/2;
    } 
    if (box.y >= height - leng) { 
      box.y = leng + mar;
      fill(0);
      rect(mar + leng, mar + leng, width, height);
    } 
  }


  void layout() {
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(0, 0, leng, leng);
    line(leng, -mar, leng, height);
    line(-mar, leng, width, leng);
    line(0, -mar, 0, height);
    line(-mar, 0, width, 0);
  }

  void small2D () {
    //2D SHAPE
    translate(box.x, box.y);
    pushStyle();
    scale(0.5, 0.5);
    beginShape();
    for (int dr = 0; dr < posArr.length; dr++) {
      float poX = posArr[dr].x;  
      float poY = posArr[dr].y; 
      strokeWeight(3);
      stroke(255);
      rectMode(CENTER);
      vertex(poX, poY);

      if (dr == 0) {
        pushStyle();
        fill(0);
        ellipse(poX, poY, 10, 10); 
        popStyle();
      } 
      if (dr == 15) {
        rect(poX, poY, 10, 10); 
      }
    }
    endShape();
    popStyle();
  }
}
