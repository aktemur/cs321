// File Intro/SimpleExpr.java
// Java representation of expressions as in lecture 1
// sestoft@itu.dk * 2010-08-29

import java.util.Map;
import java.util.HashMap;


abstract class List<K, V>{
    public abstract V lookup(K key);
}

class Empty<K,V> extends List<K,V> {
    public V lookup(K key) {
        throw new Error("Name '" + key + "' not found :(");
    }
}

class Cons<K,V> extends List<K,V> {
    protected final K key;
    protected final V value;
    protected final List<K,V> next;
    
    Cons(K key, V value, List<K,V> next) {
        this.key = key;
        this.value = value;
        this.next = next;
    }

    public V lookup(K key) {
        if (this.key.equals(key)) {
            return value;
        } else {
            return next.lookup(key);
        }
    }
}
    

abstract class Expr {
    public abstract int eval(List<String,Integer> env);
}

class CstI extends Expr { 
    protected final int i;

    public CstI(int i) { 
        this.i = i; 
    }

    public int eval(List<String,Integer> env) {
        return i;
    }
}

class Var extends Expr { 
    protected final String name;

    public Var(String name) { 
        this.name = name; 
    }

    public int eval(List<String,Integer> env) {
        return env.lookup(name);
    }
}

class Plus extends Expr {
    protected final Expr e1;
    protected final Expr e2;

    public Plus(Expr e1, Expr e2) {
        this.e1 = e1;
        this.e2 = e2;
    }

    public int eval(List<String, Integer> env) {
        return e1.eval(env) + e2.eval(env);
    }
}

class Minus extends Expr {
    protected final Expr e1;
    protected final Expr e2;

    public Minus(Expr e1, Expr e2) {
        this.e1 = e1;
        this.e2 = e2;
    }

    public int eval(List<String, Integer> env) {
        return e1.eval(env) - e2.eval(env);
    }
}

class Star extends Expr {
    protected final Expr e1;
    protected final Expr e2;

    public Star(Expr e1, Expr e2) {
        this.e1 = e1;
        this.e2 = e2;
    }

    public int eval(List<String, Integer> env) {
        return e1.eval(env) * e2.eval(env);
    }
}

class Slash extends Expr {
    protected final Expr e1;
    protected final Expr e2;

    public Slash(Expr e1, Expr e2) {
        this.e1 = e1;
        this.e2 = e2;
    }

    public int eval(List<String, Integer> env) {
        return e1.eval(env) / e2.eval(env);
    }
}

class Let extends Expr {
    protected final String x;
    protected final Expr e1;
    protected final Expr e2;
    
    public Let(String x, Expr e1, Expr e2) {
        this.x = x;
        this.e1 = e1;
        this.e2 = e2;
    }

    public int eval(List<String, Integer> env) {
        int i = e1.eval(env);
        List<String, Integer> newEnv = new Cons<String, Integer>(x, i, env);
        return e2.eval(newEnv);
    }
}

public class SimpleExpr {
    public static void main(String[] args) {
        Expr e1 = new CstI(17);
        Expr e2 = new Plus(new CstI(3), new Var("a"));
        Expr e3 = new Plus(new Star(new Var("b"), new CstI(9)), 
                           new Var("a"));
        Expr e4 = new Let("a", new CstI(30),
                          new Let("b", new CstI(12),
                                  new Plus(new Var("a"),
                                           new Plus(new Var("b"),
                                                    new CstI(3)))));
                                  
        List<String,Integer> env = new Empty<String, Integer>();
        System.out.println(e4.eval(env));
    }
}
