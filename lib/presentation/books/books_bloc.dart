import 'package:audio_book/di/di.dart';
import 'package:audio_book/domain/repository/books/books_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/status.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc() : super(BooksState()) {
    final repository = getIt.get<BooksRepository>();
    on<GetAllBooksEvent>((event, emit) async {
    try{
      final data = await repository.getBooksData();
      emit(state.copyWith(status: Status.success,books: data));
    }catch(e){
      emit(state.copyWith(status: Status.fail,errorMessage: e.toString()));
    }
    });
  }
}
