import 'package:flutter/material.dart';
import '../viewmodels/library_view_model.dart';
import 'bookcard_screen.dart';
import 'loancard_screen.dart';

class LibraryScreen extends StatefulWidget{
  final LibraryViewModel viewModel;
  const LibraryScreen({Key? key, required this.viewModel}) : super(key : key);
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>{
  @override
  void initState(){
    super.initState();
    widget.viewModel.memuatData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tampilkanDialogLogin();
    });
  }
  void _tampilkanDialogLogin() {
    final TextEditingController _idController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Autentikasi Peminjam'),
        content: TextField(
          controller: _idController,
          decoration: const InputDecoration(
            labelText: 'Masukkan Student ID',
            hintText: 'Contoh: 2086022510060',
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_idController.text.isNotEmpty) {
                widget.viewModel.setStudentId(_idController.text);
                widget.viewModel.simulasiWaktu();
                Navigator.pop(context);
              }
            },
            child: const Text('Masuk'),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Perpustakaan Universitas'),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Katalog Buku'),
                    Tab(text: 'Buku dipinjam'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _buildTabKatalog(),
                  _buildTabPinjaman(),
                ],
              ),
            ),
          );
        }
    );
  }
  Widget _buildTabKatalog(){
    if(widget.viewModel.books.isEmpty){
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: widget.viewModel.books.length,
        itemBuilder: (context, index){
          final book = widget.viewModel.books[index];
          return BookCard(book: book, viewModel: widget.viewModel);
        }
    );
  }
  Widget _buildTabPinjaman(){
    if(widget.viewModel.loans.isEmpty){
      return const Center(child: Text('Belum ada riwayat peminjaman'));
    }
    return ListView.builder(
        itemCount: widget.viewModel.loans.length,
        itemBuilder: (context, index){
          final loan = widget.viewModel.loans[index];
          return LoanCard(loan: loan, viewModel: widget.viewModel);
        }
    );
  }
}