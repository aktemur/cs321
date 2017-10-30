abstract class Env {
    abstract int lookup(String name);

    public Env cons(String name, int value) {
        return new NonEmpty(name, value, this);
    }
}

class Empty extends Env {
    public int lookup(String name) {
        throw new Error("I'm empty you idiot!!!");
    }
}

class NonEmpty extends Env {
    private String name;
    private int value;
    private Env tail;

    public NonEmpty(String name, int value, Env tail) {
        this.name = name; this.value = value; this.tail = tail;
    }

    public int lookup(String name) {
        if (name.equals(this.name)) {
            return value;
        } else {
            return tail.lookup(name);
        }
    }
}

abstract class Exp {
    abstract int eval(Env env);
}

class CstI extends Exp {
    private int value;

    CstI(int value) { this.value = value; }

    public int eval(Env env) {
        return value;
    }
}

class Var extends Exp {
    private String name;

    Var(String name) { this.name = name; }

    public int eval(Env env) {
        return env.lookup(name);
    }
}

class Add extends Exp {
    private Exp e1;
    private Exp e2;

    Add(Exp e1, Exp e2) { this.e1 = e1; this.e2 = e2; }

    public int eval(Env env) {
        return e1.eval(env) + e2.eval(env);
    }
}

class Mult extends Exp {
    private Exp e1;
    private Exp e2;

    Mult(Exp e1, Exp e2) { this.e1 = e1; this.e2 = e2; }

    public int eval(Env env) {
        return e1.eval(env) * e2.eval(env);
    }
}

class LetIn extends Exp {
    private String name;
    private Exp e1;
    private Exp e2;

    LetIn(String name, Exp e1, Exp e2) { this.name = name; this.e1 = e1; this.e2 = e2; }
    
    public int eval(Env env) {
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

        System.out.println(e10.eval(new Empty())); // EXPECTED: 26
    }
}
