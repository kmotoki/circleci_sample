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

    public String getS() {
        return s;
    }

    public void setS(String s) {
        this.s = s;
    }

}
