import 'package:flutter/material.dart';
import 'viewmodels/library_view_model.dart';
import 'views/library_screen.dart';

void main() {
  final viewModel = LibraryViewModel();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LibraryScreen(viewModel: viewModel),
  ));
}