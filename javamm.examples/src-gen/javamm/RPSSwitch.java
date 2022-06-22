package javamm;

@SuppressWarnings("all")
public class RPSSwitch {
  /**
   * Example 3.11 of the book
   */
  public static int move(int p) {
    switch (p) {
      case 0:
        return 2;
      case 1:
        return 1;
      case 2:
        return 1;
      case 3:
        return 2;
      case 4:
        return 1;
      default:
        return -1;
    }
  }

  public static void main(String[] args) {
    System.out.println(RPSSwitch.move(2));
  }
}
