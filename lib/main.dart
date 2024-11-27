import 'package:audio_book/di/di.dart';
import 'package:audio_book/presentation/books/books_bloc.dart';
import 'package:audio_book/presentation/player/player_bloc.dart';
import 'package:audio_book/ui/books_screen.dart';
import 'package:audio_book/utils/audio_handler.dart';
import 'package:audio_book/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
late MyAudioHandler playerService;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setup();
  runApp( BlocProvider(
  create: (context) => PlayerBloc(),
  child: const MyApp(),
));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    context.read<PlayerBloc>().add(DisposeEvent());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  BlocProvider(
  create: (context) => BooksBloc()..add(GetAllBooksEvent()),
  child: const BooksScreen(),
),
    );
  }
}
