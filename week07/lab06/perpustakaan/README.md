# 1. What is the difference between the Model, View, and ViewModel in this application?
Model digunakan hanya untuk menyimpan data yang dibutuhkan oleh viewmodel, viewmodel dipakai untuk membuat logika aplikasi seperti hitungan atau apapun yang berhubungan dengan data yang akan digunakan untuk view. Kemudian view hanya digunakan untuk menampilkan screen kepada user di view tetap bisa menggunakan logika tetapi hanya yang berhubungan dengan screennya.
# 2. What should happen if a student attempts to borrow a book that already has an active loan?
Akan di tolak oleh sistemnya karena sudah diatur jika bukunya sudah dipinjamkan ke murid maka tombol pinjamnya akan tidak aktif yang dimana memakai true or false. di project ini semua bukunya memakai isAvailable(true or false).
# 3. Why is it better to calculate the fine in one place rather than repeating the formula in multiple widgets?
agar tidak panjang line kodenya sehingga lebih bagus jika dibuat methodnya sendiri kemudian tinggal dipanggil oleh widget lain yang membutuhkannya. Dan juga agar hitungannya konsisten di semua widget takutnya ada yang berbeda.
# 4. What is the difference between a book being Overdue and being Missing?
kalau overdue artinya sudah lewat dari batas peminjaman yaitu lebih dari 7 hari. sedangkan jika missing maka bukunya dianggap menghilang karena sudah lebih dari 6 bulan overduenya.
# 5. If the university changes its weekly fine from Rp5,000 to Rp7,000, how should the app be updated?
maka di update di folder viewmodels bagian method calculateFine hitungan dendanya diubah menjadi 7000 per minggu 