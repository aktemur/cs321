public class StackOverflow {
    static int fun() {
        int a = 1;
        return fun() + a;
    }

    public static void main(String[] args) {
        int b = fun();
        System.out.println(b);
    }
}
