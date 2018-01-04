package javamm;

@SuppressWarnings("all")
public class ArrayToString {
  /**
   * Returns a string representation of the passed array.
   */
  public static String arrayToString(int[] a) {
    String buffer = "";
    for (int i = 0; (i < a.length); i++) {
      {
        if ((i > 0)) {
          String _buffer = buffer;
          buffer = (_buffer + ", ");
        }
        String _buffer_1 = buffer;
        buffer = (_buffer_1 + Integer.valueOf(a[i]));
      }
    }
    return buffer;
  }
  
  public static void main(String[] args) {
    System.out.println(ArrayToString.arrayToString(new int[] { 1, 2, 3 }));
  }
}
