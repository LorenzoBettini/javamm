package javamm;

@SuppressWarnings("all")
public class GradeConversionSwitch {
  /**
   * Example 3.12 of the book
   */
  public static char convert(int grade) {
    char letter = 0;
    switch (grade) {
      case 30:
      case 29:
      case 28:
        letter = 'A';
        break;
      case 27:
      case 26:
      case 25:
        letter = 'B';
        break;
      case 24:
      case 23:
      case 22:
        letter = 'C';
        break;
      case 21:
      case 20:
      case 19:
      case 18:
        letter = 'D';
        break;
      default:
        letter = 'E';
    }
    return letter;
  }
  
  public static void main(String[] args) {
    char _convert = GradeConversionSwitch.convert(23);
    System.out.println(_convert);
  }
}
