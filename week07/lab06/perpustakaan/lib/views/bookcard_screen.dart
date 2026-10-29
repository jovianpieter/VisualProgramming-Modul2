import 'package:flutter/material.dart';
import '../models/book.dart';
import '../viewmodels/library_view_model.dart';
import '../models/loan.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final LibraryViewModel viewModel;
  const BookCard({Key? key, required this.book, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(book.title),
        subtitle: Text('Status: ${viewModel.getStatusBukuDiKatalog(book)}'),
        trailing: ElevatedButton(
          onPressed: book.isAvailable ? () => viewModel.borrowBook(book.id) : null,
          child: const Text('Pinjam'),
        ),
      ),
    );
  }
}