import '../../models/book_model.dart';

abstract class BooksRepository{
  Future<List<String>> getBooksData();
  Future<List<BookAudioModel>> getSingleBookData({required String bookName});
}