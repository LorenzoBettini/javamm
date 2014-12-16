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

}