package javamm;

@SuppressWarnings("all")
public class ModifyingArray {
  /**
   * Example 4.4 of the book
   */
  public static void doubleArray(int[] number) {
    for (int i = 0; (i < number.length); i++) {
      int _multiply = (number[i] * 2);
      number[i] = _multiply;
    }
  }
  
  public static void printArray(int[] number) {
    System.out.print("Array: ");
    for (int i = 0; (i < number.length); i++) {
      String _plus = (Integer.valueOf(number[i]) + " ");
      System.out.print(_plus);
    }
    System.out.println();
  }
  
  public static void main(String[] args) {
    int[] number = { 1, 2, 3, 4, 5 };
    ModifyingArray.printArray(number);
    ModifyingArray.doubleArray(number);
    ModifyingArray.printArray(number);
  }
}
