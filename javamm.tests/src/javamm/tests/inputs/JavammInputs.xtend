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
			j = 1
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
}