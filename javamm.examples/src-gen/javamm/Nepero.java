package javamm;

@SuppressWarnings("all")
public class Nepero {
  /**
   * Example 3.16 of the book
   */
  public static double nepero(double epsilon) {
    int n = 0;
    double term = 1;
    double nepero = 0;
    do {
      {
        nepero = (nepero + term);
        n = (n + 1);
        term = (term / n);
      }
    } while(((term * (1 + (2.0 / (n + 2)))) > epsilon));
    return nepero;
  }
  
  public static void main(String[] args) {
    System.out.println(Nepero.nepero(0.000000001));
  }
}
