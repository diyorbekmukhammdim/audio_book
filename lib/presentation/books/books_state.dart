part of 'books_bloc.dart';

class BooksState {
  final Status? status;
  final List<String>? books;
  final String? errorMessage;

  BooksState({ this.status,  this.books, this.errorMessage});

  BooksState copyWith({Status? status, List<String>? books, String? errorMessage}) =>
      BooksState(status: status ?? this.status, books: books ?? this.books,errorMessage: errorMessage ?? this.errorMessage);
}
