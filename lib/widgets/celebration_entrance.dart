import 'package:flutter/material.dart';

/// Staggered fade / slide / scale entrance (habit completed, backup flows).
class CelebrationEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const CelebrationEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<CelebrationEntrance> createState() => _CelebrationEntranceState();
}

class _CelebrationEntranceState extends State<CelebrationEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.16, 1, 0.3, 1),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(curve);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curve);
    _scale = Tween<double>(begin: 0.94, end: 1).animate(curve);

    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}
