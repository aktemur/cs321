abstract class Tree {
    abstract boolean contains(int n);
}

class Leaf extends Tree {
    int value;
    Leaf(int v) { value = v; }

    boolean contains(int n) {
        return n == value;
    }
}

class Node extends Tree {
    Tree left;
    Tree right;
    Node(Tree l, Tree r) { left = l; right = r; }

    boolean contains(int n) {
        return left.contains(n) || right.contains(n);
    }
}

public class TreeExperiment {
    public static boolean contains(Tree t, int n) {
        if (t instanceof Leaf) {
            Leaf leaf = (Leaf)t;
            return leaf.value == n;
        } else {
            Node node = (Node)t;
            return contains(node.left, n) ||
                   contains(node.right, n);
        }
    }
    
    public static void main(String[] args) {
        Tree myTree =
            new Node(
                     new Node(new Leaf(3),
                              new Node(new Leaf(5),
                                       new Leaf(8))),
                     new Node(new Leaf(9),
                              new Leaf(11)));
        System.out.println(contains(myTree, 8));
        System.out.println(contains(myTree, 6));
        System.out.println(myTree.contains(8));
        System.out.println(myTree.contains(6));
    }
}
                              
                               
