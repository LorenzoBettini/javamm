package javamm;

@SuppressWarnings("all")
public class LinearEquation {
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
      System.out.println(("Solution: " + Double.valueOf(((-b) / a))));
    }
  }
  
  public static void main(String[] args) {
    LinearEquation.solve(0.5, (-1));
  }
}
