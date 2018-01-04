package javamm;

@SuppressWarnings("all")
public class Maximum {
  /**
   * Example 3.19 of the book
   */
  public static int max(int[] number) {
    int max = number[0];
    for (int i = 1; (i < number.length); i = (i + 1)) {
      boolean _lessThan = (max < number[i]);
      if (_lessThan) {
        max = number[i];
      }
    }
    return max;
  }
  
  public static void main(String[] args) {
    int[] a = { 2, 4, 7, 12, 1, 9 };
    System.out.println(Maximum.max(a));
  }
}
