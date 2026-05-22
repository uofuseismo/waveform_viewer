import 'dart:ffi';
import 'dart:io' show File, Platform;

typedef _SumNative = Int32 Function(Int32 a, Int32 b);
typedef _SumDart = int Function(int a, int b);

String get _libPath {
  final bundleDir = File(Platform.resolvedExecutable).parent.path;
  print(bundleDir);
  if (Platform.isLinux) return '$bundleDir/lib/libwaveform_native.so';
  if (Platform.isMacOS) return '$bundleDir/lib/libwaveform_native.dylib';
  if (Platform.isWindows) return '$bundleDir/lib/waveform_native.dll';
  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}

class NativeBridge {
  static final DynamicLibrary _lib = DynamicLibrary.open(_libPath);

  static final _SumDart _sum =
      _lib.lookupFunction<_SumNative, _SumDart>('sum');

  static int sum(int a, int b) => _sum(a, b);
}
