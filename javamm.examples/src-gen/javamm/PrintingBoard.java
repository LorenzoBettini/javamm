package javamm;

@SuppressWarnings("all")
public class PrintingBoard {
  public static void printBoard(char[][] board) {
    System.out.println("  +-+-+-+-+-+-+-+-+");
    int row = 0;
    int column = 0;
    for (row = 7; (row >= 0); row = (row - 1)) {
      {
        String _plus = (Integer.valueOf(row) + " |");
        System.out.print(_plus);
        for (column = 0; (column < 7); column = (column + 1)) {
          String _plus_1 = (Character.valueOf(board[row][column]) + "|");
          System.out.print(_plus_1);
        }
        String _plus_1 = (Character.valueOf(board[row][column]) + "|");
        System.out.println(_plus_1);
        System.out.println("  +-+-+-+-+-+-+-+-+");
      }
    }
    System.out.print("   ");
    for (column = 0; (column < 7); column = (column + 1)) {
      String _plus = (Integer.valueOf(column) + " ");
      System.out.print(_plus);
    }
    System.out.println(column);
  }
  
  public static void main(String[] args) {
    char[][] board = { new char[] { 'n', '*', 'n', '*', 'n', '*', 'n', '*' }, new char[] { '*', 'n', '*', 'n', '*', 'n', '*', 'n' }, new char[] { 'n', '*', 'n', '*', 'n', '*', 'n', '*' }, new char[] { '*', ' ', '*', ' ', '*', ' ', '*', ' ' }, new char[] { ' ', '*', ' ', '*', ' ', '*', ' ', '*' }, new char[] { '*', 'b', '*', 'b', '*', 'b', '*', 'b' }, new char[] { 'b', '*', 'b', '*', 'b', '*', 'b', '*' }, new char[] { '*', 'b', '*', 'b', '*', 'b', '*', 'b' } };
    PrintingBoard.printBoard(board);
  }
}
