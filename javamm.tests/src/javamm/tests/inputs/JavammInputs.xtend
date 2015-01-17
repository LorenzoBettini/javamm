package javamm.tests.inputs

class JavammInputs {

	def helloWorld() {
		'''
		System.out.println("Hello world!");
		'''
	}

	def helloWorldMethod() {
		'''
		void sayHelloWorld(String m) {
			System.out.println(m);
		}
		
		sayHelloWorld("Hello world!");
		'''
	}

	def javaLikeVariableDeclarations() {
		'''
		boolean foo() {
			int i = 0;
			int j;
			j = 1;
			return (i > 0);
		}
		
		int i = 0;
		boolean b = false;
		boolean cond = (i > 0);
		'''
	}

	def simpleArrayAccess() {
		'''
		String[] a;
		a[0] = "test";
		'''
	}

	def arrayAccess() {
		'''
		int getIndex() {
			return 0;
		}
		
		String[] a;
		int i = 0;
		int j = 1;
		a[i+j] = "test";
		a[i-getIndex()+1] = "test";
		'''
	}

	def arrayAssign() {
		'''
		String[] a;
		String[] b;
		a = b;
		'''
	}

	def arrayAssignElementFinalParameter() {
		'''
		void m(int[] a) {
			a[0] = 1;
		}
		'''
	}

	def arrayAccessInRightHandsideExpression() {
		'''
		int[] a;
		int i;
		i = a[0];
		'''
	}

	def arrayAccessFromFeatureCall() {
		'''
		int[] getArray() {
			return null;
		}
		
		int i;
		i = getArray()[0];
		'''
	}

	def arrayAccessAsArgument() {
		'''
		int getArg(int i) {
			return i;
		}
		
		int[] j;
		getArg(j[0]);
		'''
	}

