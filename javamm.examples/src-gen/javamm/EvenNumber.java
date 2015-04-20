package javamm;

@SuppressWarnings("all")
public class EvenNumber {
  public static void isEven(int n) {
    if (((n % 2) == 0)) {
      System.out.println((("Number " + Integer.valueOf(n)) + " is even."));
    }
  }
  
  public static void main(String[] args) {
    EvenNumber.isEven(10);
  }
}
