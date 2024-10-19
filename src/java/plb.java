import java.io.IOException;

public class plb {
    public static void main(String[] args) throws IOException {
        int longestBits = 0;
        int currentBits = 0;
        int byteRead;
        while ((byteRead = System.in.read()) != -1) {
            for (int i = 0; i < 8; ++i) {
                if ((byteRead & (0b10000000 >> i)) == 0) {
                    if (currentBits > longestBits) {
                        longestBits = currentBits;
                    }
                    currentBits = 0;
                } else {
                    ++currentBits;
                }
            }
        }
        if (currentBits > longestBits) {
            longestBits = currentBits;
        }
        System.out.println(longestBits);
    }
}
