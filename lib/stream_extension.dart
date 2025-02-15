/// Extension for safely retrieving the first element from a `Stream<T>`.
///
/// This prevents errors when calling `.first` on an empty stream.
extension StreamUtils<T> on Stream<T> {
  /// Returns the first element of the stream, or `null` if the stream is empty.
  ///
  /// This is useful for avoiding `Bad state: No element` errors when
  /// reading files with `Stream<List<int>>`.
  Future<T?> firstOrNull() async {
    try {
      return await first;
    } catch (_) {
      return null; // Returns null instead of throwing an exception
    }
  }
}
