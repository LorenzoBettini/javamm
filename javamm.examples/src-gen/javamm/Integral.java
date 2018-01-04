package javamm;

@SuppressWarnings("all")
public class Integral {
  /**
   * Example 4.6 of the book
   */
  public static double integral(double a, double b, int n) {
    double h = ((b - a) / n);
    double area = 0.0;
    for (int i = 0; (i < n); i++) {
      double _f = Integral.f((a + (i * h)));
      double _multiply = (h * _f);
      double _plus = (area + _multiply);
      area = _plus;
    }
    return area;
  }
  
  public static double f(double x) {
    return (4 / (1 + (x * x)));
  }
  
  public static void main(String[] args) {
    System.out.println(Integral.integral(0, 1, 16384));
  }
}
