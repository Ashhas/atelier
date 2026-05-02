// Renders Atelier branding PNGs from the Flutter canvas using locally
// bundled Fraunces italic 300 + JetBrains Mono Medium TTFs (in
// assets/branding/, fetched once from gstatic). Not a real test — it is a
// scripted artifact generator that piggy-backs on flutter_test's headless
// binding. Run with:
//
//   flutter test tool/render_icon_test.dart
//
// Output: assets/branding/icon-{light,dark}-1024.png
//         assets/branding/icon-adaptive-fg-{light,dark}-1024.png
//         assets/branding/lockup-{light,dark}-1600x480.png

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _frauncesFamily = 'FrauncesBranding';
const _monoFamily = 'JetBrainsMonoBranding';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont(_frauncesFamily, 'assets/branding/Fraunces-Italic-300.ttf');
    await _loadFont(_monoFamily, 'assets/branding/JetBrainsMono-Medium.ttf');
  });

  test('render Atelier branding PNGs', () async {
    // glyphScale is the font-size in canvas-fraction units. A Fraunces italic
    // 'a' has visual height roughly 50% of its em-square, so 1.4 fills the
    // canvas to ~70% body height — the design's intent.
    await _writeIcon(
      outFile: 'assets/branding/icon-light-1024.png',
      background: const Color(0xFFFFFFFF),
      foreground: const Color(0xFF0A0A0A),
      glyphScale: 1.4,
    );
    await _writeIcon(
      outFile: 'assets/branding/icon-dark-1024.png',
      background: const Color(0xFF121212),
      foreground: const Color(0xFFFFFFFF),
      glyphScale: 1.4,
    );
    await _writeIcon(
      outFile: 'assets/branding/icon-adaptive-fg-light-1024.png',
      background: const Color(0x00000000),
      foreground: const Color(0xFF0A0A0A),
      glyphScale: 1.15,
    );
    await _writeIcon(
      outFile: 'assets/branding/icon-adaptive-fg-dark-1024.png',
      background: const Color(0x00000000),
      foreground: const Color(0xFFFFFFFF),
      glyphScale: 1.15,
    );

    await _writeLockup(
      outFile: 'assets/branding/lockup-light-1600x480.png',
      background: const Color(0xFFFFFFFF),
      foreground: const Color(0xFF0A0A0A),
      hairline: const Color(0xFFEDEDED),
    );
    await _writeLockup(
      outFile: 'assets/branding/lockup-dark-1600x480.png',
      background: const Color(0xFF121212),
      foreground: const Color(0xFFFFFFFF),
      hairline: const Color(0xFF2A2A2A),
    );
  });
}

Future<void> _loadFont(String family, String path) async {
  final loader = FontLoader(family);
  final bytes = await File(path).readAsBytes();
  loader.addFont(Future.value(bytes.buffer.asByteData()));
  await loader.load();
}

Future<void> _writeIcon({
  required String outFile,
  required Color background,
  required Color foreground,
  required double glyphScale,
}) async {
  const canvasSize = 1024;
  final fontSize = canvasSize * glyphScale;

  final style = TextStyle(
    fontFamily: _frauncesFamily,
    fontSize: fontSize,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w300,
    color: foreground,
    height: 0.85,
  );

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  if (background.a != 0) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, canvasSize.toDouble(), canvasSize.toDouble()),
      Paint()..color = background,
    );
  }

  final tp = TextPainter(
    text: TextSpan(text: 'a', style: style),
    textDirection: TextDirection.ltr,
  )..layout();

  final dx = (canvasSize - tp.width) / 2;
  // The italic 'a' bounding box includes ~12% of empty space below the
  // baseline (the descender slot). Nudge up by that fraction so the visible
  // ink sits at canvas center, not the glyph metric box.
  final dy = (canvasSize - tp.height) / 2 - tp.height * 0.06;
  tp.paint(canvas, Offset(dx, dy));

  await _writePng(recorder.endRecording(), canvasSize, canvasSize, outFile);
}

Future<void> _writeLockup({
  required String outFile,
  required Color background,
  required Color foreground,
  required Color hairline,
}) async {
  const w = 1600;
  const h = 480;

  final wordmarkStyle = TextStyle(
    fontFamily: _frauncesFamily,
    fontSize: 192,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w300,
    color: foreground,
    letterSpacing: -3,
    height: 0.9,
  );
  final metaStyle = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: foreground.withValues(alpha: 0.6),
    letterSpacing: 2.88,
  );

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  canvas.drawRect(
    Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
    Paint()..color = background,
  );

  final wordmark = TextPainter(
    text: TextSpan(text: 'atelier', style: wordmarkStyle),
    textDirection: TextDirection.ltr,
  )..layout();
  const wordmarkX = 120.0;
  final wordmarkY = (h - wordmark.height) / 2 + wordmark.height * 0.05;
  wordmark.paint(canvas, Offset(wordmarkX, wordmarkY));

  final dividerX = wordmarkX + wordmark.width + 36;
  canvas.drawLine(
    Offset(dividerX, h / 2 - 36),
    Offset(dividerX, h / 2 + 36),
    Paint()
      ..color = hairline
      ..strokeWidth = 1,
  );

  final metaA = TextPainter(
    text: TextSpan(text: 'A PERSONAL', style: metaStyle),
    textDirection: TextDirection.ltr,
  )..layout();
  final metaB = TextPainter(
    text: TextSpan(text: 'GOALS ATELIER', style: metaStyle),
    textDirection: TextDirection.ltr,
  )..layout();
  final metaX = dividerX + 24;
  final metaTotalH = metaA.height + 4 + metaB.height;
  final metaTopY = (h - metaTotalH) / 2;
  metaA.paint(canvas, Offset(metaX, metaTopY));
  metaB.paint(canvas, Offset(metaX, metaTopY + metaA.height + 4));

  final rightMetaA = TextPainter(
    text: TextSpan(text: '2026', style: metaStyle),
    textDirection: TextDirection.ltr,
  )..layout();
  final rightMetaB = TextPainter(
    text: TextSpan(text: 'LOCAL-FIRST', style: metaStyle),
    textDirection: TextDirection.ltr,
  )..layout();
  const dotR = 5.0;
  const gap = 14.0;
  final rightTotalW =
      rightMetaA.width + gap + dotR * 2 + gap + rightMetaB.width;
  final rightStartX = w - 120 - rightTotalW;
  final rightY = (h - rightMetaA.height) / 2;
  rightMetaA.paint(canvas, Offset(rightStartX, rightY));
  canvas.drawCircle(
    Offset(rightStartX + rightMetaA.width + gap + dotR, h / 2),
    dotR,
    Paint()..color = const Color(0xFF1ED760),
  );
  rightMetaB.paint(
    canvas,
    Offset(rightStartX + rightMetaA.width + gap + dotR * 2 + gap, rightY),
  );

  await _writePng(recorder.endRecording(), w, h, outFile);
}

Future<void> _writePng(
  ui.Picture picture,
  int width,
  int height,
  String outFile,
) async {
  final image = await picture.toImage(width, height);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  if (bytes == null) {
    throw StateError('toByteData returned null for $outFile');
  }
  final file = File(outFile);
  await file.parent.create(recursive: true);
  await file.writeAsBytes(bytes.buffer.asUint8List());
  // ignore: avoid_print
  print('wrote $outFile (${bytes.lengthInBytes} bytes)');
}
