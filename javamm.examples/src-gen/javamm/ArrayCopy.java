package javamm;

@SuppressWarnings("all")
public class ArrayCopy {
  /**
   * @original the array to copy
   * @return a copy of the passed array
   */
  public static String[] copyArray(String[] original) {
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
  public static void printArray(String[] a) {
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
  
  public static void main(String[] args) {
    System.out.println("ORIGINAL: ");
    String[] a = { "one", "two", "three" };
    ArrayCopy.printArray(a);
    System.out.println("COPY: ");
    String[] _copyArray = ArrayCopy.copyArray(a);
    ArrayCopy.printArray(_copyArray);
  }
}
