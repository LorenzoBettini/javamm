package javamm;

@SuppressWarnings("all")
public class Factorization {
  /**
   * Example 4.7 of the book
   */
  public static int firstFactor(int n) {
    for (int i = 2; (i <= (n / 2)); i++) {
      if (((n % i) == 0)) {
        return i;
      }
    }
    return n;
  }

  public static void main() {
    int number = 750;
    int factor = 0;
    System.out.println(("Number: " + Integer.valueOf(number)));
    int _firstFactor = Factorization.firstFactor(number);
    boolean _tripleEquals = (_firstFactor == number);
    if (_tripleEquals) {
      System.out.println(("Factor: " + Integer.valueOf(number)));
    } else {
      while ((number > 1)) {
        {
          factor = Factorization.firstFactor(number);
          System.out.println(("Factor: " + Integer.valueOf(factor)));
          number = (number / factor);
        }
      }
    }
  }

  public static void main(String[] args) {
    Factorization.main();
  }
}
