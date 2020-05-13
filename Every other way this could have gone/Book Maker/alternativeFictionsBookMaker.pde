/*
Title: Every other way this could have gone
 Artist: Batool Desouky
 Year: 2019
 Produced for the MA/MFA in Computational Arts, year 2018/19
 
 
 Brief description:
 This code is one of three programmes that make up the artwork.  
 This programme reads from several texts in the "data" folder which has been renamed "original fictions" folder, and creates a folder named "altenative fictions" where the
 generated permutations of each story are compiled as a PDF. When the programme detects that therer are as many PDFs in this file as there are stories, it generates a final
 PDF document called "binding" which serves as the cover of the book. 
 The programme also generates a txt file for each story that compiles all permutations generated, this is for my personal refernce and to allow the option to read and edit
 the permutations or commentate on them which a PDF will not allow.
 
 Stories used are public domain translations of Aesops fables, sourced from Project Gutenberg: https://www.gutenberg.org/files/11339/11339-h/11339-h.htm 
 
 Code referenced:
 some code is borrowed from a tutorial by Daniel Shiffman, link to tutorial below:
 https://www.youtube.com/watch?v=goUlyp4rwiU
 */

import java.util.*;
import processing.pdf.*;
import java.util.Date;

PGraphicsPDF pdf;
Glyph glyph;

//this is the main array that controls how most of the programme works. It is tied to the order of permutations of stories, and also determines the shape of the glyph and gradient
int [] vals = {0, 1, 2, 3}; 

String [] File;                             //read from external txt file
String file;
String [] lines;
String l; 
String s;

int storyNum, pages, versionNo; //which story in the folder to read this time, increase page no. with pages, increase versionNo with every generate() function
PFont f, coverFont, bodyFont, binderFont;

int totalVersions = (factorial(vals.length));  //uses the factorial function (written below) to calculate length of book/per story

String[] Stories = {"The Astronomer.txt", "The Belly and the Members.txt", "The Old Man and Death.txt", "The Wind and The Sun.txt", "The Mistress and her Servants.txt"}; //src files of original stories to read from 
String[] saveTo = {"The Astronomer.pdf", "The Belly and the Members.pdf", "The Old Man and Death.pdf", "The Wind and The Sun.pdf", "The Mistress and her Servants.pdf"};  //final pdfs of "bound" alternative fiction books
ArrayList<String> allAlternatives = new ArrayList<String>();

String storyTitle, projectTitle = "Every Other Way This Could Go";

int margin = 37; //margins and guides 1cm = 37 px

boolean compile = false;

void setup() {
  size(559, 793);                                                         //size of one A5 page

  //change this number to switch between stories
  ///////////////////////
  storyNum = 4;    //////    
  ///////////////////////

  f = createFont("UHER", 15, true);                                       //different fonts for different design elements
  coverFont = createFont("Times-Italic", 40, true);
  bodyFont = createFont("times", 17, true);
  binderFont = createFont("Bungee outline", 75, true);

  File = loadStrings("originalFictions/" + Stories[storyNum]);            //read from this txt file
  file = join(File, " ");                                                 //file is the baseline object
  printArray(file);
  lines = splitTokens(file, "#");                                         //seperate parts of the story in clear chunks using an uncommon text character

  pdf = (PGraphicsPDF)beginRecord(PDF, "alternativeFictions/" + saveTo[storyNum]); 
  beginRecord(pdf); 
  textMode(SHAPE); 
  textAlign(LEFT, TOP);

  glyph = new Glyph (vals);

  pages = 0;
  versionNo = 1;                                       //the original story is technically the first version of it, so start counting at 1 not 0.

  println("filenames in a directory: ");
  String[] filenames = listFileNames(sketchPath("alternativeFictions/"));  //count how many alternative fictions have been generated to check for need for binding
  printArray(filenames);

  int bindingCounter = filenames.length - 1;           //there is an invisible file called .DS_Store that gets counted but not useful for us. subtract 1 to correct this
  println(bindingCounter);

  if (bindingCounter == Stories.length) {              // check if we need a binding/cover by counting files in the folder and checking that number against number of storries in the array
    compile = true;
  }

  if (compile) {
    beginRecord(PDF, "alternativeFictions/Binding.pdf");
  }
  println(compile);
}

//function taken from Daniel Shiffman example code. by counting this list we can determin if we need a binder
String[] listFileNames(String dir) { 
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    return null;
  }
}

void draw() {
  background(255);
  textFont(f, 16);
  if (compile == true) {             //if we need a binder, run the programme for 3 frames then end the PDF recording and exit the programme
    binding(vals);
    if (frameCount == 3) {
      endRecord();
      exit();
    }
  } else {
    if (pages < totalVersions) {    //if we dont need a binder then start by drawing the cover page of each story then move on the the next page
      if (pages == 0) {
        pages++;
        pushStyle();
        coverPage();
        popStyle();
      } else {                     //after the cover page, create a page for every permutation of that stroy that is generated
        pages++;
        generate();
        visualisation(vals);

        fill(0);
        pushMatrix();             //matrix to contain the information on the side bar
        pushStyle();
        translate(width - 30, height - 20);
        rotate(radians(90));
        textFont(bodyFont);
        textAlign(RIGHT, BOTTOM);
        text("version: " + versionNo, 0, 0);
        popStyle();
        popMatrix();
        int xBox = width/2 + 25;
        int yBox = height/2 + 100;
        text(l, margin + 10, margin*2 + 10, width/2 + 5, height);  //body text is aligned to the text box in the visualisation function

        pushStyle();
        pushMatrix();
        textAlign(RIGHT, BOTTOM);
        textFont(bodyFont);
        translate(width - 30, 50);
        rotate(radians(90));
        text(s, 0, 0);
        popMatrix();
        popStyle();
      }
      pdf.nextPage();
    } else if (pages == totalVersions) {  //if we have reached the end of the series of permutations, end the PDF record and exit. MUST exit before the sorting code reaches -1 to avoid a null pointer
      endRecord();
      exit();
    }
  }
}

