import 'package:audio_book/data/remote/firebase_service/firebase_service.dart';
import 'package:audio_book/data/remote/firebase_service/impl/firebase_service_impl.dart';
import 'package:audio_book/domain/repository/books/books_repository.dart';
import 'package:audio_book/domain/repository/books/books_repository_impl.dart';
import 'package:audio_book/utils/audio_handler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseServiceImpl());
  getIt.registerLazySingleton<BooksRepository>(() => BooksRepositoryImpl());
  getIt.registerSingleton<AudioHandler>(await initAudioService());

}
