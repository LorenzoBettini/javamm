package javamm;

@SuppressWarnings("all")
public class Fibonacci {
  /**
   * Example 4.11 of the book
   */
  public static long fibonacci(int n) {
    int i = 1;
    long x = 1;
    long y = 0;
    while ((i < n)) {
      {
        i = (i + 1);
        x = (x + y);
        y = (x - y);
      }
    }
    return x;
  }
  
  public static void main(String[] args) {
    long _fibonacci = Fibonacci.fibonacci(8);
    System.out.println(_fibonacci);
  }
}
