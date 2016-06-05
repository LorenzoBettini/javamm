package javamm;

@SuppressWarnings("all")
public class LinearEquation {
  /**
   * Example 3.5 of the book
   */
  public static void solve(double a, double b) {
    if ((a == 0)) {
      if ((b == 0)) {
        System.out.println("Undetermined");
      }
      if ((b != 0)) {
        System.out.println("Impossible");
      }
    }
    if ((a != 0)) {
      double _minus = (-b);
      double _divide = (_minus / a);
      String _plus = ("Solution: " + Double.valueOf(_divide));
      System.out.println(_plus);
    }
  }
  
  public static void main(String[] args) {
    LinearEquation.solve(0.5, -1);
  }
}
