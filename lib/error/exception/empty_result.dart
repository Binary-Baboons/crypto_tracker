class EmptyResultException implements Exception {
  @override
  String toString() {
    return "No results found :(";
  }
}