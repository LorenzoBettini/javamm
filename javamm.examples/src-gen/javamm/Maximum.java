package javamm;

@SuppressWarnings("all")
public class Maximum {
  public static int max(int[] number) {
    int max = number[0];
    for (int i = 1; (i < number.length); i = (i + 1)) {
      boolean _lessThan = (max < number[i]);
      if (_lessThan) {
        max = number[i];
      }
    }
    return max;
  }
  
  public static void main(String[] args) {
    int[] a = { 2, 4, 7, 12, 1, 9 };
    int _max = Maximum.max(a);
    System.out.println(_max);
  }
}
