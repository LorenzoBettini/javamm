package javamm;

@SuppressWarnings("all")
public class BinaryStrings {
  /**
   * Example 4.14 of the book
   */
  public static void printArray(int[] a) {
    int na = a.length;
    for (int i = 0; (i < na); i++) {
      String _plus = (Integer.valueOf(a[i]) + " ");
      System.out.print(_plus);
    }
    System.out.println();
  }
  
  public static void generate(int[] a, int b) {
    if ((b == 0)) {
      BinaryStrings.printArray(a);
    } else {
      a[(b - 1)] = 0;
      BinaryStrings.generate(a, (b - 1));
      a[(b - 1)] = 1;
      BinaryStrings.generate(a, (b - 1));
    }
  }
  
  public static void main(String[] args) {
    int[] a = { 0, 0, 0, 0 };
    BinaryStrings.generate(a, 4);
  }
}
