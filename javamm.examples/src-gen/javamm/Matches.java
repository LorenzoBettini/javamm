package javamm;

@SuppressWarnings("all")
public class Matches {
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
    int _firstMove = Matches.firstMove(15, 3);
    System.out.println(_firstMove);
    int _nextMove = Matches.nextMove(1, 3);
    System.out.println(_nextMove);
  }
}
