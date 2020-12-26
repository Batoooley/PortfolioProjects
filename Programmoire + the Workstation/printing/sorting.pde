class Sorting {
  int[] values;

  Sorting(int [] vals) {
    values = vals;
  }

  void doSort() {
    //step 1
    int largestI = -1;
    for (int i = 0; i < vals.length - 1; i++) {
      if (vals[i] < vals[i +1]) {
        largestI = i;
      }
    }
    if (largestI == -1) {
      noLoop();
      println("-1 reached");
    }

    //step 2
    int largestJ = -1;
    for (int j = 0; j < vals.length; j++) {
      if (vals[largestI] < vals[j]) {
        largestJ = j;
      }
    }
    //step 3
    swap(vals, largestI, largestJ);

    //step4
    int size = vals.length - largestI - 1;
    int [] endArray = new int[size];
    //ArrayList <Integer> endArray = new ArrayList <Integer> ();

    arrayCopy(vals, largestI + 1, endArray, 0, size);
    endArray = reverse(endArray);
    arrayCopy(endArray, 0, vals, largestI + 1, size);

    String val = " ";
    for (int i = 0; i < vals.length; i++) {
      val += vals[i];
    }
  }
  void swap (int[] a, int i, int j) {
    int temp = a[i];
    a[i] = a[j];
    a[j] = temp;
  }
}
