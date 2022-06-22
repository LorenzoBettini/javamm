package javamm;

@SuppressWarnings("all")
public class EvenOddNumber {
  /**
   * Example 3.6 of the book
   */
  public static void evenOdd(int n) {
    if (((n % 2) == 0)) {
      System.out.println((("Number " + Integer.valueOf(n)) + " is even."));
    } else {
      System.out.println((("Number " + Integer.valueOf(n)) + " is odd."));
    }
  }

  public static void main(String[] args) {
    EvenOddNumber.evenOdd(9);
    EvenOddNumber.evenOdd(10);
  }
}
