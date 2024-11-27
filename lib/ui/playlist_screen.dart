import 'package:audio_book/presentation/player/player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/status.dart';
import 'audio_player_screen.dart';

class PlaylistScreen extends StatelessWidget {
  final String bookName;

  const PlaylistScreen({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<PlayerBloc, PlayerState>(
            builder: (context, state) {
              switch (state.status) {
                case Status.success:
                  {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bookName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),

                            ],
                          ),
                        ),


                        Expanded(
                          child: ListView.builder(
                            itemCount: state.chapters!.length,
                            itemBuilder: (context, index) {
                              final track = state.chapters![index];
                              final isPlaying = index == -1;

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2),
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      color: isPlaying
                                          ? Colors.pinkAccent
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  track.audioName,
                                  style: TextStyle(
                                    color: isPlaying
                                        ? Colors.pinkAccent
                                        : Colors.white,
                                    fontWeight: isPlaying
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(
                                  bookName,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                                onTap: () {

                                  context.read<PlayerBloc>().add(AddToQueEvent(index: index));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const AudioPlayerScreen()),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                case null:
                // TODO: Handle this case.
                case Status.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case Status.fail:
                  return Center(
                    child: Text(state.errorMessage ?? 'ERROR'),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
