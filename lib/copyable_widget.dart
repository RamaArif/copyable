/// Zero-boilerplate clipboard copy for any Flutter widget or text.
///
/// ## Quick start
/// ```dart
/// import 'package:copyable_widget/copyable_widget.dart';
///
/// // Copy text with a single line
/// Copyable.text("TXN-9182736")
///
/// // Wrap any widget
/// Copyable(
///   value: accountNumber,
///   child: AccountNumberRow(...),
/// )
///
/// // Fully custom copy UI with isCopied state
/// CopyableBuilder(
///   value: walletAddress,
///   builder: (context, isCopied) => Icon(
///     isCopied ? Icons.check : Icons.copy_rounded,
///   ),
/// )
/// ```
library copyable_widget;

// Public models
export 'src/domain/models/copyable_action_mode.dart';
export 'src/domain/models/copyable_event.dart';
export 'src/domain/models/copyable_feedback.dart';
export 'src/domain/models/copyable_theme_data.dart';
export 'src/domain/models/haptic_feedback_style.dart';

// Public widgets
export 'src/presentation/copyable.dart';
export 'src/presentation/copyable_builder.dart';
export 'src/presentation/copyable_text.dart';
export 'src/presentation/copyable_theme.dart';
