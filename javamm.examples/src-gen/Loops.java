@SuppressWarnings("all")
public class Loops {
  /**
   * Prints the passed array to the standard output using a for loop
   */
  public static void printArrayWithForLoop(String[] a) {
    int i = 0;
    int _length = a.length;
    boolean _lessThan = (i < _length);
    boolean _while = _lessThan;
    while (_while) {
      String _plus = ((("args[" + Integer.valueOf(i)) + "] = ") + a[i]);
      System.out.println(_plus);
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
  public static void printArrayWithWhileLoop(String[] a) {
    int i = 0;
    while ((i < a.length)) {
      {
        String _plus = ((("args[" + Integer.valueOf(i)) + "] = ") + a[i]);
        System.out.println(_plus);
        i = (i + 1);
      }
    }
  }
  
  /**
   * Prints the passed array to the standard output using a do..while loop
   */
  public static void printArrayWithDoWhileLoop(String[] a) {
    int i = 0;
    int _length = a.length;
    boolean _greaterEqualsThan = (i >= _length);
    if (_greaterEqualsThan) {
      return;
    }
    do {
      {
        String _plus = ((("args[" + Integer.valueOf(i)) + "] = ") + a[i]);
        System.out.println(_plus);
        i = (i + 1);
      }
    } while((i < a.length));
  }
  
  public static void main(String[] args) {
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
