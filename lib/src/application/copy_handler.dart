import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart'
    show BuildContext, ScaffoldMessenger, SnackBar, Text, TextAlign;

import '../domain/models/copyable_action_mode.dart';
import '../domain/models/copyable_event.dart';
import '../domain/models/copyable_feedback.dart';
import '../domain/models/haptic_feedback_style.dart';
import '../domain/services/clipboard_service.dart';
import '../domain/services/haptic_service.dart';
import '../infrastructure/clipboard_service_impl.dart';
import '../infrastructure/haptic_service_impl.dart';

/// Orchestrates a clipboard copy action.
///
/// Responsibilities:
/// 1. Resolve the effective [CopyableActionMode] (auto or explicit).
/// 2. Write to the clipboard via [ClipboardService].
/// 3. Fire haptic feedback via [HapticService].
/// 4. Execute the [CopyableFeedback] strategy.
///
/// The [BuildContext] is accepted as a pass-through solely so that
/// [CopyableFeedback.snackBar] and [CopyableFeedback.custom] can access
/// [ScaffoldMessenger]. No widget state is owned here.
class CopyHandler {
  CopyHandler({
    ClipboardService? clipboardService,
    HapticService? hapticService,
  })  : _clipboardService =
            clipboardService ?? const ClipboardServiceImpl(),
        _hapticService = hapticService ?? const HapticServiceImpl();

  final ClipboardService _clipboardService;
  final HapticService _hapticService;

  /// Returns the effective [CopyableActionMode].
  ///
  /// When [explicit] is non-null it is returned unchanged.
  /// Otherwise the mode is auto-detected based on the current platform:
  /// - `tap` on web, macOS, Windows, and Linux
  /// - `longPress` on Android and iOS
  CopyableActionMode resolveMode(CopyableActionMode? explicit) {
    if (explicit != null) return explicit;
    if (kIsWeb) return CopyableActionMode.tap;
    return switch (defaultTargetPlatform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux =>
        CopyableActionMode.tap,
      _ => CopyableActionMode.longPress,
    };
  }

  /// Writes [value] to the clipboard, fires haptic feedback, and executes
  /// the [feedback] strategy.
  ///
  /// Returns immediately if the widget is no longer mounted when async
  /// operations complete.
  Future<void> handle({
    required BuildContext context,
    required String value,
    required CopyableActionMode resolvedMode,
    required CopyableFeedback feedback,
    required HapticFeedbackStyle haptic,
  }) async {
    await _clipboardService.copy(value);
    await _hapticService.perform(haptic);

    final event = CopyableEvent(
      value: value,
      timestamp: DateTime.now(),
      mode: resolvedMode,
    );

    if (!context.mounted) return;
    _executeFeedback(context, feedback, event);
  }

  void _executeFeedback(
    BuildContext context,
    CopyableFeedback feedback,
    CopyableEvent event,
  ) {
    switch (feedback) {
      case SnackBarFeedback(:final text, :final duration):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text, textAlign: TextAlign.center),
            duration: duration,
          ),
        );
      case CustomFeedback(:final onCopied):
        onCopied(context, event);
      case NoneFeedback():
        break;
    }
  }
}
