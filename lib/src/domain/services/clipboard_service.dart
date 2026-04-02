/// Abstract interface for writing text to the system clipboard.
abstract interface class ClipboardService {
  /// Copies [value] to the system clipboard.
  Future<void> copy(String value);
}
