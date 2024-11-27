import 'package:audio_book/data/remote/firebase_service/firebase_service.dart';
import 'package:audio_book/di/di.dart';
import 'package:audio_book/domain/models/book_model.dart';
import 'package:audio_book/domain/repository/books/books_repository.dart';

class BooksRepositoryImpl extends BooksRepository{
  final service = getIt.get<FirebaseService>();
  @override
  Future<List<String>> getBooksData() async {
    try{
      return service.getBooksData();
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<List<BookAudioModel>> getSingleBookData({required String bookName}) {
   try{
     return service.getSingleBookData(bookName: bookName);
   }catch(e){
     rethrow;
   }
  }

}