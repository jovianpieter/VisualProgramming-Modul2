import 'package:flutter/services.dart';

class LibraryService {
  Future<String> fetchBooksJson() async {
    await Future.delayed(const Duration(seconds: 1));
    final String response = await rootBundle.loadString('book.json');
    return response;
  }
}