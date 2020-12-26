//version: Dec 26, cleaned & restored to state at exhibition

import java.util.*;
import processing.core.PApplet;
import gohai.simplereceiptprinter.*;
import processing.serial.*;

SimpleReceiptPrinter printer;
PWindow win; 

Sorting sorter;
Mathing mather;
int n = 3;                                //this is the square "order"

int [] vals = new int [n*n];              //to hold the vals (ingredients of the ritual) in the square

int [][] grid = new int [n][n];           //structure for the values

PVector margine = new PVector (10, 10);   //swap this out with "margin" OG: 10
PVector[] posArr = new PVector [n*n];     //n*n is 9 //make an array of PVectors, of all the ints' coordinates

final int canvasX = 384; //pritner width is 384 pixels
final int canvasY = 384; //600;

int len = (canvasX - int(margine.x)); //(int(margine.x)));
int step = len / n;
int counter; 

boolean magic;
boolean semiMagic;

void settings() {
  size(canvasX, canvasY); //size(700, 150);
}

void setup() {
  frameRate(20);
  magic = true;

  for (int i = 0; i < vals.length; i++) {
    vals[i] = i + 1;                       //+1 because the value "0" is not used in the magic squares
  }

  sorter = new Sorting(vals);
  mather = new Mathing();
  counter = 0; 

  ////PRINTER setup start
  String[] ports = SimpleReceiptPrinter.list(); 
  println("Available serial ports:"); 
  printArray(ports); 
  String port = ports[0];
  println("Attempting to use " + port);
  printer = new SimpleReceiptPrinter(this, ports[0], 2.68, 9600); 
  ////PRINTER setup end

  win = new PWindow();
  printer.println("HI");
  printer.feed(1);
}

void draw () {
  background (255); //(150, 200, 224);
  counter++;

  pushMatrix();
  translate(5, 5);
  pushStyle();
  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid.length; j++) {

      grid[i][j] = vals[(j * n) + i];

      int idx = grid[i][j] - 1; //counter:
      PVector ns = new PVector ( step + (i * step), step + (j * step) ); //positions
      PVector midCell = new PVector (ns.x - (step/2), ns.y - (step/2));
      posArr[idx] = new PVector(midCell.x, midCell.y);                  

      textAlign(CENTER);
      textSize(20);
      fill(0);
      text(grid[i][j], midCell.x, midCell.y); 

      pushStyle();
      noFill();
      pushMatrix();
      translate(-step, -step);
      rect(ns.x, ns.y, step, step);
      popMatrix();
      popStyle();

      //line(20, 30 + i * 30, height, i * 30);
      mather.adding(grid, i, j);
    }
  }

  mather.checking();

  fill(0);
  mather.writing(len);

  pushStyle();
  noFill();
  strokeWeight(5);
  stroke(0);
  strokeJoin(ROUND);
  beginShape();

  for (int dr = 0; dr < posArr.length; dr++) {

    float posX = posArr[dr].x;
    float posY = posArr[dr].y;   

    vertex(posX, posY); 

    if (dr == 0) {
      pushStyle();
      fill(255, 204, 204);//(200, 255, 200);
      ellipse(posX, posY, 10, 10);
      popStyle();
    } 
    if (dr == 8) {
      rect(posX, posY - 10, 1, 20);
    }
  }
  endShape();
  popStyle();
  popMatrix(); 

  if (magic || semiMagic) {
    noLoop();                    //stop the frame from refreshing while printer is printing to wait for it
    printer.printBitmap(get()); ////PRINTER
  } if (magic == false || semiMagic == false){
    loop();
  }

  sorter.doSort();
  mather.reseting();
}

///////////////////////////////////////////////////////////////
void keyPressed() {
  if (key == 'r') {
    // loop();
    redraw();
  } else if (key == 's') {
    noLoop();
  } else if (key == 'p') {
    printer.feed(1);
    printer.printBitmap(get()); ////PRINTER
    printer.feed(5);
  }
}
