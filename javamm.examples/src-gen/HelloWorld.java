@SuppressWarnings("all")
public class HelloWorld {
  public static void sayHelloWorld(final String m) {
    System.out.println(m);
  }
  
  public static void main(final String... args) {
    HelloWorld.sayHelloWorld("Hello world!");
  }
}
