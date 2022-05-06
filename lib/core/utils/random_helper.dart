import 'dart:math';

class RandomHelper {
  static String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String result = String.fromCharCodes(
      Iterable.generate(length, (_) {
        return _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        );
      }),
    );
    return result;
  }

  static int getRandomInteger(int length) {
    String stringInteger =
        Random().nextInt(999999).toString().padLeft(length, '0');
    int value = int.parse(stringInteger);
    return value;
  }
}
