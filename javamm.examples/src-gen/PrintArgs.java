@SuppressWarnings("all")
public class PrintArgs {
  public static void main(final String... args) {
    int _length = args.length;
    boolean _equals = (_length == 0);
    if (_equals) {
      System.out.println("No args");
    } else {
      int argsNum = args.length;
      {
        int i = 0;
        boolean _while = (i < argsNum);
        while (_while) {
          System.out.println(((("args[" + Integer.valueOf(i)) + "] = ") + args[i]));
          int _i = i;
          i = (_i + 1);
          _while = (i < argsNum);
        }
      }
    }
  }
}
