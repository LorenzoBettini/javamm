package javamm;

@SuppressWarnings("all")
public class RecursiveFactorial {
  /**
   * Example 4.10 of the book
   */
  public static int factorial(int n) {
    if ((n > 1)) {
      int _factorial = RecursiveFactorial.factorial((n - 1));
      return (n * _factorial);
    } else {
      return 1;
    }
  }
  
  public static void main(String[] args) {
    int _factorial = RecursiveFactorial.factorial(5);
    System.out.println(_factorial);
  }
}
