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


}