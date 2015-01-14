package javamm;

@SuppressWarnings("all")
public class OperatorsInteger {
  public static void main(String[] args) {
    int i = 3;
    int j = 5;
    int k = 5;
    int _i = i;
    i = (_i * 2);
    int _j = j;
    j = (_j % 2);
    int _k = k;
    k = (_k / 2);
    System.out.println(("i *= 2 = " + Integer.valueOf(i)));
    System.out.println(("j %= 2 = " + Integer.valueOf(j)));
    System.out.println(("k /= 2 = " + Integer.valueOf(k)));
  }
}
