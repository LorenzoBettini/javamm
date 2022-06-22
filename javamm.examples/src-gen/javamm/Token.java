package javamm;

@SuppressWarnings("all")
public class Token {
  /**
   * Example 3.8 of the book
   */
  public static int move(int p) {
    if ((p == 0)) {
      return 2;
    } else {
      return (5 - p);
    }
  }

  public static void main(String[] args) {
    System.out.println(Token.move(0));
  }
}
