import java.util.LinkedList;

class Dummy {
    int x;
    int y;
    double d;
    int[] a = new int[10000];
}

public class MemoryOutage {
    public static void main(String[] args) {
        LinkedList<Dummy> numbers = new LinkedList<Dummy>();
        while(true) {
            numbers.add(new Dummy());
        }
    }
}
