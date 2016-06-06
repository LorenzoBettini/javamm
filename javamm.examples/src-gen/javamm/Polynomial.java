package javamm;

@SuppressWarnings("all")
public class Polynomial {
  /**
   * Example 3.20 of the book
   */
  public static double value(double[] p, double x) {
    double value = p[0];
    for (int i = 1; (i < p.length); i++) {
      double _plus = ((value * x) + p[i]);
      value = _plus;
    }
    return value;
  }
  
  public static void main(String[] args) {
    double[] a = { 7.439, -10.312, -3.845, 5.174, 2 };
    double _value = Polynomial.value(a, 1.426);
    System.out.println(_value);
  }
}
