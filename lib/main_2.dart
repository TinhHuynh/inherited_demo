import 'dart:math';

import 'package:flutter/material.dart';

enum ThemeAspect { mode, fontSize }

void main() => runApp(const ThemeSwitcherApp());

class ThemeSwitcherApp extends StatelessWidget {
  const ThemeSwitcherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InheritedModelExample(),
    );
  }
}

class ThemeModel extends InheritedModel<ThemeAspect> {
  final bool isDarkMode;
  final double fontSize;

  const ThemeModel({super.key,
    required this.isDarkMode,
    required this.fontSize,
    required Widget child,
  }) : super(child: child);

  static ThemeModel? of(BuildContext context, {required ThemeAspect aspect}) {
    return InheritedModel.inheritFrom<ThemeModel>(context, aspect: aspect);
  }

  @override
  bool updateShouldNotify(ThemeModel oldWidget) {
    return isDarkMode != oldWidget.isDarkMode || fontSize != oldWidget.fontSize;
  }

  @override
  bool updateShouldNotifyDependent(ThemeModel oldWidget, Set<ThemeAspect> dependencies) {
    return (isDarkMode != oldWidget.isDarkMode && dependencies.contains(ThemeAspect.mode)) ||
        (fontSize != oldWidget.fontSize && dependencies.contains(ThemeAspect.fontSize));
  }
}

class InheritedModelExample extends StatefulWidget {
  const InheritedModelExample({Key? key}) : super(key: key);

  @override
  State<InheritedModelExample> createState() => _InheritedModelExampleState();
}

class _InheritedModelExampleState extends State<InheritedModelExample> {
  bool isDarkMode = false;
  double fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return ThemeModel(
      isDarkMode: isDarkMode,
      fontSize: fontSize,
      child: Scaffold(
        appBar: AppBar(title: const Text('Theme Switcher App')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                  child: const Text('Toggle Theme'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fontSize = fontSize == 16.0 ? 20.0 : 16.0;
                    });
                  },
                  child: const Text('Toggle Font Size'),
                ),
              ],
            ),
            const ThemeModeText(),
            const FontSizeText(),
            const IdontCareWidget(),
          ],
        ),
      ),
    );
  }
}

// Hiển thị theme mode (dark mode, bright mode)
class ThemeModeText extends StatelessWidget {
  const ThemeModeText({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = ThemeModel.of(context, aspect: ThemeAspect.mode)!;
    final themeModeText = themeModel.isDarkMode ? 'Dark Mode' : 'Light Mode';

    final randomColor = getRandomColor();
    final textColor = themeModel.isDarkMode ? Colors.white : Colors.black;

    return Text(
      'Theme Mode: $themeModeText',
      style: TextStyle(fontSize: 18, color: textColor, backgroundColor: randomColor),
    );
  }
}

// Hiển thị font size
class FontSizeText extends StatelessWidget {
  const FontSizeText({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = ThemeModel.of(context, aspect: ThemeAspect.fontSize)!;

    final randomColor = getRandomColor();
    final textColor = themeModel.isDarkMode ? Colors.white : Colors.black;

    return Text(
      'Font Size: ${themeModel.fontSize}',
      style: TextStyle(fontSize: 18, color: textColor, backgroundColor: randomColor),
    );
  }
}

// Cái tên nói lên tất cả :)
class IdontCareWidget extends StatelessWidget {
  const IdontCareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'I don\'t care',
      style: TextStyle(fontSize: 18, backgroundColor: getRandomColor()),
    );
  }
}

Color getRandomColor() {
  final random = Random();
  return Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
}