import 'package:flutter/material.dart';

class AnimatedImage extends StatefulWidget {
  final String image1;
  final String image2;

  const AnimatedImage({Key? key, required this.image1, required this.image2})
      : super(key: key);

  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 0.1),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(widget.image1),
        SlideTransition(
          position: _animation,
          child: Image.asset(widget.image2),
        ),
      ],
    );
  }
}
