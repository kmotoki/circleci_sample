package circleci_sample;

public class ClassA {

    private String s = null;

    public boolean equailsWith(String text) {
        if (s.equals(text)) {
            return true;
        } else {
            return false;
        }
    }

    public void doSomething() {
        System.out.println("Do something.");
    }
}
