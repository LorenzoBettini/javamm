package javamm;

@SuppressWarnings("all")
public class OperatorsBoolean {
  public static boolean mTrue() {
    System.out.println("mTrue called");
    return true;
  }

  public static boolean mFalse() {
    System.out.println("mFalse called");
    return false;
  }

  public static void main(String[] args) {
    String _plus = ("mFalse() && mTrue() = " + Boolean.valueOf((OperatorsBoolean.mFalse() && OperatorsBoolean.mTrue())));
    System.out.println(_plus);
    String _plus_1 = ("mTrue() || mFalse() = " + Boolean.valueOf((OperatorsBoolean.mTrue() || OperatorsBoolean.mFalse())));
    System.out.println(_plus_1);
    boolean _mFalse = OperatorsBoolean.mFalse();
    boolean _mTrue = OperatorsBoolean.mTrue();
    boolean _bitwiseAnd = (_mFalse & _mTrue);
    String _plus_2 = ("mFalse() & mTrue() = " + Boolean.valueOf(_bitwiseAnd));
    System.out.println(_plus_2);
    boolean _mTrue_1 = OperatorsBoolean.mTrue();
    boolean _mFalse_1 = OperatorsBoolean.mFalse();
    boolean _bitwiseOr = (_mTrue_1 | _mFalse_1);
    String _plus_3 = ("mTrue() | mFalse() = " + Boolean.valueOf(_bitwiseOr));
    System.out.println(_plus_3);
  }
}
