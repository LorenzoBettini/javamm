package javamm;

@SuppressWarnings("all")
public class EqualArrays {
  /**
   * Example 4.3 of the book
   */
  public static boolean equalArray(int[] a, int[] b) {
    int _length = a.length;
    int _length_1 = b.length;
    boolean _tripleNotEquals = (_length != _length_1);
    if (_tripleNotEquals) {
      return false;
    }
    for (int i = 0; (i < a.length); i++) {
      boolean _tripleNotEquals_1 = (a[i] != b[i]);
      if (_tripleNotEquals_1) {
        return false;
      }
    }
    return true;
  }
  
  public static void main(String[] args) {
    int[] a1 = { 0, 1, 2 };
    int[] a2 = { 0, 1, 2 };
    int[] a3 = { 0, 2, 1 };
    int[] a4 = { 0, 1 };
    boolean _equalArray = EqualArrays.equalArray(a1, a2);
    String _plus = ("a1=a2: " + Boolean.valueOf(_equalArray));
    System.out.println(_plus);
    boolean _equalArray_1 = EqualArrays.equalArray(a1, a3);
    String _plus_1 = ("a1=a3: " + Boolean.valueOf(_equalArray_1));
    System.out.println(_plus_1);
    boolean _equalArray_2 = EqualArrays.equalArray(a1, a4);
    String _plus_2 = ("a1=a4: " + Boolean.valueOf(_equalArray_2));
    System.out.println(_plus_2);
  }
}
