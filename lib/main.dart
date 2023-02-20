import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_2048/game_logic/board.dart';
import 'package:game_2048/game_logic/game.dart';
import 'package:game_2048/game_logic/stats.dart';
import 'package:game_2048/pages/home/home_page.dart';
import 'package:game_2048/utils/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Board>(create: (context) => Board()),
        ChangeNotifierProvider<Stats>(create: (context) => Stats()),
        ChangeNotifierProvider<Game>(create: (context) => Game()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '2048',
        theme: buildTheme(),
        home: const HomePage(),
      ),
    );
  }
}
