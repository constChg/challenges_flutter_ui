import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ui_challenge/const/hongkong.dart';

class ParallaxEffectPage extends StatelessWidget {
  const ParallaxEffectPage({super.key});

  static const String title = 'Parallax Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ...ImagesLink.hkImages.entries
              .map((item) => buildImageTile(item.key, item.value, context))
              .toList(),
        ],
      ),
    );
  }

  Widget buildImageTile(String name, String url, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.network(
              url,
              fit: BoxFit.cover,
            ),
            const Positioned.fill(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.7, 0.9]))),
            ),
            Positioned(
                bottom: 20,
                left: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black)],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
