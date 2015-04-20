package javamm;

@SuppressWarnings("all")
public class Nepero {
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
    double _nepero = Nepero.nepero(0.000000001);
    System.out.println(_nepero);
  }
}
