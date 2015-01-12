package javamm;

@SuppressWarnings("all")
public class PrintArgs {
  public static void main(String[] args) {
    int _length = args.length;
    boolean _tripleEquals = (_length == 0);
    if (_tripleEquals) {
      System.out.println("No args");
    } else {
      int argsNum = args.length;
      {
        int i = 0;
        boolean _while = (i < argsNum);
        while (_while) {
          String _plus = ((("args[" + Integer.valueOf(i)) + "] = ") + args[i]);
          System.out.println(_plus);
          int _i = i;
          i = (_i + 1);
          _while = (i < argsNum);
        }
      }
    }
  }
}
