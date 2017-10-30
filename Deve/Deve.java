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

class Less extends Exp {
    private Exp e1;
    private Exp e2;

    Less(Exp e1, Exp e2) { this.e1 = e1; this.e2 = e2; }

    public int eval(Env<String, Integer> env) {
        return e1.eval(env) < e2.eval(env) ? 1 : 0;
    }
}

class GreaterOrEq extends Exp {
    private Exp e1;
    private Exp e2;

    GreaterOrEq(Exp e1, Exp e2) { this.e1 = e1; this.e2 = e2; }

    public int eval(Env<String, Integer> env) {
        return e1.eval(env) >= e2.eval(env) ? 1 : 0;
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

class If extends Exp {
    private Exp e1;
    private Exp e2;
    private Exp e3;

    If(Exp e1, Exp e2, Exp e3) { this.e1 = e1; this.e2 = e2; this.e3 = e3; }

    public int eval(Env env) {
        if (e1.eval(env) == 0) {
            return e3.eval(env);
        } else {
            return e2.eval(env);
        }
    }
}

public class Deve {
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

        Exp e11 = new LetIn("x", new CstI(4),
                            new If(new GreaterOrEq(new Add(new Var("x"),
                                                           new CstI(1)),
                                                   new CstI(0)),
                                   new CstI(42),
                                   new Mult(new Var("x"), new CstI(8))));
        Exp e12 = new LetIn("x", new CstI(4),
                            new If(new Less(new Var("x"), new CstI(4)),
                                   new CstI(42),
                                   new Add(new Var("x"), new CstI(8))));
        System.out.println(e11.eval(empty)); // EXPECTED: 42
        System.out.println(e12.eval(empty)); // EXPECTED: 12
    }
}
