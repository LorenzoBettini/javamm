@SuppressWarnings("all")
public class ArrayCopy {
  /**
   * @original the array to copy
   * @return a copy of the passed array
   */
  public static String[] copyArray(final String[] original) {
    String[] copy = new String[original.length];
    {
      int i = 0;
      int _length = original.length;
      boolean _lessThan = (i < _length);
      boolean _while = _lessThan;
      while (_while) {
        copy[i] = original[i];
        int _i = i;
        i = (_i + 1);
        int _length_1 = original.length;
        boolean _lessThan_1 = (i < _length_1);
        _while = _lessThan_1;
      }
    }
    return copy;
  }
  
  /**
   * Prints the passed array to the standard output
   */
  public static void printArray(final String[] a) {
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
  
  public static void main(final String... args) {
    System.out.println("ORIGINAL: ");
    ArrayCopy.printArray(args);
    System.out.println("COPY: ");
    String[] _copyArray = ArrayCopy.copyArray(args);
    ArrayCopy.printArray(_copyArray);
  }
}
