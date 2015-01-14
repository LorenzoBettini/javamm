package javamm;

@SuppressWarnings("all")
public class OperatorsDouble {
  public static void main(String[] args) {
    double i = 3;
    double j = 5;
    double k = 5;
    double _i = i;
    i = (_i * 2);
    double _j = j;
    j = (_j % 2);
    double _k = k;
    k = (_k / 2);
    System.out.println(("i *= 2 = " + Double.valueOf(i)));
    System.out.println(("j %= 2 = " + Double.valueOf(j)));
    System.out.println(("k /= 2 = " + Double.valueOf(k)));
  }
}
