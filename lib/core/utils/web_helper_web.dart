// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

void openBrowserPopup(String url) {
  try {
    js.context.callMethod('open', [
      url,
      'PayPalCheckout',
      'width=550,height=700,status=no,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=yes'
    ]);
  } catch (_) {}
}

void closeBrowserWindow() {
  try {
    js.context.callMethod('close', []);
  } catch (_) {}
}

