abstract class Utils {
  static String formatToRupiah(String money) {
    final number = money.replaceFirst('.00', '');

    List<int> separatorIndex = [];
    int counter = 0;
    for (int i = number.length - 1; i >= 0; i--) {
      counter++;
      if (counter % 3 == 0) {
        separatorIndex.add(i - 1);
      }
    }

    String result = 'Rp ';
    for (int i = 0; i < number.length; i++) {
      result += number[i];
      if (separatorIndex.contains(i)) {
        result += '.';
      }
    }
    
    return '$result,00';
  }

  static int compare(String a, String b) {
    if (a == '-' && b == '-') return 0;
    if (a == '-') return 1;
    if (b == '-') return -1;
    return a.compareTo(b);
  }
}