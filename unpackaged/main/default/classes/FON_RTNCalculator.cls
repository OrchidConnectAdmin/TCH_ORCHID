public class FON_RTNCalculator {
    public static String calculate(String rtn) {
        String calculatedRTN = null;

        if(rtn.length() == 9) {
            calculatedRTN = rtn;
        } else if(rtn.length() == 8) {
            calculatedRTN = calculateNinthDigit(rtn);
        } else if(rtn.length() == 7) {
            String newRTN = '0' + rtn;
            calculatedRTN = calculateNinthDigit(newRTN);
        }

        return calculatedRTN;
    }

    private static String calculateNinthDigit(string rtn) {
        String calculatedRTN = null;

        Integer firstDigit = Integer.valueOf(rtn.substring(0, 1)) * 3;
        Integer secondDigit = Integer.valueOf(rtn.substring(1,2)) * 7;
        Integer thirdDigit = Integer.valueOf(rtn.substring(2,3)) * 1;
        Integer fourthDigit = Integer.valueOf(rtn.substring(3,4)) * 3;
        Integer fifthDigit = Integer.valueOf(rtn.substring(4,5)) * 7;
        Integer sixthDigit = Integer.valueOf(rtn.substring(5,6)) * 1;
        Integer seventhDigit = Integer.valueOf(rtn.substring(6,7)) * 3;
        Integer eigthDigit = Integer.valueOf(rtn.substring(7,8)) * 7;

        Double ninthDigit = firstDigit + secondDigit + thirdDigit + fourthDigit + fifthDigit + sixthDigit +
            seventhDigit + eigthDigit;

        ninthDigit = Math.ceil(ninthDigit / 10) * 10 - ninthDigit;

        calculatedRTN = rtn + (Integer)ninthDigit;

        return calculatedRTN;
    }
}