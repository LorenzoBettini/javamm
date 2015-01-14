package javamm;

@SuppressWarnings("all")
public class LocalVariables {
  /**
   * Example 4.2 of the book
   */
  public static int f1(int b) {
    int a = (b + 1);
    return (a + 1);
  }
  
  public static int f2(int a) {
    int b = (a - 2);
    return (b - 2);
  }
  
  public static void main(String[] args) {
    int b = 10;
    int a = 10;
    System.out.println(((("a: " + Integer.valueOf(a)) + ", b: ") + Integer.valueOf(b)));
    int _f1 = LocalVariables.f1(a);
    b = _f1;
    int _f2 = LocalVariables.f2(b);
    a = _f2;
    System.out.println(((("a: " + Integer.valueOf(a)) + ", b: ") + Integer.valueOf(b)));
  }
}
