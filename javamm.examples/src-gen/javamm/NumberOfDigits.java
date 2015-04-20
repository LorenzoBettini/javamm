package javamm;

@SuppressWarnings("all")
public class NumberOfDigits {
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
    int _digitNumber = NumberOfDigits.digitNumber(1234567);
    System.out.println(_digitNumber);
  }
}