	def arrayAccessInForLoop() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1) {
			System.out.println("args[" + i + "] = " + args[i] );
		}
		'''
	}

	def arrayAccessInBinaryOp() {
		'''
		int[] a;
		boolean result = a[1] > a[2];
		'''
	}

	def arrayAccessInParenthesizedExpression() {
		'''
		int[] a;
		int i;
		i = (a)[1];
		'''
	}

	def multiArrayAccessInRightHandsideExpression() {
		'''
		int[][] a;
		int i;
		i = a[0][1+2];
		'''
	}

	def multiArrayAccessInLeftHandsideExpression() {
		'''
		int[][] a;
		int[][] b;
		a[0][1+2] = 1;
		a[0] = b[1];
		a = b;
		'''
	}

	def arrayConstructorCallInVarDecl() {
		'''
		int[] i = new int[10];
		String[] a = new String[args.length];
		'''
	}

	def multiArrayConstructorCallInVarDecl() {
		'''
		int[][] i = new int[10][20];
		String[][] a = new String[args.length][args.length+1];
		'''
	}

	def multiArrayConstructorCallWithArrayLiteral() {
		'''
		int[] i = new int[] {0, 1, 2};
		int[][] j = new int[][] {{0, 1, 2},{3, 4, 5}};
		'''
	}

	def ifThenElseWithoutBlocks() {
		'''
		if (args.length() == 0)
			System.out.println("No args");
		else
			System.out.println("Args");
		'''
	}

	def ifThenElseWithBlocks() {
		'''
		if (args.length() == 0) {
			System.out.println("No args");
		} else {
			System.out.println("Args");
		}
		'''
	}

	def arrayLiteral() {
		'''
		int[] a = { 0, 1, 2 };
		'''
	}

	def emptyArrayLiteral() {
		'''
		int[] a = {};
		'''
	}

	def whileWithoutBlock() {
		'''
		int i = 0;
		while (i < 10)
			i = i + 1;
		'''
	}

	def whileWithBlock() {
		'''
		int i = 0;
		while (i < 10) {
			i = i + 1;
		}
		'''
	}

	def doWhileWithoutBlock() {
		'''
		int i = 0;
		do
			i = i + 1;
		while (i < 10);
		'''
	}

	def doWhileWithBlock() {
		'''
		int i = 0;
		do {
			i = i + 1;
		} while (i < 10);
		'''
	}

	def additionalSemicolons() {
		'''
		void m() { return;;; }
		int i = 0;;;
		while (i < 10) {
			i = i + 1;
		};
		'''
	}

	def assignToParam() {
		'''
		void m(int a) {
			a = 1;
		}
		'''
	}

	def postIncrement() {
		'''
		int i = 0;
		int j = i++;
		j++;
		'''
	}

	def multiAssign() {
		'''
		int i = 0;
		i += 2;
		'''
	}

	def forLoopTranslatedToJavaWhileSingleStatement() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1)
			System.out.println(""+i);
		'''
	}

	def forLoopTranslatedToJavaWhileInsideIf() {
		'''
		int argsNum = args.length();
		if (argsNum != 0)
			for (int i = 0; i < argsNum; i += 1)
				System.out.println(""+i);
		'''
	}

	def forLoopTranslatedToJavaWhileNoExpression() {
		'''
		int argsNum = args.length();
		for (int i = 0; ; i += 1)
			System.out.println(""+i);
		'''
	}

	/** 
	 * this is not valid input since i += 1 is considered not reachable
	 * we use it only to test the compiler
	 */
	def forLoopTranslatedToJavaWhileEarlyExit() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1)
			return;
		'''
	}

	def continueInForLoopTranslatedToJavaFor() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i++) {
			if (argsNum > 0) {
				continue;
			} else {
				System.out.println("");
			}
		}
		'''
	}

	def continueInForLoopTranslatedToJavaWhile() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1) {
			if (argsNum > 0) {
				continue;
			} else {
				System.out.println("");
			}
		}
		'''
	}

	def continueInForLoopTranslatedToJavaWhileNoExpression() {
		'''
		int argsNum = args.length();
		for (int i = 0; ; i += 1) {
			if (argsNum > 0) {
				continue;
			} else {
				System.out.println("");
			}
		}
		'''
	}

	def continueInBothIfBranchesInForLoopTranslatedToJavaWhile() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1) {
			if (argsNum > 0) {
				continue;
			} else {
				continue;
			}
		}
		'''
	}

	def continueSingleInForLoopTranslatedToJavaWhile() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1)
			continue;
		'''
	}

	def continueInForLoopTranslatedToJavaWhileAndOtherStatementsAfterLoop() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1) {
			if (argsNum > 0) {
				continue;
			} else {
				System.out.println("");
			}
		}
		int j = 0;
		System.out.println(j);
		'''
	}

	def continueInWhileLoop() {
		'''
		int argsNum = args.length();
		int i = 0;
		while (i < argsNum) {
			if (argsNum > 0) {
				continue;
			} else {
				System.out.println("");
			}
		}
		'''
	}

	def continueInBothIfBranchesInWhileLoop() {
		'''
		int argsNum = args.length();
		int i = 0;
		while (i < argsNum) {
			if (argsNum > 0) {
				continue;
			} else {
				continue;
			}
		}
		'''
	}

	def continueInDoWhileLoop() {
		'''
		int argsNum = args.length();
		int i = 0;
		do {
			if (argsNum > 0) {
				continue;
			} else {
				System.out.println("");
			}
		} while (i < argsNum);
		'''
	}

	def continueInBothIfBranchesInDoWhileLoop() {
		'''
		int argsNum = args.length();
		int i = 0;
		do {
			if (argsNum > 0) {
				continue;
			} else {
				continue;
			}
		} while (i < argsNum);
		'''
	}

	def breakInForLoopTranslatedToJavaFor() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i++) {
			if (argsNum > 0) {
				break;
			} else {
				System.out.println("");
			}
		}
		'''
	}

	def breakInForLoopTranslatedToJavaWhile() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1) {
			if (argsNum > 0) {
				break;
			} else {
				System.out.println("");
			}
		}
		'''
	}

	def breakInBothIfBranchesInForLoopTranslatedToJavaWhile() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1) {
			if (argsNum > 0) {
				break;
			} else {
				break;
			}
		}
		'''
	}

	def breakSingleInForLoopTranslatedToJavaWhile() {
		'''
		int argsNum = args.length();
		for (int i = 0; i < argsNum; i += 1)
			break;
		'''
	}

	def breakInWhileLoop() {
		'''
		int argsNum = args.length();
		int i = 0;
		while (i < argsNum) {
			if (argsNum > 0) {
				break;
			} else {
				System.out.println("");
			}
		}
		'''
	}

	def breakInBothIfBranchesInWhileLoop() {
		'''
		int argsNum = args.length();
		int i = 0;
		while (i < argsNum) {
			if (argsNum > 0) {
				break;
			} else {
				break;
			}
		}
		'''
	}

	def breakInDoWhileLoop() {
		'''
		int argsNum = args.length();
		int i = 0;
		do {
			if (argsNum > 0) {
				break;
			} else {
				System.out.println("");
			}
		} while (i < argsNum);
		'''
	}

	def breakInBothIfBranchesInDoWhileLoop() {
		'''
		int argsNum = args.length();
		int i = 0;
		do {
			if (argsNum > 0) {
				break;
			} else {
				break;
			}
		} while (i < argsNum);
		'''
	}

	def emptySwitchStatement() {
		'''
		int argsNum = args.length();
		switch (argsNum) {
			
		}
		'''
	}

	def switchStatementWithCaseAndDefault() {
		'''
		int argsNum = args.length();
		switch (argsNum) {
			case 0 : System.out.println("0");
			default: System.out.println("default");
		}
		'''
	}

	def switchStatementWithCaseAndDefaultMultipleStatements() {
		'''
		int argsNum = args.length();
		int i;
		switch (argsNum) {
			case 0 : i = 0; System.out.println("0");
			default: i = -1; System.out.println("default");
		}
		'''
	}

	def switchStatementWithBreak() {
		'''
		int argsNum = args.length();
		int i;
		switch (argsNum) {
			case 0 : 
				i = 0;
				System.out.println("0");
				break;
			default: 
				i = -1; 
				System.out.println("default");
				break;
		}
		'''
	}

	/**
	 * This would work only for Java 1.7 so for the moment we'll not deal with that
	 */
	def switchStatementWithStrings() {
		'''
		int argsNum = args.length();
		String arg = args[0];
		int i;
		switch (arg) {
			case "first" : 
				i = 0;
				System.out.println("0");
				break;
			default: 
				i = -1; 
				System.out.println("default");
				break;
		}
		'''
	}

	def switchStatementWithChars() {
		'''
		int argsNum = args.length();
		String firstArg = args[0];
		char arg = firstArg.toCharArray()[0];
		// char arg = args[0].toCharArray()[0];
		int i;
		switch (arg) {
			case 'f' : 
				i = 0;
				System.out.println("0");
				break;
			default: 
				i = -1; 
				System.out.println("default");
				break;
		}
		'''
	}

	def switchStatementWithBytes() {
		'''
		byte b;
		switch (b) {
			case 10:
				System.out.println("10");
			case 'f' : 
				System.out.println("f");
				break;
			default: 
				System.out.println("default");
				break;
		}
		'''
	}

	def varNameSameAsMethodName() {
'''
int numOfDigits(int num) {
  int numOfDigits = 1;
  while (num/10>0) {
    numOfDigits = numOfDigits+1;
    num = num/10;
  }
  return numOfDigits;
}

