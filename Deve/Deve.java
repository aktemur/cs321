abstract class Env<K, V> {
    abstract V lookup(K key);

    public Env cons(K key, V value) {
        return new NonEmpty(key, value, this);
    }
}

class Empty<K, V> extends Env<K, V> {
    public V lookup(K key) {
        throw new Error("I'm empty you idiot!!!");
    }
}

class NonEmpty<K, V> extends Env<K, V> {
    private K key;
    private V value;
    private Env<K, V> tail;

    public NonEmpty(K key, V value, Env<K, V> tail) {
        this.key = key; this.value = value; this.tail = tail;
    }

    public V lookup(K key) {
        if (key.equals(this.key)) {
            return value;
        } else {
            return tail.lookup(key);
        }
    }
}

abstract class Exp {
    abstract int eval(Env<String, Integer> env);
}

class CstI extends Exp {
    private int value;

    CstI(int value) { this.value = value; }

    public int eval(Env<String, Integer> env) {
        return value;
    }
}

class Var extends Exp {
    private String name;

    Var(String name) { this.name = name; }

    public int eval(Env<String, Integer> env) {
        return env.lookup(name);
    }
}

class Add extends Exp {
    private Exp e1;
    private Exp e2;

    Add(Exp e1, Exp e2) { this.e1 = e1; this.e2 = e2; }

    public int eval(Env<String, Integer> env) {
        return e1.eval(env) + e2.eval(env);
    }
}

class Mult extends Exp {
    private Exp e1;
    private Exp e2;

    Mult(Exp e1, Exp e2) { this.e1 = e1; this.e2 = e2; }

    public int eval(Env<String, Integer> env) {
        return e1.eval(env) * e2.eval(env);
    }
}

class LetIn extends Exp {
    private String name;
    private Exp e1;
    private Exp e2;

    LetIn(String name, Exp e1, Exp e2) { this.name = name; this.e1 = e1; this.e2 = e2; }
    
    public int eval(Env<String, Integer> env) {
        Env env2 = env.cons(name, e1.eval(env));
        return e2.eval(env2);
    }
}
    

public class Arith {
    public static void main(String[] args) {
        /* let x =
             let a = 5
             in let b = 8
                in a + b
           in x * 2
        */
        Exp e10 = new LetIn("x", new LetIn("a", new CstI(5),
                                           new LetIn("b", new CstI(8),
                                                     new Add(new Var("a"),
                                                             new Var("b")))),
                            new Mult(new Var("x"), new CstI(2)));

        Env<String, Integer> empty = new Empty();
        System.out.println(e10.eval(empty)); // EXPECTED: 26
    }
}
