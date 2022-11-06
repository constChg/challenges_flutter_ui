import 'package:flutter/material.dart';
import 'package:ui_challenge/base_page.dart';
import 'package:ui_challenge/const/challenges_list.dart';
import 'package:ui_challenge/const/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChallengesHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ChallengesHomePage extends StatefulWidget {
  const ChallengesHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ChallengesHomePage> createState() => _ChallengesHomePageState();
}

class _ChallengesHomePageState extends State<ChallengesHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal.withOpacity(0.85),
        title: Text(widget.title),
      ),
      body: ListView(
          children: challengesBuilderMap.entries
              .map(
                (e) => Card(
                  child: ListTile(
                    leading: Text(
                      textAlign: TextAlign.center,
                      e.key,
                      style: StyleClass.tileLeadingTStyle,
                    ),
                    trailing: TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: e.value.answerBuilder)),
                        child: const Text(
                          'Submit Answer',
                          textAlign: TextAlign.center,
                          style: StyleClass.homeButtonTStyle,
                        )),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: e.value.solutionBuilder)),
                  ),
                ),
              )
              .toList()),
    );
  }
}
