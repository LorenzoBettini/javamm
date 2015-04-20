package javamm;

@SuppressWarnings("all")
public class Hanoi {
  public static void solve(int n, int s, int d) {
    if ((n > 0)) {
      Hanoi.solve((n - 1), s, ((6 - s) - d));
      System.out.println(((("Move disc from " + Integer.valueOf(s)) + " to ") + Integer.valueOf(d)));
      Hanoi.solve((n - 1), ((6 - s) - d), d);
    }
  }
  
  public static void main(String[] args) {
    Hanoi.solve(3, 1, 3);
  }
}
