import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class GradientAnimated extends StatefulWidget {
  final Widget child;

  const GradientAnimated({Key? key, required this.child}) : super(key: key);

  @override
  _GradientAnimatedState createState() => _GradientAnimatedState();
}

class _GradientAnimatedState extends State<GradientAnimated> {
  final TimelineTween _tween = TimelineTween<_AnimationEnum>()
    ..addScene(
      begin: Duration.zero,
      end: const Duration(seconds: 3),
    ).animate(_AnimationEnum.color1,
        tween: ColorTween(begin: Colors.blueGrey, end: Colors.lightBlue))
    ..addScene(
      end: const Duration(seconds: 1),
      begin: Duration.zero
    ).animate(_AnimationEnum.color2,
        tween: ColorTween(begin: Colors.lightBlue, end: Colors.pinkAccent))
    ..addScene(
      begin: Duration.zero,
      end: const Duration(seconds: 1),
    ).animate(_AnimationEnum.color3,
        tween: ColorTween(begin: Colors.pinkAccent, end: Colors.pink));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MirrorAnimation<TimelineValue>(
        tween: _tween,
        duration: _tween.duration,
        builder: (context, child, value) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.topCenter,
                colors: [
                  value.get(_AnimationEnum.color1),
                  value.get(_AnimationEnum.color2),
                  value.get(_AnimationEnum.color3)
                ],
              ),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

enum _AnimationEnum {
  color1,
  color2,
  color3,
}
