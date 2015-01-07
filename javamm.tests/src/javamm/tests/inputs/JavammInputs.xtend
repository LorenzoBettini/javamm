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

	def arrayConstructorCallInVarDecl() {
		'''
		int[] i = new int[10];
		String[] a = new String[args.length];
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
}