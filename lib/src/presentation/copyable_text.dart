import 'dart:async';

import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter/widgets.dart';

import '../application/copy_handler.dart';
import '../domain/models/copyable_action_mode.dart';
import '../domain/models/copyable_feedback.dart';
import '../domain/models/haptic_feedback_style.dart';
import 'copyable_theme.dart';

/// A [Text] widget that copies its content to the clipboard on tap or
/// long-press.
///
/// Prefer constructing this via [Copyable.text] for a unified entry point.
/// All standard [Text] widget parameters are forwarded verbatim.
///
/// The optional [value] parameter lets you decouple the displayed label from
/// what is written to the clipboard. When omitted, [data] is copied instead.
///
/// ```dart
/// CopyableText(
///   "TXN-9182736",
///   style: TextStyle(fontFamily: 'monospace'),
/// )
///
/// // Show a label but copy the actual card number
/// CopyableText(
///   "Copy card number",
///   value: cardNumber,
/// )
/// ```
class CopyableText extends StatefulWidget {
  const CopyableText(
    this.data, {
    super.key,
    this.value,
    this.mode,
    this.feedback = const SnackBarFeedback(),
    this.haptic = HapticFeedbackStyle.lightImpact,
    this.clearAfter,
    this.onError,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  /// The text string displayed to the user.
  final String data;

  /// The string written to the clipboard when the gesture fires.
  ///
  /// When null, [data] is copied instead. Use this to show a label
  /// (e.g. "Copy card number") while copying a different value.
  final String? value;

  /// The gesture that triggers the copy. Defaults to [CopyableActionMode.tap].
  final CopyableActionMode? mode;

  /// What happens after a successful copy.
  final CopyableFeedback feedback;

  /// The haptic style fired after the clipboard write.
  final HapticFeedbackStyle haptic;

  /// Automatically overwrites the clipboard with an empty string after this
  /// duration. When null, falls back to [CopyableThemeData.clearAfter].
  ///
  /// Designed for FinTech and crypto apps that handle sensitive data.
  final Duration? clearAfter;

  /// Called when [Clipboard.setData] throws an error.
  ///
  /// When provided, no haptic or feedback is triggered on failure.
  final void Function(Object)? onError;

  // ── Text widget parameters ────────────────────────────────────────────────

  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  static final _handler = CopyHandler();

  @override
  State<CopyableText> createState() => _CopyableTextState();
}

class _CopyableTextState extends State<CopyableText> {
  Timer? _clearTimer;

  @override
  void dispose() {
    _clearTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleCopy(BuildContext context) async {
    final theme = CopyableTheme.of(context);
    final resolvedMode = CopyableText._handler.resolveMode(widget.mode);

    // Resolve SnackBar text/duration from theme when not provided per-widget.
    CopyableFeedback resolvedFeedback = widget.feedback;
    if (widget.feedback is SnackBarFeedback) {
      final snackFeedback = widget.feedback as SnackBarFeedback;
      resolvedFeedback = SnackBarFeedback(
        text: snackFeedback.text ?? theme.snackBarText,
        duration: snackFeedback.duration ?? theme.snackBarDuration,
      );
    }

    var copySucceeded = true;
    await CopyableText._handler.handle(
      context: context,
      value: widget.value ?? widget.data,
      resolvedMode: resolvedMode,
      feedback: resolvedFeedback,
      haptic: widget.haptic,
      onError: (e) {
        copySucceeded = false;
        widget.onError?.call(e);
      },
    );

    if (!copySucceeded) return;

    // Start clear timer only after a confirmed successful copy.
    final resolvedClearAfter = widget.clearAfter ?? theme.clearAfter;
    if (resolvedClearAfter != null) {
      _clearTimer?.cancel();
      _clearTimer = Timer(resolvedClearAfter, () {
        Clipboard.setData(const ClipboardData(text: ''));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedMode = CopyableText._handler.resolveMode(widget.mode);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: resolvedMode == CopyableActionMode.tap
          ? () => _handleCopy(context)
          : null,
      onLongPress: resolvedMode == CopyableActionMode.longPress
          ? () => _handleCopy(context)
          : null,
      child: Text(
        widget.data,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaler: widget.textScaler,
        maxLines: widget.maxLines,
        semanticsLabel: widget.semanticsLabel,
        textWidthBasis: widget.textWidthBasis,
        textHeightBehavior: widget.textHeightBehavior,
        selectionColor: widget.selectionColor,
      ),
    );
  }
}
