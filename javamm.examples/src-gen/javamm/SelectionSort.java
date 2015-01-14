package javamm;

@SuppressWarnings("all")
public class SelectionSort {
  /**
   * Example 4.5 of the book
   */
  public static void selectionSort(int[] a) {
    int i = 0;
    int j = 0;
    int next = 0;
    int min = 0;
    int temp = 0;
    for (i = 0; (i < (a.length - 1)); i++) {
      {
        min = a[i];
        next = i;
        for (j = (i + 1); (j < a.length); j++) {
          boolean _lessThan = (a[j] < min);
          if (_lessThan) {
            min = a[j];
            next = j;
          }
        }
        temp = a[i];
        a[i] = a[next];
        a[next] = temp;
      }
    }
  }
  
  public static void printArray(int[] number) {
    System.out.print("Array: ");
    for (int i = 0; (i < number.length); i++) {
      String _plus = (Integer.valueOf(number[i]) + " ");
      System.out.print(_plus);
    }
    System.out.println();
  }
  
  public static void main(String[] args) {
    int[] number = { 7, 6, 11, 17, 3, 15, 5, 19, 30, 14 };
    SelectionSort.printArray(number);
    SelectionSort.selectionSort(number);
    SelectionSort.printArray(number);
  }
}
