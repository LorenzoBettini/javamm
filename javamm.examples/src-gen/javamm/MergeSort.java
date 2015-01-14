package javamm;

@SuppressWarnings("all")
public class MergeSort {
  /**
   * Example 4.15 of the book
   */
  public static void printArray(int[] a) {
    int na = a.length;
    for (int i = 0; (i < na); i++) {
      String _plus = (Integer.valueOf(a[i]) + " ");
      System.out.print(_plus);
    }
    System.out.println();
  }
  
  public static void sort(int[] a, int left, int right) {
    if ((left < right)) {
      int middle = ((left + right) / 2);
      MergeSort.sort(a, left, middle);
      MergeSort.sort(a, (middle + 1), right);
      MergeSort.merge(a, left, middle, right);
    }
  }
  
  public static void merge(int[] a, int left, int middle, int right) {
    int[] b = new int[((right - left) + 1)];
    int i = left;
    int j = (middle + 1);
    int k = 0;
    while (((i <= middle) && (j <= right))) {
      boolean _lessThan = (a[i] < a[j]);
      if (_lessThan) {
        b[k] = a[i];
        i = (i + 1);
        k = (k + 1);
      } else {
        b[k] = a[j];
        j = (j + 1);
        k = (k + 1);
      }
    }
    while ((i <= middle)) {
      {
        b[k] = a[i];
        i = (i + 1);
        k = (k + 1);
      }
    }
    while ((j <= right)) {
      {
        b[k] = a[j];
        j = (j + 1);
        k = (k + 1);
      }
    }
    for (i = left; (i <= right); i = (i + 1)) {
      a[i] = b[(i - left)];
    }
  }
  
  public static void main() {
    int[] a = { 7, 11, 9, 6, 12, 15, 8, 10, 14, 13 };
    MergeSort.printArray(a);
    int _length = a.length;
    int _minus = (_length - 1);
    MergeSort.sort(a, 0, _minus);
    MergeSort.printArray(a);
  }
  
  public static void main(String[] args) {
    MergeSort.main();
  }
}
