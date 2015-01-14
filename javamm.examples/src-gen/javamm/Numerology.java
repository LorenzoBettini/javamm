package javamm;

@SuppressWarnings("all")
public class Numerology {
  /**
   * Example 4.9 of the book
   */
  public static int digitSum(int number) {
    int result = 0;
    while ((number > 0)) {
      {
        int _result = result;
        result = (_result + (number % 10));
        number = (number / 10);
      }
    }
    return result;
  }
  
  public static int destiny(int number) {
    int temp = Numerology.digitSum(number);
    if ((number > 9)) {
      return Numerology.destiny(temp);
    } else {
      return temp;
    }
  }
  
  public static void main() {
    int number = 21061961;
    int _destiny = Numerology.destiny(number);
    String _plus = ("Destiny: " + Integer.valueOf(_destiny));
    System.out.println(_plus);
  }
  
  public static void main(String[] args) {
    Numerology.main();
  }
}
