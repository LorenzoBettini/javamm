@SuppressWarnings("all")
public class BubbleSort {
  /**
   * Orders the passed array with the bubble sort algorithm
   */
  public static void bubbleSort(final int[] array) {
    boolean swapped = true;
    int j = 0;
    int tmp = 0;
    while (swapped) {
      {
        swapped = false;
        j = (j + 1);
        for (int i = 0; (i < (array.length - j)); i++) {
          if ((array[i] > array[(i + 1)])) {
            tmp = array[i];
            array[i] = array[(i + 1)];
            array[(i + 1)] = tmp;
            swapped = true;
          }
        }
      }
    }
  }
  
  /**
   * Prints the passed array to the standard output
   */
  public static void printArray(final int[] a) {
    {
      int i = 0;
      int _length = a.length;
      boolean _lessThan = (i < _length);
      boolean _while = _lessThan;
      while (_while) {
        String _plus = (a[i] + " ");
        System.out.print(_plus);
        int _i = i;
        i = (_i + 1);
        int _length_1 = a.length;
        boolean _lessThan_1 = (i < _length_1);
        _while = _lessThan_1;
      }
    }
    System.out.println("");
  }
  
  public static void main(final String... args) {
    int[] test = { 10, 4, 2, 8, 1 };
    BubbleSort.printArray(test);
    BubbleSort.bubbleSort(test);
    BubbleSort.printArray(test);
    test = new int[] { 10, 4, 2, 8, 1, 10, 4, 2, 8, 1 };
    BubbleSort.printArray(test);
    BubbleSort.bubbleSort(test);
    BubbleSort.printArray(test);
  }
}
