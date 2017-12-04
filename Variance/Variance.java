import java.util.*;

class Person {
    String name;
}

class Student extends Person {
    double gpa;
}

public class Variance {
    // Co-variance
    public static void printPeople(ArrayList<? extends Person> people) {
        for(Person p: people) {
            System.out.println(p);
        }
        // Co-variance does NOT allow WRITE operation
        // The statement below gives a type error
        // people.add(new Person());        
    }

    // Contra-variance
    public static void addNewStudent(ArrayList<? super Student> students) {
        students.add(new Student());
        // Contra-variance does NOT allow READ operation
        // The statement below gives a type error
        // System.out.println(students.get(0).gpa);
    }

    public static void main(String[] args) {
        ArrayList<Student> students = new ArrayList<Student>();
        students.add(new Student());

        ArrayList<Person> people = new ArrayList<Person>();
        people.add(new Person());

        addNewStudent(people);
        printPeople(students);
    }
}
