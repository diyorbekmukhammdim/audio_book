import 'package:audio_book/utils/status.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/player/player_bloc.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 40),
                            Container(
                                height: 250,
                                width: 250,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Container()
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Book",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              state.currentAudioTitle ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            Column(
                              children: [
                                ProgressBar(
                                  baseBarColor: Colors.white,
                                  progress: state.progressBarState.current,
                                  buffered: state.progressBarState.buffered,
                                  total: state.progressBarState.total,
                                  onSeek: (value) {
                                    context.read<PlayerBloc>().add(
                                        UpdateSeekPositionEvent(
                                            position: value));
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.read<PlayerBloc>().add(
                                        ShuffleEvent());
                                  },
                                  icon: state.isShuffle ? const Icon(Icons.shuffle) : const Icon(Icons.shuffle,color: Colors.grey,),
                                  color: Colors.white,
                                  iconSize: 28,
                                ),
                                IconButton(
                                  onPressed: () {
                                      context.read<PlayerBloc>().add(PrevEvent());

                                  },
                                  icon: const Icon(Icons.skip_previous),
                                  color: Colors.white,
                                  iconSize: 36,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      context.read<PlayerBloc>().add(
                                          state.playButtonState ==
                                              ButtonState.playing
                                              ? PauseEvent()
                                              : PlayEvent());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(15),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: switch(state.playButtonState){
                                      ButtonState.loading =>
                                          Container(
                                            margin: const EdgeInsets.all(8.0),
                                            width: 32.0,
                                            height: 32.0,
                                            child: const CircularProgressIndicator(),
                                          ),


                                    ButtonState.paused => const Icon(Icons
                                        .play_arrow,
                                    size: 36,
                                    color: Colors.deepPurple,
                                    ),
                                    ButtonState.playing => const Icon(
                                    Icons.pause ,
                                    size: 36,
                                    color: Colors.deepPurple,
                                    ),
                                    }
                                ),
                                IconButton(
                                  onPressed: () {

                                      context.read<PlayerBloc>().add(NextEvent());

                                  },
                                  icon: const Icon(Icons.skip_next),
                                  color: Colors.white,
                                  iconSize: 36,
                                ),
                                Builder(
                                  builder: (context) {
                                    Icon icon;
                                    switch (state.repeatState) {
                                      case RepeatState.off:
                                        icon = const Icon(Icons.repeat, color: Colors.grey);
                                        break;
                                      case RepeatState.repeatSong:
                                        icon = const Icon(Icons.repeat_one);
                                        break;
                                      case RepeatState.repeatPlaylist:
                                        icon = const Icon(Icons.repeat);
                                        break;
                                    }
                                    return IconButton(
                                      icon: icon,
                                      onPressed: (){context.read<PlayerBloc>().add(RepeatEvent());},
                                    );
                                    return IconButton(
                                      onPressed: () {
                                        context.read<PlayerBloc>().add(
                                            RepeatEvent());
                                      },
                                      icon:  const Icon(Icons.repeat),
                                      color: Colors.white,
                                      iconSize: 28,
                                    );
                                  }
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ],
                    );
                  }
                case null:
                  return const Center(child: CircularProgressIndicator(),);
                case Status.loading:
                  return const Center(child: CircularProgressIndicator(),);
                case Status.fail:
                  return const Center(child: Text('ERROR'),);
              }
            },
          ),
        ),
      ),
    );
  }
}
