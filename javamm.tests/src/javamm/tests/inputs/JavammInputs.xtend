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

}