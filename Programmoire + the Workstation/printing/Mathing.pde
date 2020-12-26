class Mathing {
  int [][]grd;
  int [] tote = new int [n*2];
  int [] diag = new int [2];

  Mathing() {
    grd = grid;
  }

  void adding(int [][]grid, int i, int j) {
    tote[j] += grid[i][j];
    //make these concise stop being an idiot
    tote[3] = (grid[0][0] + grid[0][1] + grid[0][2]);
    tote[4] = (grid[1][0] + grid[1][1] + grid[1][2]);
    tote[5] = (grid[2][0] + grid[2][1] + grid[2][2]); 
    diag[1] = (grid[2][0] + grid[1][1] + grid[0][2]);
    diag[0] = (grid[0][0]+ grid[1][1] + grid[2][2]);
  }
  void writing(float len) {
    textSize(15);
    fill(0);

    text(tote[0], len - 10, 60); //1
    text(tote[1], len - 10, 190); //2
    text(tote[2], len - 10, 310); //3

    text(tote[3], 100, len - 10); //4
    text(tote[4], 200, len - 10); //5
    text(tote[5], 300, len - 10); //6

    pushMatrix();
    translate(350, 350);
    rotate(PI/3.0);
    text(diag[0], 0, 0); //right corner
    popMatrix();

    pushMatrix();
    translate(35, 350);
    rotate((PI/-3.0));
    text(diag[1], 0, 0);  //left corner
    popMatrix();
  }
  void reseting() {
    for (int k = 0; k < tote.length; k++) {
      tote[k] = 0;
      diag[0] = 0;
      diag[1] = 0;
    }
  }
  void checking() {
    if (tote[0] == 15 && tote[1] == 15 && tote[2] == 15 && tote[3] == 15 && tote[4] == 15 && tote[5] == 15 && diag[0] == 15 && diag[1] == 15) {
      magic = true;
    } 
    if (tote[0] == 15 && tote[1] == 15 && tote[2] == 15 && tote[3] == 15 ) { //&& tote[4] == 34 && tote[5] == 34) {
      semiMagic = true;
    } 
    //if (counter == 5){  //test for conditional. uncomment for testing.
    //  semiMagic = true;
    //}
        else {
      magic = false;
      semiMagic = false;
    }
  }
}
