import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Google Play icon is an opaque 512-pixel PNG under 1 MB', () async {
    const icon = 'icon/googleplay.png';
    expect(_pngHeader(icon), (width: 512, height: 512, bitDepth: 8, colorType: 6));
    expect(File(icon).lengthSync(), lessThanOrEqualTo(1024 * 1024));
    await _expectOpaque(icon);
  });

  test('Apple App Store icon is an opaque 1024-pixel PNG', () async {
    const icon = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png';
    expect(_pngHeader(icon), (width: 1024, height: 1024, bitDepth: 8, colorType: 2));
    await _expectOpaque(icon);
  });

  test('web favicon is a 32-pixel PNG', () {
    final favicon = _pngHeader('web/favicon.png');
    expect(favicon.width, 32);
    expect(favicon.height, 32);
    expect(favicon.bitDepth, 8);
    expect(favicon.colorType, anyOf(2, 6));
  });
}

({int width, int height, int bitDepth, int colorType}) _pngHeader(String fileName) {
  final bytes = File(fileName).readAsBytesSync();
  expect(bytes.take(8), orderedEquals(<int>[137, 80, 78, 71, 13, 10, 26, 10]));
  expect(String.fromCharCodes(bytes.sublist(12, 16)), 'IHDR');
  final data = ByteData.sublistView(bytes);
  return (width: data.getUint32(16), height: data.getUint32(20), bitDepth: bytes[24], colorType: bytes[25]);
}

Future<void> _expectOpaque(String fileName) async {
  final buffer = await ui.ImmutableBuffer.fromUint8List(File(fileName).readAsBytesSync());
  final codec = await ui.instantiateImageCodecFromBuffer(buffer);
  final frame = await codec.getNextFrame();
  final pixels = await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
  expect(pixels, isNotNull);
  final bytes = pixels!.buffer.asUint8List();
  int? firstNonOpaquePixel;
  for (var i = 3; i < bytes.length; i += 4) {
    if (bytes[i] != 255) {
      firstNonOpaquePixel = (i - 3) ~/ 4;
      break;
    }
  }
  frame.image.dispose();
  codec.dispose();
  expect(firstNonOpaquePixel, isNull, reason: 'Every pixel in $fileName must be opaque');
}
