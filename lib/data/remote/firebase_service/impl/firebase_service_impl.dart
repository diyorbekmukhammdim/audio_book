import 'package:audio_book/data/remote/firebase_service/firebase_service.dart';
import 'package:audio_book/domain/models/book_model.dart';
import 'package:audio_service/audio_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';

class FirebaseServiceImpl extends FirebaseService{
  final storage = FirebaseStorage.instance;
  @override
  Future<List<String>> getBooksData() async {
    try {
      final data = await storage.ref('audios/').listAll();
      return (data.prefixes.map((e) => e.name).toList());
    } catch(e){
      rethrow;
    }
  }

  @override
  Future<List<BookAudioModel>> getSingleBookData({required String bookName}) async {
    try {
      final data = await storage.ref('audios/').child(bookName).listAll();
      var bookList = <BookAudioModel>[];
      for(var index = 0; index < data.items.length; index ++){
        final element = data.items[index];
        final url = await element.getDownloadURL();
        print(url);
        bookList.add(BookAudioModel(audioName: element.name, audioUrl: url,id:index.toString()));
      }
      /* data.items.map((e) async {
        final url = await  e.getDownloadURL();
        bookList.add(BookAudioModel(audioName: e.name, audioUrl: url));
      });*/
      return bookList;
    } catch(e){
      rethrow;
    }
  }

}