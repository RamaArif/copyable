import 'copyable_action_mode.dart';

/// Describes a completed clipboard copy action.
///
/// Passed to [CopyableFeedback.custom] so the developer has full context
/// about what was copied and how it was triggered.
final class CopyableEvent {
  const CopyableEvent({
    required this.value,
    required this.timestamp,
    required this.mode,
  });

  /// The string that was written to the clipboard.
  final String value;

  /// When the copy occurred.
  final DateTime timestamp;

  /// Whether the copy was triggered by a tap or a long-press.
  final CopyableActionMode mode;

  @override
  String toString() =>
      'CopyableEvent(value: $value, timestamp: $timestamp, mode: $mode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CopyableEvent &&
          other.value == value &&
          other.timestamp == timestamp &&
          other.mode == mode;

  @override
  int get hashCode => Object.hash(value, timestamp, mode);
}
