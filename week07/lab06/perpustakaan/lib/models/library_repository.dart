import 'dart:convert';
import 'book.dart';
import 'library_service.dart';

class LibraryRepository {
  final LibraryService _service = LibraryService();

  Future<List<Book>> ambilDaftarBuku() async {
    try {
      final String jsonMentah = await _service.fetchBooksJson();
      List<dynamic> decodedJson = jsonDecode(jsonMentah);
      return decodedJson.map((item) => Book.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }
}