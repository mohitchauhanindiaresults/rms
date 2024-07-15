import 'dart:io' as io;
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart' as win32;

void platformSpecificFunction() {
  if (io.Platform.isWindows) {
    final message = 'Hello from Win32!'.toNativeUtf16();
    final title = 'Flutter'.toNativeUtf16();

    win32.MessageBox(
        0,
        message,
        title,
        win32.MB_OK
    );

    calloc.free(message);
    calloc.free(title);
  } else {
    // Code for other platforms (e.g., macOS, Linux)
    print("Running on ${io.Platform.operatingSystem}");
  }
}
