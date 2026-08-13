import 'package:flutter/material.dart';

/// A widget that wraps its [child] with a pulsing Satin Gold security glow frame
/// when [isSecure] is true (i.e., screen capture is prevented / privacy masking is on).
///
/// The glow is rendered as an animated border using a [DecoratedBox] and
/// [AnimatedBuilder] driven by an internal [AnimationController].
class SecurityGlowFrame extends StatefulWidget {
  final Widget child;
  final bool isSecure;

  const SecurityGlowFrame({
    super.key,
    required this.child,
    required this.isSecure,
  });

  @override
  State<SecurityGlowFrame> createState() => _SecurityGlowFrameState();
}

class _SecurityGlowFrameState extends State<SecurityGlowFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  static const _satinGold = Color(0xFFD4AF37);
  static const _glowWidth = 2.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.isSecure) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SecurityGlowFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSecure && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isSecure && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSecure) return widget.child;

    return AnimatedBuilder(
      key: const Key('security_glow_frame'),
      animation: _pulse,
      builder: (context, child) {
        final glowOpacity = 0.35 + _pulse.value * 0.50;
        final spreadRadius = 1.0 + _pulse.value * 3.0;
        final blurRadius = 6.0 + _pulse.value * 10.0;

        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: _satinGold.withOpacity(glowOpacity),
              width: _glowWidth,
            ),
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              // Inner glow
              BoxShadow(
                color: _satinGold.withOpacity(glowOpacity * 0.6),
                blurRadius: blurRadius,
                spreadRadius: spreadRadius,
              ),
              // Outer ambient glow
              BoxShadow(
                color: _satinGold.withOpacity(glowOpacity * 0.25),
                blurRadius: blurRadius * 2.5,
                spreadRadius: spreadRadius * 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
