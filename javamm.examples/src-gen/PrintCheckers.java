@SuppressWarnings("all")
public class PrintCheckers {
  /**
   * Prints a Checkers board
   */
  public static void printCheckers(char[][] d) {
    System.out.println("  +-+-+-+-+-+-+-+-+");
    int r = 0;
    int c = 0;
    for (r = 7; (r >= 0); r = (r - 1)) {
      {
        String _plus = (Integer.valueOf(r) + " |");
        System.out.print(_plus);
        for (c = 0; (c < 7); c = (c + 1)) {
          String _plus_1 = (Character.valueOf(d[r][c]) + "|");
          System.out.print(_plus_1);
        }
        String _plus_1 = (Character.valueOf(d[r][c]) + "|");
        System.out.println(_plus_1);
        System.out.println("  +-+-+-+-+-+-+-+-+");
      }
    }
    System.out.print("   ");
    for (c = 0; (c < 7); c = (c + 1)) {
      String _plus = (Integer.valueOf(c) + " ");
      System.out.print(_plus);
    }
    System.out.println(c);
  }
  
  public static void main(String[] args) {
    PrintCheckers.printCheckers(
      new char[][] { new char[] { '1', '2', '3', '4', '5', '6', '7', '8' }, new char[] { '1', '2', '3', '4', '5', '6', '7', '8' }, new char[] { '1', '2', '3', '4', '5', '6', '7', '8' }, new char[] { '1', '2', '3', '4', '5', '6', '7', '8' }, new char[] { '1', '2', '3', '4', '5', '6', '7', '8' }, new char[] { '1', '2', '3', '4', '5', '6', '7', '8' }, new char[] { '1', '2', '3', '4', '5', '6', '7', '8' }, new char[] { '1', '2', '3', '4', '5', '6', '7', '8' } });
  }
}
