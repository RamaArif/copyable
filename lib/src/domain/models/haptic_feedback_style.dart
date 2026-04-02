/// Controls the haptic feedback style fired after a successful clipboard copy.
///
/// On Android and iOS the corresponding platform haptic is triggered.
/// On web, macOS, Windows, and Linux the call is a silent no-op handled by
/// the Flutter engine — no platform guards are needed.
enum HapticFeedbackStyle {
  /// A light impact haptic (default).
  lightImpact,

  /// A medium impact haptic.
  mediumImpact,

  /// A heavy impact haptic.
  heavyImpact,

  /// A selection-click haptic.
  selectionClick,
}
