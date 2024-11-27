import 'package:audio_book/domain/models/book_model.dart';

abstract class FirebaseService{
  Future<List<String>> getBooksData();
  Future<List<BookAudioModel>> getSingleBookData({required String bookName});
}