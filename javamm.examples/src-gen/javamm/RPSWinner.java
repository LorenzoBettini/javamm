package javamm;

@SuppressWarnings("all")
public class RPSWinner {
  /**
   * Example 3.4 of the book
   */
  public static int winner(int sign1, int sign2) {
    if ((sign2 == ((sign1 + 1) % 3))) {
      return 1;
    }
    if ((sign1 == ((sign2 + 1) % 3))) {
      return 2;
    }
    return 0;
  }
  
  public static void main(String[] args) {
    int _winner = RPSWinner.winner(0, 1);
    System.out.println(_winner);
  }
}
