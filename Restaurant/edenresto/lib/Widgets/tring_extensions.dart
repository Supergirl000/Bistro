// string_extensions.dart
extension StringCapitalization on String {
  // Method to capitalize the first letter of the string
  String capitalize() {
    if (isEmpty) {
      return this; // Return the original string if it's empty
    }
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
