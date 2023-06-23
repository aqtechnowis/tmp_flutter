import 'package:flutter/material.dart';
import 'package:tmp_flutter/widgets/images_slider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Flexible(
            child: ImagesSlider(
              const [
                'https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg?w=2000',
                'https://wallpapers.com/images/featured/2ygv7ssy2k0lxlzu.jpg',
                'https://images.unsplash.com/photo-1618588507085-c79565432917?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmVhdXRpZnVsJTIwbmF0dXJlfGVufDB8fDB8fHww&w=1000&q=80'
              ],
              pageController: PageController(initialPage: 0),
              fillBoxWithoutAspectRatio: false,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Flexible(
            child: Column(
                children: List.filled(7, 0)
                    .map((e) => Text(DateTime.now().toString()))
                    .toList()),
          )
        ],
      ),
    );
  }
}
