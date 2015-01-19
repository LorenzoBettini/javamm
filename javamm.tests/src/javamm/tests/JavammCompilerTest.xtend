package javamm.tests

import com.google.common.base.Joiner
import com.google.inject.Inject
import java.io.ByteArrayOutputStream
import java.io.PrintStream
import javamm.JavammInjectorProvider
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.TemporaryFolder
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(JavammInjectorProvider))
class JavammCompilerTest extends JavammAbstractTest {

	@Rule @Inject public TemporaryFolder temporaryFolder
	@Inject extension CompilationTestHelper

	@Test def void testEmptyProgram() {
		"".checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
  }
}
'''
		)
	}

	@Test def void testHelloWorld() {
		helloWorld.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    System.out.println("Hello world!");
  }
}
'''
			)
	}

	@Test def void testMethodJavadoc() {
		'''
		/**
		 * Prints a string to the standard output
		 */
		void sayHelloWorld(String m) {
			System.out.println(m);
		}
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  /**
   * Prints a string to the standard output
   */
  public static void sayHelloWorld(String m) {
    System.out.println(m);
  }
  
  public static void main(String[] args) {
  }
}
'''
			)
	}

	@Test def void testHelloWorldMethod() {
		helloWorldMethod.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void sayHelloWorld(String m) {
    System.out.println(m);
  }
  
  public static void main(String[] args) {
    MyFile.sayHelloWorld("Hello world!");
  }
}
'''
			)
	}

	@Test def void testJavaLikeVariableDeclarations() {
		javaLikeVariableDeclarations.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static boolean foo() {
    int i = 0;
    int j = 0;
    j = 1;
    return (i > 0);
  }
  
  public static void main(String[] args) {
    int i = 0;
    boolean b = false;
    boolean cond = (i > 0);
  }
}
'''
			)
	}

	@Test def void testSimpleAccess() {
		'''
		int i;
		i = 0;
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 0;
    i = 0;
  }
}
'''
			)
	}

	@Test def void testSimpleArrayAccess() {
		simpleArrayAccess.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    String[] a = null;
    a[0] = "test";
  }
}
'''
			)
	}

	@Test def void testArrayAccess() {
		arrayAccess.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static int getIndex() {
    return 0;
  }
  
  public static void main(String[] args) {
    String[] a = null;
    int i = 0;
    int j = 1;
    a[(i + j)] = "test";
    a[((i - MyFile.getIndex()) + 1)] = "test";
  }
}
'''
			)
	}

	@Test def void testArrayAssign() {
		arrayAssign.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    String[] a = null;
    String[] b = null;
    a = b;
  }
}
'''
			)
	}

	@Test def void testArrayAssignElementFinalParameter() {
		arrayAssignElementFinalParameter.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void m(int[] a) {
    a[0] = 1;
  }
  
  public static void main(String[] args) {
  }
}
'''
			)
	}

	@Test def void testArrayAccessInRightHandsideExpression() {
		arrayAccessInRightHandsideExpression.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[] a = null;
    int i = 0;
    i = a[0];
  }
}
'''
			)
	}

	@Test def void testArrayAccessFromFeatureCall() {
		arrayAccessFromFeatureCall.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static int[] getArray() {
    return null;
  }
  
  public static void main(String[] args) {
    int i = 0;
    i = MyFile.getArray()[0];
  }
}
'''
			)
	}

	@Test def void testArrayAccessFromMemberFeatureCallReceiver() {
		arrayAccessFromMemberFeatureCallReceiver.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[][] arr = null;
    int l = 0;
    int _length = arr[0].length;
    l = _length;
    boolean _equals = arr[0].equals(arr[1]);
    System.out.println(_equals);
    int _hashCode = arr[0].hashCode();
    System.out.println(_hashCode);
  }
}
'''
			)
	}

	@Test def void testArrayAccessAsArgument() {
		arrayAccessAsArgument.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static int getArg(int i) {
    return i;
  }
  
  public static void main(String[] args) {
    int[] j = null;
    MyFile.getArg(j[0]);
  }
}
'''
			)
	}

	@Test def void testArrayAccessInForLoop() {
		arrayAccessInForLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
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
'''
			)
	}

	@Test def void testArrayAccessInBinaryOp() {
		arrayAccessInBinaryOp.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[] a = null;
    boolean result = (a[1] > a[2]);
  }
}
'''
			)
	}

	@Test def void testArrayAccessInParenthesizedExpression() {
		arrayAccessInParenthesizedExpression.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[] a = null;
    int i = 0;
    i = a[1];
  }
}
'''
			)
	}

	@Test def void testMultiArrayAccessInRightHandsideExpression() {
		multiArrayAccessInRightHandsideExpression.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[][] a = null;
    int i = 0;
    i = a[0][(1 + 2)];
  }
}
'''
			)
	}

	@Test def void testMultiArrayAccessInLeftHandsideExpression() {
		multiArrayAccessInLeftHandsideExpression.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[][] a = null;
    int[][] b = null;
    a[0][(1 + 2)] = 1;
    a[0] = b[1];
    a = b;
  }
}
'''
			)
	}

	@Test def void testArrayConstructorCallInVarDecl() {
		arrayConstructorCallInVarDecl.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[] i = new int[10];
    String[] a = new String[args.length];
  }
}
'''
			)
	}

	@Test def void testMultiArrayConstructorCallInVarDecl() {
		multiArrayConstructorCallInVarDecl.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[][] i = new int[10][20];
    String[][] a = new String[args.length][(args.length + 1)];
  }
}
'''
			)
	}

	@Test def void testMultiArrayConstructorCallWithPartialDimensions() {
		'''
		int[][][] a1 = new int[0][][];
		int[][][] a2 = new int[0][1][];
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[][][] a1 = new int[0][][];
    int[][][] a2 = new int[0][1][];
  }
}
'''
			)
	}

	@Test def void testMultiArrayConstructorCallWithArrayLiteral() {
		multiArrayConstructorCallWithArrayLiteral.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[] i = new int[] { 0, 1, 2 };
    int[][] j = new int[][] { new int[] { 0, 1, 2 }, new int[] { 3, 4, 5 } };
  }
}
'''
			)
	}

	@Test def void testIfThenElseWithoutBlocks() {
		ifThenElseWithoutBlocks.expectationsForIfThenElse
	}

	@Test def void testIfThenElseWithBlocks() {
		ifThenElseWithBlocks.expectationsForIfThenElse
	}
	
	/**
	 * Xbase compiles if then else with blocks even if they're not
	 * there in the original program
	 */
	private def expectationsForIfThenElse(CharSequence input) {
		input.checkCompilation(
			'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int _length = args.length;
    boolean _tripleEquals = (_length == 0);
    if (_tripleEquals) {
      System.out.println("No args");
    } else {
      System.out.println("Args");
    }
  }
}
			'''
		)
	}

	@Test def void testArrayLiteral() {
		arrayLiteral.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[] a = { 0, 1, 2 };
  }
}
'''
			)
	}

	@Test def void testEmptyArrayLiteral() {
		emptyArrayLiteral.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int[] a = {};
  }
}
'''
			)
	}

	@Test def void testWhileWithoutBlock() {
		whileWithoutBlock.expectationsForWhile
	}

	@Test def void testWhileWithBlock() {
		whileWithBlock.expectationsForWhile
	}

	/**
	 * Xbase compiles if while with blocks even if they're not
	 * there in the original program
	 */
	private def expectationsForWhile(CharSequence input) {
		input.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 0;
    while ((i < 10)) {
      i = (i + 1);
    }
  }
}
'''

		)
	}

	@Test def void testDoWhileWithoutBlock() {
		doWhileWithoutBlock.expectationsForDoWhile
	}

	@Test def void testDoWhileWithBlock() {
		doWhileWithBlock.expectationsForDoWhile
	}

	/**
	 * Xbase compiles if while with blocks even if they're not
	 * there in the original program
	 */
	private def expectationsForDoWhile(CharSequence input) {
		input.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 0;
    do {
      i = (i + 1);
    } while((i < 10));
  }
}
'''

		)
	}

	@Test def void testAdditionalSemicolons() {
		additionalSemicolons.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void m() {
    return;
  }
  
  public static void main(String[] args) {
    int i = 0;
    while ((i < 10)) {
      i = (i + 1);
    }
  }
}
'''
			)
	}

	@Test def void testAssignToParam() {
		assignToParam.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void m(int a) {
    a = 1;
  }
  
  public static void main(String[] args) {
  }
}
'''
			)
	}

	@Test def void testPostIncrement() {
		postIncrement.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 0;
    int j = i++;
    j++;
  }
}
'''
			)
	}

	@Test def void testPreIncrementAndDecrement() {
		preIncrementAndDecrement.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 0;
    int j = ++i;
    int _plusPlus = ++i;
    j = _plusPlus;
    ++j;
    int k = --i;
    int _minusMinus = --i;
    k = _minusMinus;
    --k;
  }
}
'''
			)
	}

	@Test def void testMultiAssign() {
		multiAssign.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 0;
    int _i = i;
    i = (_i + 2);
  }
}
'''
			)
	}

	@Test def void testForLoopTranslatedToJavaWhileSingleStatement() {
		forLoopTranslatedToJavaWhileSingleStatement.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        System.out.println(("" + Integer.valueOf(i)));
        int _i = i;
        i = (_i + 1);
        _while = (i < argsNum);
      }
    }
  }
}
'''
			)
	}

	@Test def void testForLoopTranslatedToJavaWhileInsideIf() {
		forLoopTranslatedToJavaWhileInsideIf.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    if ((argsNum != 0)) {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        System.out.println(("" + Integer.valueOf(i)));
        int _i = i;
        i = (_i + 1);
        _while = (i < argsNum);
      }
    }
  }
}
'''
			)
	}

	@Test def void testForLoopTranslatedToJavaWhileNoExpression() {
		forLoopTranslatedToJavaWhileNoExpression.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = true;
      while (_while) {
        System.out.println(("" + Integer.valueOf(i)));
        int _i = i;
        i = (_i + 1);
        _while = true;
      }
    }
  }
}
'''
			)
	}

	@Test def void testForLoopTranslatedToJavaWhileEarlyExit() {
		forLoopTranslatedToJavaWhileEarlyExit.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        return;
      }
    }
  }
}
''', false 
			)
		/** 
		 * this is not valid input since i += 1 is considered not reachable
		 * we use it only to test the compiler
		 */
	}

	@Test def void testContinueInForLoopTranslatedToJavaFor() {
		continueInForLoopTranslatedToJavaFor.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    for (int i = 0; (i < argsNum); i++) {
      if ((argsNum > 0)) {
        continue;
      } else {
        System.out.println("");
      }
    }
  }
}
'''
			)
	}

	@Test def void testContinueInForLoopTranslatedToJavaWhile() {
		continueInForLoopTranslatedToJavaWhile.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        if ((argsNum > 0)) {
          int _i = i;
          i = (_i + 1);
          _while = (i < argsNum);
          continue;
        } else {
          System.out.println("");
        }
        int _i_1 = i;
        i = (_i_1 + 1);
        _while = (i < argsNum);
      }
    }
  }
}
'''
			)
	}

	@Test def void testContinueInForLoopTranslatedToJavaWhileNoExpression() {
		continueInForLoopTranslatedToJavaWhileNoExpression.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = true;
      while (_while) {
        if ((argsNum > 0)) {
          int _i = i;
          i = (_i + 1);
          _while = true;
          continue;
        } else {
          System.out.println("");
        }
        int _i_1 = i;
        i = (_i_1 + 1);
        _while = true;
      }
    }
  }
}
'''
			)
	}

	@Test def void testContinueInBothIfBranchesInForLoopTranslatedToJavaWhile() {
		continueInBothIfBranchesInForLoopTranslatedToJavaWhile.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        if ((argsNum > 0)) {
          int _i = i;
          i = (_i + 1);
          _while = (i < argsNum);
          continue;
        } else {
          int _i_1 = i;
          i = (_i_1 + 1);
          _while = (i < argsNum);
          continue;
        }
      }
    }
  }
}
'''
			)
	}

	@Test def void testContinueSingleInForLoopTranslatedToJavaWhile() {
		continueSingleInForLoopTranslatedToJavaWhile.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        int _i = i;
        i = (_i + 1);
        _while = (i < argsNum);
        continue;
      }
    }
  }
}
'''
			)
	}

	@Test def void testContinueInForLoopTranslatedToJavaWhileAndOtherStatementsAfterLoop() {
		continueInForLoopTranslatedToJavaWhileAndOtherStatementsAfterLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        if ((argsNum > 0)) {
          int _i = i;
          i = (_i + 1);
          _while = (i < argsNum);
          continue;
        } else {
          System.out.println("");
        }
        int _i_1 = i;
        i = (_i_1 + 1);
        _while = (i < argsNum);
      }
    }
    int j = 0;
    System.out.println(j);
  }
}
'''
			)
	}

	@Test def void testContinueInWhileLoop() {
		continueInWhileLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    while ((i < argsNum)) {
      if ((argsNum > 0)) {
        continue;
      } else {
        System.out.println("");
      }
    }
  }
}
'''
			)
	}

	@Test def void testContinueInBothIfBranchesInWhileLoop() {
		continueInBothIfBranchesInWhileLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    while ((i < argsNum)) {
      if ((argsNum > 0)) {
        continue;
      } else {
        continue;
      }
    }
  }
}
'''
			)
	}

	@Test def void testContinueInDoWhileLoop() {
		continueInDoWhileLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    do {
      if ((argsNum > 0)) {
        continue;
      } else {
        System.out.println("");
      }
    } while((i < argsNum));
  }
}
'''
			)
	}

	@Test def void testContinueInBothIfBranchesInDoWhileLoop() {
		continueInBothIfBranchesInDoWhileLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    do {
      if ((argsNum > 0)) {
        continue;
      } else {
        continue;
      }
    } while((i < argsNum));
  }
}
'''
			)
	}

	@Test def void testBreakInForLoopTranslatedToJavaFor() {
		breakInForLoopTranslatedToJavaFor.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    for (int i = 0; (i < argsNum); i++) {
      if ((argsNum > 0)) {
        break;
      } else {
        System.out.println("");
      }
    }
  }
}
'''
			)
	}

	@Test def void testBreakInForLoopTranslatedToJavaWhile() {
		breakInForLoopTranslatedToJavaWhile.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        if ((argsNum > 0)) {
          break;
        } else {
          System.out.println("");
        }
        int _i = i;
        i = (_i + 1);
        _while = (i < argsNum);
      }
    }
  }
}
'''
			)
	}

	@Test def void testBreakInBothIfBranchesInForLoopTranslatedToJavaWhile() {
		breakInBothIfBranchesInForLoopTranslatedToJavaWhile.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        if ((argsNum > 0)) {
          break;
        } else {
          break;
        }
      }
    }
  }
}
'''
			)
	}

	@Test def void testBreakSingleInForLoopTranslatedToJavaWhile() {
		breakSingleInForLoopTranslatedToJavaWhile.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    {
      int i = 0;
      boolean _while = (i < argsNum);
      while (_while) {
        break;
      }
    }
  }
}
'''
			)
	}

	@Test def void testBreakInWhileLoop() {
		breakInWhileLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    while ((i < argsNum)) {
      if ((argsNum > 0)) {
        break;
      } else {
        System.out.println("");
      }
    }
  }
}
'''
			)
	}

	@Test def void testBreakInBothIfBranchesInWhileLoop() {
		breakInBothIfBranchesInWhileLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    while ((i < argsNum)) {
      if ((argsNum > 0)) {
        break;
      } else {
        break;
      }
    }
  }
}
'''
			)
	}

	@Test def void testBreakInDoWhileLoop() {
		breakInDoWhileLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    do {
      if ((argsNum > 0)) {
        break;
      } else {
        System.out.println("");
      }
    } while((i < argsNum));
  }
}
'''
			)
	}

	@Test def void testBreakInBothIfBranchesInDoWhileLoop() {
		breakInBothIfBranchesInDoWhileLoop.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    do {
      if ((argsNum > 0)) {
        break;
      } else {
        break;
      }
    } while((i < argsNum));
  }
}
'''
			)
	}

	@Test def void testEmptySwitchStatement() {
		emptySwitchStatement.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    switch (argsNum) {
    }
  }
}
'''
			)
	}

	@Test def void testSwitchStatementWithCaseAndDefault() {
		switchStatementWithCaseAndDefault.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    switch (argsNum) {
      case 0:
        System.out.println("0");
      default:
        System.out.println("default");
    }
  }
}
'''
			)
	}

	@Test def void testSwitchStatementWithCaseAndDefaultMultipleStatements() {
		switchStatementWithCaseAndDefaultMultipleStatements.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    switch (argsNum) {
      case 0:
        i = 0;
        System.out.println("0");
      default:
        {
          i = (-1);
          System.out.println("default");
        }
    }
  }
}
'''
			)
	}

	@Test def void testSwitchStatementWithBreak() {
		switchStatementWithBreak.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    int i = 0;
    switch (argsNum) {
      case 0:
        i = 0;
        System.out.println("0");
        break;
      default:
        {
          i = (-1);
          System.out.println("default");
          break;
        }
    }
  }
}
'''
			)
	}

	/**
	 * This would work only for Java 1.7 so for the moment we'll not deal with that
	 */
	// @Test
	def void testSwitchStatementWithStrings() {
		switchStatementWithStrings.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    String arg = args[0];
    int i = 0;
    switch (arg) {
      case "first":
        i = 0;
        System.out.println("0");
        break;
      default:
        {
          i = (-1);
          System.out.println("default");
          break;
        }
    }
  }
}
'''
			)
	}

	@Test def void testSwitchStatementWithChars() {
		switchStatementWithChars.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int argsNum = args.length;
    String firstArg = args[0];
    char arg = firstArg.toCharArray()[0];
    int i = 0;
    switch (arg) {
      case 'f':
        i = 0;
        System.out.println("0");
        break;
      default:
        {
          i = (-1);
          System.out.println("default");
          break;
        }
    }
  }
}
'''
			)
	}

	@Test def void testSwitchStatementWithBytes() {
		switchStatementWithBytes.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    byte b = 0;
    switch (b) {
      case 10:
        System.out.println("10");
      case 'f':
        System.out.println("f");
        break;
      default:
        {
          System.out.println("default");
          break;
        }
    }
  }
}
'''
			)
	}

	@Test def void testVarNameSameAsMethodName() {
		varNameSameAsMethodName.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static int numOfDigits(int num) {
    int numOfDigits = 1;
    while (((num / 10) > 0)) {
      {
        numOfDigits = (numOfDigits + 1);
        num = (num / 10);
      }
    }
    return numOfDigits;
  }
  
  public static void main(String[] args) {
    int _numOfDigits = MyFile.numOfDigits(3456);
    String _plus = ("numOfDigits(3456): " + Integer.valueOf(_numOfDigits));
    System.out.println(_plus);
  }
}
'''
			)
	}

	@Test def void testCharTranslatedToJavaChar() {
		'''
		char c1 = 'c';
		char c2 = '\n';
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    char c1 = 'c';
    char c2 = '\n';
  }
}
'''
			)
	}

	@Test def void testEqualsTranslation() {
		'''
		boolean b;
		b = 1 == 2;
		b = 1 != 2;
		b = "a" == "b";
		b = "a" != "b";
		
		String a = new String("a");
		System.out.println("a" == "a"); // true
		System.out.println(a == "a"); // false
		System.out.println("a".equals("a")); // true
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    boolean b = false;
    b = (1 == 2);
    b = (1 != 2);
    boolean _tripleEquals = ("a" == "b");
    b = _tripleEquals;
    boolean _tripleNotEquals = ("a" != "b");
    b = _tripleNotEquals;
    String a = new String("a");
    boolean _tripleEquals_1 = ("a" == "a");
    System.out.println(_tripleEquals_1);
    boolean _tripleEquals_2 = (a == "a");
    System.out.println(_tripleEquals_2);
    boolean _equals = "a".equals("a");
    System.out.println(_equals);
  }
}
'''
			)
	}

	@Test def void testSeveralVariableDeclarations() {
		'''
		int i, j = 1, k;
		System.out.println(i);
		System.out.println(j);
		System.out.println(k);
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 0;
    int j = 1;
    int k = 0;
    System.out.println(i);
    System.out.println(j);
    System.out.println(k);
  }
}
'''
			)
	}

	@Test def void testSeveralVariableDeclarationsInForLoop() {
		'''
		for (int i, j = 1, k; i < 0; i++) {
			System.out.println(i);
			System.out.println(j);
			System.out.println(k);
		}
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    for (int i = 0, j = 1, k = 0; (i < 0); i++) {
      {
        System.out.println(i);
        System.out.println(j);
        System.out.println(k);
      }
    }
  }
}
'''
			)
	}

	@Test def void testSeveralVariableDeclarationsInForLoopTranslatedToJavaWhile() {
		'''
		for (int i, j = 1, k; i < 0; i += 1) {
			System.out.println(i);
			System.out.println(j);
			System.out.println(k);
		}
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 0;
    int j = 1;
    int k = 0;
    boolean _while = (i < 0);
    while (_while) {
      {
        System.out.println(i);
        System.out.println(j);
        System.out.println(k);
      }
      int _i = i;
      i = (_i + 1);
      _while = (i < 0);
    }
  }
}
'''
			)
	}

	@Test def void testSeveralAssignmentsInForLoop() {
		'''
		int i;
		int j;
		int k;
		for (i = 0, j = 1, k = 1; i < 0; i++) {
			System.out.println(i);
			System.out.println(j);
			System.out.println(k);
		}
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 0;
    int j = 0;
    int k = 0;
    for (i = 0, j = 1, k = 1; (i < 0); i++) {
      {
        System.out.println(i);
        System.out.println(j);
        System.out.println(k);
      }
    }
  }
}
'''
			)
	}

	@Test def void testSpecialOperators() {
		'''
		int i = 2;
		int j = 3;
		int k = 4;
		
		i *= j;
		i /= j;
		i %= j;
		'''.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    int i = 2;
    int j = 3;
    int k = 4;
    int _i = i;
    i = (_i * j);
    int _i_1 = i;
    i = (_i_1 / j);
    int _i_2 = i;
    i = (_i_2 % j);
  }
}
'''
			)
	}

	@Test def void testNumberLiterals() {
		numberLiterals.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    byte b = 100;
    short s = 1000;
    char c = 1000;
  }
}
'''
		)
	}

	@Test def void testCharLiterals() {
		charLiterals.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void main(String[] args) {
    byte b = 'c';
    short s = 'c';
    char c = 'c';
    int i = 'c';
    long l = 'c';
    double d = 'c';
    float f = 'c';
  }
}
'''
		)
	}

	@Test def void testBubbleSort() {
		bubbleSort.checkCompilation(
'''
package javamm;

