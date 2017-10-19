abstract class Tree<T> {
    abstract boolean contains(T thing);
}

class Leaf<T> extends Tree<T> {
    T value;

    Leaf(T value) {
        this.value = value;
    }

    boolean contains(T thing) {
        return thing.equals(value);
    }
}

class Node<T> extends Tree<T> {
    T value;
    Tree<T> left;
    Tree<T> right;

    Node(T value, Tree<T> left, Tree<T> right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    boolean contains(T thing) {
        return thing.equals(value) ||
            left.contains(thing) ||
            right.contains(thing);
    }
}

class PolymorphicTrees {
    public static void main(String[] args) {
        Tree<Integer> tree =
            new Node<Integer>(4,
                new Node<Integer>(8,
                    new Leaf<Integer>(5),
                    new Leaf<Integer>(2)),
                new Node<Integer>(3,
                    new Leaf<Integer>(7),
                    new Node<Integer>(9,
                        new Leaf<Integer>(12),
                        new Leaf<Integer>(6))));

        System.out.println(tree.contains(12));
        System.out.println(tree.contains(999));
    }
}
    
