import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animate_do/animate_do.dart' as animate_do;
import 'package:shimmer/shimmer.dart';
import 'package:blur/blur.dart';
import '../theme/modern_theme_2026.dart';

/// 🔥 AUTOMOTIVE GLASS CONTAINER - TESLA STYLE
class AutomotiveGlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;

  const AutomotiveGlassContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius,
    this.blur = 10,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: width,
      height: height,
      borderRadius: borderRadius?.topLeft.x ?? 16,
      blur: blur,
      alignment: Alignment.bottomCenter,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity * 0.5),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: child,
    );
  }
}

/// 🚀 NEON GLOW BUTTON - FUTURISTIC
class NeonGlowButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final Color glowColor;
  final double width;
  final double height;

  const NeonGlowButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.glowColor = AutomotiveTheme.corporateBlue,
    this.width = double.infinity,
    this.height = 56,
  });

  @override
  State<NeonGlowButton> createState() => _NeonGlowButtonState();
}

class _NeonGlowButtonState extends State<NeonGlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [widget.glowColor, widget.glowColor.withOpacity(0.8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withOpacity(_glowAnimation.value * 0.6),
                  blurRadius: 20 * _glowAnimation.value,
                  spreadRadius: 2 * _glowAnimation.value,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.white),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    widget.text,
                    style: AutomotiveTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ⚡ ANIMATED SPEED GAUGE - REAL-TIME
class AnimatedSpeedGauge extends StatefulWidget {
  final double value; // 0-100
  final String label;
  final Color color;
  final double size;

  const AnimatedSpeedGauge({
    super.key,
    required this.value,
    required this.label,
    this.color = AutomotiveTheme.corporateBlue,
    this.size = 120,
  });

  @override
  State<AnimatedSpeedGauge> createState() => _AnimatedSpeedGaugeState();
}

class _AnimatedSpeedGaugeState extends State<AnimatedSpeedGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedSpeedGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animate_do.FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              widget.color.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: widget.size * 0.9,
              height: widget.size * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AutomotiveTheme.surfaceGray,
                  width: 3,
                ),
              ),
            ),
            
            // Animated progress
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size * 0.9, widget.size * 0.9),
                  painter: SpeedGaugePainter(
                    progress: _animation.value / 100,
                    color: widget.color,
                  ),
                );
              },
            ),
            
            // Center text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Text(
                      '${_animation.value.toInt()}',
                      style: AutomotiveTheme.textTheme.headlineMedium?.copyWith(
                        color: widget.color,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                Text(
                  widget.label,
                  style: AutomotiveTheme.textTheme.bodySmall?.copyWith(
                    color: AutomotiveTheme.textGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SpeedGaugePainter extends CustomPainter {
  final double progress;
  final Color color;

  SpeedGaugePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final Paint backgroundPaint = Paint()
      ..color = AutomotiveTheme.surfaceGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [color, color.withOpacity(0.6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Draw background
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress
    const startAngle = -90 * 3.14159 / 180;
    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 🌊 LIQUID LOADING INDICATOR
class LiquidLoadingIndicator extends StatefulWidget {
  final double size;
  final Color color;

  const LiquidLoadingIndicator({
    super.key,
    this.size = 60,
    this.color = AutomotiveTheme.corporateBlue,
  });

  @override
  State<LiquidLoadingIndicator> createState() => _LiquidLoadingIndicatorState();
}

class _LiquidLoadingIndicatorState extends State<LiquidLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color, widget.color.withOpacity(0.3)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔊 PULSE ANIMATION WIDGET
class PulseWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color pulseColor;

  const PulseWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.pulseColor = AutomotiveTheme.corporateBlue,
  });

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.pulseColor.withOpacity(0.3),
                  blurRadius: 10 * (_animation.value - 1.0) * 10,
                  spreadRadius: 2 * (_animation.value - 1.0) * 5,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }
}

/// 💎 SHIMMER LOADING CARD
class ShimmerLoadingCard extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerLoadingCard({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AutomotiveTheme.surfaceGray,
      highlightColor: AutomotiveTheme.surfaceGray,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AutomotiveTheme.surfaceGray,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// 🌟 FLOATING ACTION BUTTON - NEON STYLE
class NeonFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  const NeonFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color = AutomotiveTheme.corporateBlue,
  });

  @override
  State<NeonFloatingActionButton> createState() =>
      _NeonFloatingActionButtonState();
}

class _NeonFloatingActionButtonState extends State<NeonFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animate_do.BounceInUp(
      duration: const Duration(milliseconds: 600),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.color, widget.color.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: widget.onPressed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}