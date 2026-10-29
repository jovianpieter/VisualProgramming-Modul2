import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../models/loan.dart';
import '../models/library_repository.dart';
import 'dart:async';

class LibraryViewModel extends ChangeNotifier {
  List<Book> _books = [];
  List<Loan> _loans = [];
  final LibraryRepository _repository = LibraryRepository();
  String? currentStudentId;
  DateTime waktuSimulasi = DateTime.now();
  Timer? _timer;
  List<Book> get books => _books;
  List<Loan> get loans => _loans;

  void setStudentId(String studentId) {
    currentStudentId = studentId;
    notifyListeners();
  }
  void simulasiWaktu() {
    waktuSimulasi = DateTime.now();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      waktuSimulasi = waktuSimulasi.add(const Duration(days: 1));
      notifyListeners();
    });
  }
  Future<void> memuatData() async {
    _books = await _repository.ambilDaftarBuku();
    notifyListeners();
  }
  void borrowBook(String bookId){
    if (currentStudentId == null || currentStudentId!.isEmpty) return;
    final book = _books.firstWhere((item) => item.id == bookId);
    if(!book.isAvailable) return;
    book.isAvailable = false;
    final borrowingDate = waktuSimulasi;
    final dueDate = borrowingDate.add(const Duration(days: 6));

    _loans.add(Loan(
      loanId: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      studentId: currentStudentId!,
      borrowingDate: borrowingDate,
      dueDate: dueDate,
    ));
    notifyListeners();
  }
  void returnBook(String loanId){
    final loan = _loans.firstWhere((pinjam) => pinjam.loanId == loanId);
    if(loan.returnDate != null) return;
    loan.returnDate = waktuSimulasi;
    final book = _books.firstWhere((buku) => buku.id ==loan.bookId);
    if(!isBookMissing(loan)){
      book.isAvailable = true;
    }
    notifyListeners();
  }
  double calculateFine(Loan loan){
    final dateToCompare = loan.returnDate ?? waktuSimulasi;
    final lewat6Bulan = DateTime(loan.dueDate.year, loan.dueDate.month + 6, loan.dueDate.day);
    if(dateToCompare.isBefore(loan.dueDate) || dateToCompare.isAtSameMomentAs(loan.dueDate)){
      return 0.0;
    }
    DateTime batasAkhirDenda = dateToCompare;
    if (dateToCompare.isAfter(lewat6Bulan) || dateToCompare.isAtSameMomentAs(lewat6Bulan)) {
      batasAkhirDenda = lewat6Bulan;
    }
    final effectiveOverdueDays = batasAkhirDenda.difference(loan.dueDate).inDays;
    double totalDenda = 0.0;
    final overdueDays = dateToCompare.difference(loan.dueDate).inDays;
    for (int i = 1; i <= effectiveOverdueDays; i++){
      int hariKeSejakPinjam = i + 6;
      int mingguBerapa = hariKeSejakPinjam ~/ 7;
      totalDenda += (mingguBerapa * 5000).toDouble();
    }
    if (isBookMissing(loan)) {
      final book = _books.firstWhere((buku) => buku.id == loan.bookId);
      totalDenda += book.replacementPrice;
    }
    return totalDenda;
  }
  bool isBookMissing(Loan loan){
    final dateToCompare = loan.returnDate ?? waktuSimulasi;
    final lewat6Bulan = DateTime(loan.dueDate.year,loan.dueDate.month + 6,loan.dueDate.day);
    return dateToCompare.isAfter(lewat6Bulan) || dateToCompare.isAtSameMomentAs(lewat6Bulan);
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  String getStatusBukuDiKatalog(Book book) {
    if (book.isAvailable) return "Tersedia";
    try {
      final pinjamanTerakhir = _loans.lastWhere((loan) => loan.bookId == book.id);
      if (isBookMissing(pinjamanTerakhir)) {
        return "Hilang";
      }
    } catch (e) {}
    return "Sedang Dipinjam";
  }
}