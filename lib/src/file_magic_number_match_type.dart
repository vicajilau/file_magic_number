/// Defines how a magic number should be matched within a file's byte sequence.
///
/// This enum is used internally by the library to determine whether a magic number
/// should be matched exactly at the beginning of the file (`exact`)
/// or if it can appear at any position within a predefined range (`offset`).
enum FileMagicNumberMatchType { exact, offset }
