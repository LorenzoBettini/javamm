@SuppressWarnings("all")
public class Loops {
  /**
   * Prints the passed array to the standard output using a for loop
   */
  public static void printArrayWithForLoop(final String[] a) {
    int i = 0;
    int _length = a.length;
    boolean _lessThan = (i < _length);
    boolean _while = _lessThan;
    while (_while) {
      System.out.println(((("args[" + Integer.valueOf(i)) + "] = ") + a[i]));
      int _i = i;
      i = (_i + 1);
      int _length_1 = a.length;
      boolean _lessThan_1 = (i < _length_1);
      _while = _lessThan_1;
    }
  }
  
  /**
   * Prints the passed array to the standard output using a while loop
   */
  public static void printArrayWithWhileLoop(final String[] a) {
    int i = 0;
    while ((i < a.length)) {
      {
        System.out.println(((("args[" + Integer.valueOf(i)) + "] = ") + a[i]));
        i = (i + 1);
      }
    }
  }
  
  /**
   * Prints the passed array to the standard output using a do..while loop
   */
  public static void printArrayWithDoWhileLoop(final String[] a) {
    int i = 0;
    int _length = a.length;
    boolean _greaterEqualsThan = (i >= _length);
    if (_greaterEqualsThan) {
      return;
    }
    do {
      {
        System.out.println(((("args[" + Integer.valueOf(i)) + "] = ") + a[i]));
        i = (i + 1);
      }
    } while((i < a.length));
  }
  
  public static void main(final String... args) {
    String[] a = { "one", "two", "three" };
    String[] empty = {};
    Loops.printArrayWithForLoop(empty);
    Loops.printArrayWithWhileLoop(empty);
    Loops.printArrayWithDoWhileLoop(empty);
    Loops.printArrayWithForLoop(a);
    Loops.printArrayWithWhileLoop(a);
    Loops.printArrayWithDoWhileLoop(a);
  }
}
