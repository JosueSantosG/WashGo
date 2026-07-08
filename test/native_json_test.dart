import 'package:firebase_data_connect/firebase_data_connect.dart';

void main() {
  try {
    print("Testing nativeFromJson with boolean...");
    final val = nativeFromJson<double>(true);
    print("Result: $val");
  } catch (e, stack) {
    print("Caught error: $e");
    print("Stack trace:\n$stack");
  }
}