@SuppressWarnings("all")
public class MyFile {
  public static void bubbleSort(int[] array) {
    boolean swapped = true;
    int j = 0;
    int tmp = 0;
    while (swapped) {
      {
        swapped = false;
        j = (j + 1);
        for (int i = 0; (i < (array.length - j)); i++) {
          boolean _greaterThan = (array[i] > array[(i + 1)]);
          if (_greaterThan) {
            tmp = array[i];
            array[i] = array[(i + 1)];
            array[(i + 1)] = tmp;
            swapped = true;
          }
        }
      }
    }
  }
  
  public static void main(String[] args) {
  }
}
'''
			)
	}

	@Test def void testSudoku() {
		sudoku.assertExecuteMain(
'''
4 0 0 0 
0 0 0 3 
0 1 3 0 
0 0 0 2 
true
4 3 2 1 
1 2 4 3 
2 1 3 4 
3 4 1 2 
'''
		)
	}

	def private checkCompilation(CharSequence input, CharSequence expectedGeneratedJava) {
		checkCompilation(input, expectedGeneratedJava, true)
	}

	def private checkCompilation(CharSequence input, CharSequence expectedGeneratedJava, boolean checkValidationErrors) {
		input.compile[
			if (checkValidationErrors) {
				assertNoValidationErrors
			}
			
			if (expectedGeneratedJava != null) {
				assertGeneratedJavaCode(expectedGeneratedJava)
			}
			assertGeneratedJavaCodeCompiles
		]
	}
	
	private def assertNoValidationErrors(Result it) {
		val allErrors = getErrorsAndWarnings.filter[severity == Severity.ERROR]
		if (!allErrors.empty) {
			throw new IllegalStateException("One or more resources contained errors : "+
				Joiner.on(',').join(allErrors)
			);
		}
	}

	def private assertGeneratedJavaCode(CompilationTestHelper.Result r, CharSequence expected) {
		expected.toString.assertEquals(r.singleGeneratedCode)
	}

	def private assertGeneratedJavaCodeCompiles(CompilationTestHelper.Result r) {
		r.compiledClass // check Java compilation succeeds
	}

	/**
	 * Assumes that the generated Java code has a method testMe to call
	 * and asserts what the run program prints on standard output.
	 */
	def private assertExecuteMain(CharSequence file, CharSequence expectedOutput) {
		val classes = <Class<?>>newArrayList()
		file.compile[
			classes += compiledClass
		]
		val clazz = classes.head
		val out = new ByteArrayOutputStream()
		val backup = System.out
		System.setOut(new PrintStream(out))
		try {
			val instance = clazz.newInstance
			clazz.declaredMethods.findFirst[name == 'testMe'] => [
				accessible = true
				invoke(instance, null) // just to pass an argument	
			]
		} finally {
			System.setOut(backup)
		}
		assertEquals(expectedOutput.toString, out.toString)
	} 
}
