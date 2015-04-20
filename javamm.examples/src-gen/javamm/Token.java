package javamm;

@SuppressWarnings("all")
public class Token {
  public static int move(int p) {
    if ((p == 0)) {
      return 2;
    } else {
      return (5 - p);
    }
  }
  
  public static void main(String[] args) {
    int _move = Token.move(0);
    System.out.println(_move);
  }
}
