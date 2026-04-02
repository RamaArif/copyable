import '../models/haptic_feedback_style.dart';

/// Abstract interface for triggering device haptic feedback.
abstract interface class HapticService {
  /// Triggers haptic feedback matching [style].
  ///
  /// On platforms without haptic hardware the call is a silent no-op.
  Future<void> perform(HapticFeedbackStyle style);
}
