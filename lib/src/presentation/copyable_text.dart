import 'package:flutter/widgets.dart';

import '../application/copy_handler.dart';
import '../domain/models/copyable_action_mode.dart';
import '../domain/models/copyable_feedback.dart';
import '../domain/models/haptic_feedback_style.dart';

/// A [Text] widget that copies its content to the clipboard on tap or
/// long-press.
///
/// Prefer constructing this via [Copyable.text] for a unified entry point.
/// All standard [Text] widget parameters are forwarded verbatim.
///
/// ```dart
/// CopyableText(
///   "TXN-9182736",
///   style: TextStyle(fontFamily: 'monospace'),
/// )
/// ```
class CopyableText extends StatelessWidget {
  const CopyableText(
    this.data, {
    super.key,
    this.mode,
    this.feedback = const SnackBarFeedback(),
    this.haptic = HapticFeedbackStyle.lightImpact,
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

  /// The text string to display and copy to the clipboard.
  final String data;

  /// The gesture that triggers the copy. Defaults to auto-detection.
  final CopyableActionMode? mode;

  /// What happens after a successful copy.
  final CopyableFeedback feedback;

  /// The haptic style fired after the clipboard write.
  final HapticFeedbackStyle haptic;

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
  Widget build(BuildContext context) {
    final resolvedMode = _handler.resolveMode(mode);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: resolvedMode == CopyableActionMode.tap
          ? () => _handler.handle(
                context: context,
                value: data,
                resolvedMode: resolvedMode,
                feedback: feedback,
                haptic: haptic,
              )
          : null,
      onLongPress: resolvedMode == CopyableActionMode.longPress
          ? () => _handler.handle(
                context: context,
                value: data,
                resolvedMode: resolvedMode,
                feedback: feedback,
                haptic: haptic,
              )
          : null,
      child: Text(
        data,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      ),
    );
  }
}
