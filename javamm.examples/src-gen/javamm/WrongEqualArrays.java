package javamm;

@SuppressWarnings("all")
public class WrongEqualArrays {
  public static void main(String[] args) {
    int[] a1 = { 0, 0, 0 };
    int[] a2 = { 0, 0, 0 };
    boolean equalArray = (a1 == a2);
    System.out.println(("a1=a2: " + Boolean.valueOf(equalArray)));
  }
}
