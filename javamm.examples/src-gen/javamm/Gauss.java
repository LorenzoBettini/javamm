package javamm;

@SuppressWarnings("all")
public class Gauss {
  public static void main(String[] args) {
    int n = 10;
    int sum = 0;
    sum = ((n * (n + 1)) / 2);
    System.out.println(((("Sum of first " + Integer.valueOf(n)) + " integers: ") + Integer.valueOf(sum)));
  }
}
