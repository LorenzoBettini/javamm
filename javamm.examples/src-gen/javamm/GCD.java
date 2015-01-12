package javamm;

@SuppressWarnings("all")
public class GCD {
  /**
   * computes the greatest common divisor (gcd) of two integers.
   */
  public static int gcd(int a, int b) {
    while (((a > 0) && (b > 0))) {
      if ((a > b)) {
        a = (a % b);
      } else {
        b = (b % a);
      }
    }
    if ((a == 0)) {
      return b;
    } else {
      return a;
    }
  }
  
  public static void main(String[] args) {
    int _gcd = GCD.gcd(21, 7);
    System.out.println(_gcd);
    int _gcd_1 = GCD.gcd(69, 21);
    System.out.println(_gcd_1);
  }
}