System.out.println("numOfDigits(3456): " +numOfDigits(3456)); 
'''
	}

	def numberLiterals() {
'''
byte b = 100;
short s = 1000;
char c = 1000;
'''
	}

	def charLiterals() {
'''
byte b = 'c';
short s = 'c';
char c = 'c';
int i = 'c';
long l = 'c';
double d = 'c';
float f = 'c';
'''
	}

	def bubbleSort() {
'''
void bubbleSort(int[] array) {
    boolean swapped = true;
    int j = 0;
    int tmp;
    while (swapped) {
        swapped = false;
        j = j + 1;
        for (int i = 0; i < array.length - j; i++) {
            if (array[i] > array[i + 1]) {
                tmp = array[i];
                array[i] = array[i + 1];
                array[i + 1] = tmp;
                swapped = true;
            }
        }
    }
}
'''
	}

	def sudoku() {
'''
/**
 * Example Sudoku of the book
 */
int[] nextCell( int[] c,int[][] s ) {
  for (int j = c[1] + 1; j < s.length; j++) {
    if (s[c[0]][j] == 0) {
      return new int[] { c[0], j };
    }
  }
  for (int i = c[0] + 1; i < s.length; i++) {
    for (int j = 0; j < s.length; j++) {
      if (s[i][j] == 0) {
        return new int[] { i, j };
      }
    }
  }
  return new int[] { -1, -1 };
}
boolean feasible(int d, int[] c, int n, int[][] s) {
  for (int i = 0; i < n * n; i++) {
    if (s[c[0]][i] == d) {
      return false;
    }
  }
  for (int i = 0; i < n * n; i++) {
    if (s[i][c[1]] == d) {
      return false;
    }
  }
  int fr = (c[0] / n) * n;
  int fc = (c[1] / n) * n;
  for (int i = fr; i < fr + n; i++) {
    for (int j = fc; j < fc + n; j++) {
      if (s[i][j] == d) {
        return false;
      }
    }
  }
  return true;
}
boolean[] feasibleDigits(int[] c, int n, int[][] s) {
  boolean[] r = new boolean[n * n];
  for (int d = 1; d <= n * n; d++) {
    r[d - 1] = feasible(d, c, n, s);
  }
  return r;
}
boolean solvable(int[] c, int n, int[][] s) {
  boolean[] a = feasibleDigits(c, n, s);
  for (int d = 1; d <= n*n; d++) {
    if (a[d-1]) {
      s[c[0]][c[1]] = d;
      int[] nc = nextCell(c, s);
      if (nc[0] >= 0 && !solvable(nc, n, s)) {
        s[c[0]][c[1]] = 0;
      } else {
        return true;
      }
    }
  }
  return false;
}
void printBoard(int[][] s) {
  for (int i = 0; i < s.length; i++) {
    for (int j = 0; j < s.length; j++) {
      System.out.print(s[i][j] + " ");
    }
   System.out.println();
  }
}

void testMe() {
  int[][] s = { { 4, 0, 0, 0 }, { 0, 0, 0, 3 }, 
    { 0, 1, 3, 0 },{ 0, 0, 0, 2 } };
  int n = 2;
  printBoard( s );
  int[] p = nextCell(new int[] { 0, -1 }, s);
  System.out.println(solvable(p, n, s));
  printBoard( s );
'''
	}
}
