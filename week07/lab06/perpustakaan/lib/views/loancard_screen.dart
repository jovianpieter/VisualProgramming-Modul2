import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../viewmodels/library_view_model.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final LibraryViewModel viewModel;
  const LoanCard({Key? key, required this.loan, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = viewModel.books.firstWhere((b) => b.id == loan.bookId);
    final denda = viewModel.calculateFine(loan);
    final isMissing = viewModel.isBookMissing(loan);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(book.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Peminjam: ${loan.studentId}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Dipinjam: ${loan.borrowingDate.toString().split(' ')[0]}'),
            Text('Tenggat: ${loan.dueDate.toString().split(' ')[0]}'),
            if (isMissing) ...[
              Text('denda: Rp ${denda - book.replacementPrice}', style: const TextStyle(color: Colors.orange)),
              Text('buku baru: Rp ${book.replacementPrice}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Status: BUKU HILANG', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ] else ...[
              Text('Total denda: Rp $denda', style: TextStyle(color: denda > 0 ? Colors.orange : Colors.grey)),
              if (loan.returnDate != null)
                Text('Dikembalikan pada: ${loan.returnDate!.toString().split(' ')[0]}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
        trailing: isMissing
            ? const SizedBox.shrink()
            : ElevatedButton(
          onPressed: loan.returnDate == null ? () => viewModel.returnBook(loan.loanId) : null,
          child: const Text('Kembali'),
        ),
      ),
    );
  }
}