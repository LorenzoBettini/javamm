package javamm;

@SuppressWarnings("all")
public class NumberOfDigits {
  /**
   * Example 3.13 of the book
   */
  public static int digitNumber(int number) {
    int digitNumber = 1;
    while (((number / 10) > 0)) {
      {
        digitNumber = (digitNumber + 1);
        number = (number / 10);
      }
    }
    return digitNumber;
  }

  public static void main(String[] args) {
    System.out.println(NumberOfDigits.digitNumber(1234567));
  }
}
