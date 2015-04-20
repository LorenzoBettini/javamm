package javamm;

@SuppressWarnings("all")
public class Factorial {
  public static long factorial(int n) {
    long result = 1;
    for (int i = 2; (i <= n); i = (i + 1)) {
      result = (result * i);
    }
    return result;
  }
  
  public static void main(String[] args) {
    long _factorial = Factorial.factorial(5);
    System.out.println(_factorial);
  }
}
