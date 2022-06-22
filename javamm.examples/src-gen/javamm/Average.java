package javamm;

@SuppressWarnings("all")
public class Average {
  /**
   * Computes the average of the numbers specified in the passed array.
   */
  public static double avg(int[] a) {
    double r = 0.0;
    for (int i = 0; (i < a.length); i++) {
      double _plus = (r + a[i]);
      r = _plus;
    }
    int _length = a.length;
    return (r / _length);
  }

  public static void main(String[] args) {
    int[] a = { 1, 2, 3, 4 };
    System.out.println(Average.avg(a));
  }
}