void generate() {
  versionNo ++;                                 //every time this runs, incirment the count on how many permutations we have

  //----Sorting code
  //STEP 1
  //Using a similar system to alphabetical ordering, this code checks for the magnitude or size of each value in the array, compares it to next value down, then performes a 
  //swap INCREMENTALLY so that it always keeps the smallest value possible at the begining of the array, while always having to generate a new swap (or a new permutation),
  //and also while never repeating a combination.
  //This logic is at the core of the process, allowing us to get every possible combination without repetitions and in logical order (not random).
  //NOTE: the comment "//----end of sorting code" marks the end of the code borrowed from Shiffman
  int largestI = -1;
  for (int i = 0; i < vals.length - 1; i++) {
    if (vals[i] < vals[i + 1]) {
      largestI = i;
    }
  }
  if (largestI == -1) { //
    println("-1 reached");
  }
  //STEP 2
  int largestJ = -1;
  for (int j = 0; j < vals.length; j ++) {
    if (vals[largestI] < vals[j]) {
      largestJ = j;
    }
  }
  //STEP 3
  swap(vals, largestI, largestJ);
  //STEP 4: reverse from the largest I + 1 to the end
  int size = vals.length - largestI - 1;
  int[] endArray = new int[size];
  arrayCopy(vals, largestI + 1, endArray, 0, size);
  endArray = reverse(endArray);
  arrayCopy(endArray, 0, vals, largestI + 1, size);
  //----end of sorting code

  s = " ";                                                   //must be emptied before every new combo is generated
  l = " ";                                                   //must be emptied before every new combo is generated
//in order to apply this logic to the texts, the string arrays read from the file are cross referenced to access 
  for (int i = 0; i < vals.length; i++) {
    s += vals[i];
    l += lines[vals[i]];    
  }

  allAlternatives.add(l);
  for (int i=0; i<allAlternatives.size(); i++) {
    //println(i + ": " + allAlternatives.get(i));
  }
  String[] tempLang = new String[allAlternatives.size()];
  for (int i  = 0; i < allAlternatives.size(); i++) {
    tempLang[i] = allAlternatives.get(i);
  }
  saveStrings("permutations/" + Stories[storyNum], tempLang);
}

void swap (int[] a, int i, int j) {
  int temp = a[i];
  a[i] = a[j];
  a[j] = temp;
}

int factorial(int n) {
  int result = 1;
  while (n > 1) {
    result *= n;
    n--;
  } 
  return result;
}

void coverPage() {
  String title = Stories[storyNum].substring(0, Stories[storyNum].length() - 4);  //title of file without ".txt" extension

  textFont(coverFont);
  textAlign(LEFT, BOTTOM);
  fill(0);
  text(title, margin, 80);

  textFont(bodyFont);

  pushMatrix();
  translate(margin + 10, 130);
  textAlign(LEFT, TOP);
  text(file, 0, 0, width/2 + 10, height);
  popMatrix();

  pushMatrix();
  pushStyle();
  translate(width - 30, height - 20);
  rotate(radians(90));
  textAlign(RIGHT, BOTTOM);
  text("part of: " + projectTitle, 0, 0);
  popStyle();
  popMatrix();

  pushStyle();
  noFill(); //only the rect should be no fill
  int xBox = width/2 + 25;
  int yBox = height/2 + 100;
  rect(margin, 120, xBox, yBox); //acting textbox
  popStyle();
}

void binding( int [] arr) {
  textFont(binderFont, 70);
  text("Every Other Way This Could Have Gone", 10, 180, width, height/2);
  PFont subtitle = createFont("Roboto Mono Light", 15);
  textFont(subtitle);
  text("computationally generated alternatives to some of stories I was taught", 10, height - (height /4), width - 50, height);
  fill(0);
  //generate();
  //for (int i = 0; i < 4; i++) {
  //  for (int j = 0; j < 6; j++) {
  //    pushMatrix();
  //    translate(i * 50, j * 50);
  //    glyph.symbol(arr);
  //    popMatrix();
  //  }
  //}
}

void visualisation (int [] arr) { //pass the ordering array into this to control permutations of a shape
  pushStyle();
  glyph.display(arr);
  popStyle();

  pushMatrix();
  translate((width/4) * 3, height/10);
  glyph.symbol(arr);
  popMatrix();

  pushStyle();
  noFill(); //only the rect should be no fill
  rect(margin, margin * 2, width/2 + 20, height/2 + 50); //rect acting textbox for alignment
  popStyle();
}
