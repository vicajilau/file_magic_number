## 1.3.1
* Improved file detection.
* Reorganized code and update dependencies.

## 1.3.0
* Added HEIC (High Efficiency Image Coding) support, part of the HEIF (High Efficiency Image File) format.
* **Breaking change:** Resolved an issue with imports where private files are exposed to be imported.
* Individual files can be dragged and dropped on desktop apps and web app on example project.

## 1.2.2
* Updated documentation.
* Updated dependencies from example project.
* Removed cocoapods from example project.

## 1.2.1
* Increased support for Dart from version 3.4.

## 1.2.0
* Updated example project dependencies
* Improved tests
* Improved example project flow and style
* Added `getBytesFromPathOrBlob` method returning `Uint8List` object.

## 1.1.1
* Minor improvements.
* Added more documentation.

## 1.1.0
* Added `detectFileTypeFromPathOrBlob` method.
* Improved documentation.

## 1.0.0
* **BREAKING CHANGE:** `MagicNumber` has been renamed to `FileMagicNumber`.
* **BREAKING CHANGE:** `MagicNumberType` has been renamed to `FileMagicNumberType`.
* **BREAKING CHANGE:** `detectFileType` has been renamed to `detectFileTypeFromBytes`.

## 0.8.0
* Simplified CI.
* Improved CD.
* Fixed readme.
* Migrated from Dart to Flutter package.

## 0.7.2
* Improved `MagicNumberMatchType` for offset and exact detection.
* Clearer documentation improvements.

## 0.7.1
* Fixed documentation with `file_picker`dependency.

## 0.7.0
* Fixed bytes in example project.
* Fixed mp4 were not detected properly.
* Created offset and regular file type detection.
* Added `MagicNumberMatchType` for offset and exact detection.

## 0.6.0
* Added much more formats.
* Improved documentation.
* Simplified verification.
* Added tests for each format.
* Added debug utilities.
* Very large files are shortened to the first few bytes to speed up the library. This means up to +10x faster on large files.

## 0.5.1
* Fixed image on pub.dev

## 0.5.0
* Added coverage in CI
* Added more test
* Improved readme
* Created as Dart package

## 0.4.0
### General
* Update dependencies on example project.
* Updated readme.

## 0.3.1
### General
* Some minor improvements.

## 0.3.0
### General
* Refactored structure.
* **BREAKING CHANGE:** `detectFileType` use a `Uint8List` instead of a `String` as parameter doing it universal.
### Web
* Added web development.


## 0.2.0
### General
* Example improvements.
* **BREAKING CHANGE:** Returns `MagicNumberType` when detectFileType is called.

## 0.1.0
### General
* Added CI.
* Added Example project.
* Added Readme.
* Added documentation.
* Added test.
