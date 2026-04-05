import 'dart:async';

import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter/widgets.dart' show State, StatefulWidget;

/// Provides clipboard clear-after timer management for copy widgets.
///
/// Owns the timer field, exposes [startClearAfterTimer], and cancels the
/// timer in [dispose]. Apply with `with ClearAfterMixin<WidgetType>` on the
/// widget's [State] class.
mixin ClearAfterMixin<T extends StatefulWidget> on State<T> {
  Timer? _clearAfterTimer;

  /// Starts (or restarts) a timer that clears the clipboard after [duration].
  ///
  /// Cancels any running timer first. Does nothing when [duration] is null.
  void startClearAfterTimer(Duration? duration) {
    if (duration == null) return;
    _clearAfterTimer?.cancel();
    _clearAfterTimer = Timer(duration, () {
      Clipboard.setData(const ClipboardData(text: ''));
    });
  }

  @override
  void dispose() {
    _clearAfterTimer?.cancel();
    super.dispose();
  }
}
