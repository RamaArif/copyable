import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import '../domain/services/clipboard_service.dart';

/// Flutter implementation of [ClipboardService].
///
/// Delegates to [Clipboard.setData] via Flutter's built-in platform channels.
/// Works on all six Flutter platforms with no additional setup.
final class ClipboardServiceImpl implements ClipboardService {
  const ClipboardServiceImpl();

  @override
  Future<void> copy(String value) =>
      Clipboard.setData(ClipboardData(text: value));
}
