class Validator {
  static String? validateBluetoothMessage({required String? msg}) {
    if (msg == null) {
      return null;
    }
    if (msg.isEmpty) {
      return 'Bluetooth message can\'t be empty';
    }

    return null;
  }
}
