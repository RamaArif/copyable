import 'package:flutter/widgets.dart';

import '../domain/models/copyable_theme_data.dart';

/// An [InheritedWidget] that provides app-wide defaults for all [Copyable]
/// and [CopyableBuilder] widgets in the subtree.
///
/// Per-widget values always take precedence over theme values.
///
/// ```dart
/// CopyableTheme(
///   data: CopyableThemeData(
///     snackBarText: 'Copied to clipboard',
///     snackBarDuration: Duration(seconds: 3),
///     clearAfter: Duration(seconds: 30),
///   ),
///   child: Scaffold(
///     body: Copyable.text('TXN-9182736'),
///   ),
/// )
/// ```
class CopyableTheme extends InheritedWidget {
  const CopyableTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The theme data provided to descendant widgets.
  final CopyableThemeData data;

  /// Returns the [CopyableThemeData] from the nearest [CopyableTheme] ancestor.
  ///
  /// Falls back to [CopyableThemeData] with all defaults when no
  /// [CopyableTheme] is present in the tree.
  static CopyableThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<CopyableTheme>();
    return theme?.data ?? const CopyableThemeData();
  }

  @override
  bool updateShouldNotify(CopyableTheme oldWidget) => data != oldWidget.data;
}
