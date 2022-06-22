package javamm;

@SuppressWarnings("all")
public class Matches {
  /**
   * Example 3.7 of the book
   */
  public static int firstMove(int n, int k) {
    int x = (n % (k + 1));
    if ((x == 0)) {
      return k;
    } else {
      return (x - 1);
    }
  }

  public static int nextMove(int b, int k) {
    return ((k + 1) - b);
  }

  public static void main(String[] args) {
    System.out.println(Matches.firstMove(15, 3));
    System.out.println(Matches.nextMove(1, 3));
  }
}
