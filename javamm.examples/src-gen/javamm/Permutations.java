package javamm;

@SuppressWarnings("all")
public class Permutations {
  /**
   * Example 4.14 of the book
   */
  public static void printArray(char[] a) {
    int na = a.length;
    for (int i = 0; (i < na); i++) {
      String _plus = (Character.valueOf(a[i]) + " ");
      System.out.print(_plus);
    }
    System.out.println();
  }
  
  public static void generate(char[] a, int p) {
    char temp = 0;
    if ((p == 0)) {
      Permutations.printArray(a);
    } else {
      for (int i = (p - 1); (i >= 0); i--) {
        {
          temp = a[i];
          a[i] = a[(p - 1)];
          a[(p - 1)] = temp;
          Permutations.generate(a, (p - 1));
          temp = a[i];
          a[i] = a[(p - 1)];
          a[(p - 1)] = temp;
        }
      }
    }
  }
  
  public static void main(String[] args) {
    char[] a = { 'a', 'b', 'c', 'd' };
    Permutations.generate(a, 4);
  }
}
