import 'package:flutter/services.dart' show HapticFeedback;

import '../domain/models/haptic_feedback_style.dart';
import '../domain/services/haptic_service.dart';

/// Flutter implementation of [HapticService].
///
/// Maps [HapticFeedbackStyle] values to [HapticFeedback] static calls.
/// On web, macOS, Windows, and Linux the underlying platform call is a
/// silent no-op handled by the Flutter engine.
final class HapticServiceImpl implements HapticService {
  const HapticServiceImpl();

  @override
  Future<void> perform(HapticFeedbackStyle style) => switch (style) {
        HapticFeedbackStyle.lightImpact => HapticFeedback.lightImpact(),
        HapticFeedbackStyle.mediumImpact => HapticFeedback.mediumImpact(),
        HapticFeedbackStyle.heavyImpact => HapticFeedback.heavyImpact(),
        HapticFeedbackStyle.selectionClick => HapticFeedback.selectionClick(),
      };
}
