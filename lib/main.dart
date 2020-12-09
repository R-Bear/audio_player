import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  /// for playing music or push
  bool playing = false;

  /// the main state of the play button
  // IconData playBtn = Icons.play_arrow;
  IconData playBtn = Icons.play_arrow;

  AudioPlayer _player;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  /// slider widget
  Widget slider() {
    return Container(
      width: 270,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  /// seek function
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    /// this function will allow us to get duration
    _player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };

    /// This function allow us to move the cursor of the slider
    _player.positionHandler = (p) {
      setState(() {
        position = p;
      });

      /// load file song to make playing song
      cache.load("music.mp3");
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[800],
              Colors.blue[200],
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 48),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Music player",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Listen to your favorite Music",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w200),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      image: DecorationImage(
                        image: AssetImage("assets/music.jpg"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Center(
                  child: Text(
                    "Khmeng Khmer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 500,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                                style: TextStyle(fontSize: 18),
                              ),
                              slider(),
                              Text(
                                "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 45,
                              color: Colors.blue[800],
                              onPressed: () {
                                // here function skip previous
                              },
                              icon: Icon(Icons.skip_previous),
                            ),
                            IconButton(
                              iconSize: 60,
                              color: Colors.blue[800],
                              onPressed: () {
                                /// here function play and pause
                                if (!playing) {
                                  cache.play("music.mp3");
                                  setState(() {
                                    playBtn = Icons.pause;
                                    playing = true;
                                  });
                                } else {
                                  setState(() {
                                    _player.pause();
                                    playBtn = Icons.play_arrow;
                                    playing = false;
                                  });
                                }
                              },
                              // icon: Icon(Icons.play_arrow),
                              icon: Icon(playBtn),
                            ),
                            IconButton(
                              iconSize: 45,
                              color: Colors.blue[800],
                              onPressed: () {
                                // here function skip next
                                playBtn;
                              },
                              icon: Icon(Icons.skip_next),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
