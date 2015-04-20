package javamm;

@SuppressWarnings("all")
public class Sudoku {
  public static int[] nextCell(int[] c, int[][] s) {
    for (int j = (c[1] + 1); (j < s.length); j++) {
      boolean _tripleEquals = (s[c[0]][j] == 0);
      if (_tripleEquals) {
        return new int[] { c[0], j };
      }
    }
    for (int i = (c[0] + 1); (i < s.length); i++) {
      for (int j = 0; (j < s.length); j++) {
        boolean _tripleEquals = (s[i][j] == 0);
        if (_tripleEquals) {
          return new int[] { i, j };
        }
      }
    }
    return new int[] { (-1), (-1) };
  }
  
  public static boolean feasible(int d, int[] c, int n, int[][] s) {
    for (int i = 0; (i < (n * n)); i++) {
      boolean _tripleEquals = (s[c[0]][i] == d);
      if (_tripleEquals) {
        return false;
      }
    }
    for (int i = 0; (i < (n * n)); i++) {
      boolean _tripleEquals = (s[i][c[1]] == d);
      if (_tripleEquals) {
        return false;
      }
    }
    int _divide = (c[0] / n);
    int fr = (_divide * n);
    int _divide_1 = (c[1] / n);
    int fc = (_divide_1 * n);
    for (int i = fr; (i < (fr + n)); i++) {
      for (int j = fc; (j < (fc + n)); j++) {
        boolean _tripleEquals = (s[i][j] == d);
        if (_tripleEquals) {
          return false;
        }
      }
    }
    return true;
  }
  
  public static boolean[] feasibleDigits(int[] c, int n, int[][] s) {
    boolean[] r = new boolean[(n * n)];
    for (int d = 1; (d <= (n * n)); d++) {
      boolean _feasible = Sudoku.feasible(d, c, n, s);
      r[(d - 1)] = _feasible;
    }
    return r;
  }
  
  public static boolean solvable(int[] c, int n, int[][] s) {
    boolean[] a = Sudoku.feasibleDigits(c, n, s);
    for (int d = 1; (d <= (n * n)); d++) {
      if (a[(d - 1)]) {
        s[c[0]][c[1]] = d;
        int[] nc = Sudoku.nextCell(c, s);
        boolean _and = false;
        boolean _greaterEqualsThan = (nc[0] >= 0);
        if (!_greaterEqualsThan) {
          _and = false;
        } else {
          boolean _solvable = Sudoku.solvable(nc, n, s);
          boolean _not = (!_solvable);
          _and = _not;
        }
        if (_and) {
          s[c[0]][c[1]] = 0;
        } else {
          return true;
        }
      }
    }
    return false;
  }
  
  public static void main() {
    int[][] s = { new int[] { 4, 0, 0, 0 }, new int[] { 0, 0, 0, 3 }, new int[] { 0, 1, 3, 0 }, new int[] { 0, 0, 0, 2 } };
    int n = 2;
    Sudoku.printBoard(s);
    int[] p = Sudoku.nextCell(new int[] { 0, (-1) }, s);
    boolean _solvable = Sudoku.solvable(p, n, s);
    System.out.println(_solvable);
    Sudoku.printBoard(s);
  }
  
  public static void printBoard(int[][] s) {
    for (int i = 0; (i < s.length); i++) {
      {
        for (int j = 0; (j < s.length); j++) {
          String _plus = (Integer.valueOf(s[i][j]) + " ");
          System.out.print(_plus);
        }
        System.out.println();
      }
    }
  }
  
  public static void main(String[] args) {
    Sudoku.main();
  }
}
