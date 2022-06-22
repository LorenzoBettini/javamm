package javamm;

@SuppressWarnings("all")
public class QuadraticEquation {
  /**
   * Example 3.9 of the book
   */
  public static void solve(double a, double b, double c) {
    double delta = ((b * b) - ((4 * a) * c));
    if ((delta < 0)) {
      System.out.println("Complex solutions");
    } else {
      if ((delta > 0)) {
        System.out.println("Distinct solutions");
      } else {
        System.out.println("Identical solutions");
      }
    }
  }

  public static void main(String[] args) {
    QuadraticEquation.solve(1, 4, 3);
  }
}
