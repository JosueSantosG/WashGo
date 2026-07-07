import 'dart:math' as math;
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/routes/app_routes.dart';


class WindshieldElement {
  final double xRatio;
  final double yRatio;
  final double radius;
  final double opacity;
  final double type;

  WindshieldElement({
    required this.xRatio,
    required this.yRatio,
    required this.radius,
    required this.opacity,
    this.type = 0.0,
  });
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _wiperAnimation;

  final List<WindshieldElement> _foamBubbles = [];
  final List<WindshieldElement> _waterDroplets = [];
  final List<WindshieldElement> _dirtPatches = [];

  // CONFIGURACIÓN DE DESARROLLADOR:
  // Cambia a 'true' para pausar la redirección automática y ver la animación en bucle continuo.
  static const bool soloVerAnimacion = false;

  late bool _autoNavigate;
  late bool _loopAnimation;

  @override
  void initState() {
    super.initState();
    _autoNavigate = !soloVerAnimacion;
    _loopAnimation = soloVerAnimacion;
    _generateWindshieldElements();

    // 2.5 seconds total duration for a smooth, premium feel
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Wiper sweeps from 0.0 to 0.65 of the timeline
    _wiperAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.easeInOutCubic),
    );

    // Start the animation
    _controller.forward();

    // Navigate to next screen when done
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_loopAnimation) {
          _replayAnimation();
        } else if (_autoNavigate) {
          _navigateToNextScreen();
        }
      }
    });
  }

  void _replayAnimation() {
    _controller.reset();
    _controller.forward();
  }

  void _generateWindshieldElements() {
    final random = math.Random(12345); // Seeded random for consistent layout

    // 1. Generate dirt patches (faint smudges)
    // Reduce to 8 patches and keep them away from the center to prevent blocking the logo
    for (int i = 0; i < 8; i++) {
      double x = random.nextDouble();
      double y = random.nextDouble();
      // Push away from center (0.35 to 0.65)
      if (x > 0.35 && x < 0.65 && y > 0.35 && y < 0.65) {
        x = x < 0.5 ? x - 0.2 : x + 0.2;
        y = y < 0.5 ? y - 0.2 : y + 0.2;
      }
      _dirtPatches.add(WindshieldElement(
        xRatio: x.clamp(0.0, 1.0),
        yRatio: y.clamp(0.0, 1.0),
        radius: 30.0 + random.nextDouble() * 40.0,
        opacity: 0.02 + random.nextDouble() * 0.04, // reduced opacity
      ));
    }

    // 2. Generate foam bubbles (fewer bubbles, avoiding the center)
    int bubbleCount = 0;
    while (bubbleCount < 15) {
      double x = random.nextDouble();
      double y = random.nextDouble();
      // Avoid the center area where WashGo logo and text reside (0.3 to 0.7)
      if (x > 0.3 && x < 0.7 && y > 0.3 && y < 0.7) {
        continue;
      }
      _foamBubbles.add(WindshieldElement(
        xRatio: x,
        yRatio: y,
        radius: 6.0 + random.nextDouble() * 16.0, // slightly smaller bubbles
        opacity: 0.15 + random.nextDouble() * 0.3,
        type: random.nextDouble(),
      ));
      bubbleCount++;
    }

    // 3. Generate water droplets (fewer and more subtle)
    for (int i = 0; i < 40; i++) {
      _waterDroplets.add(WindshieldElement(
        xRatio: random.nextDouble(),
        yRatio: random.nextDouble(),
        radius: 1.5 + random.nextDouble() * 3.5,
        opacity: 0.2 + random.nextDouble() * 0.35,
        type: random.nextDouble(),
      ));
    }
  }

  void _navigateToNextScreen() {
    // Navigate automatically to authGate route. Route redirects will handle rest.
    if (mounted) {
      context.go(AppRoutes.authGate);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {
          setState(() {
            _autoNavigate = false;
          });
          _replayAnimation();
        },
        child: Stack(
          children: [
            // Background: Premium Dark to Vibrant Blue Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F172A), // Slate 900 (deep dark blue)
                    Color(0xFF1E3A8A), // Blue 900
                    Color(0xFF2563EB), // Blue 600 (corporate blue)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Central Logo and Slogan underneath (revealed by the wiper & animated)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Visual icon/logo for WashGo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_car_filled_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // WashGo Title
                  const Text(
                    'WashGo',
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Slogan
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Text(
                      'Tu lavado de autos a un clic',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dynamic Blur & Haze Overlay (blurs the logo and background in unclean areas)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _wiperAnimation,
                builder: (context, child) {
                  return ClipPath(
                    clipper: UncleanAreaClipper(progress: _wiperAnimation.value),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.03), // steam haze color (more transparent)
                      ),
                    ),
                  );
                },
              ),
            ),

            // Windshield dirt/foam overlay and wiper painter
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _wiperAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WindshieldWiperPainter(
                      progress: _wiperAnimation.value,
                      foamBubbles: _foamBubbles,
                      waterDroplets: _waterDroplets,
                      dirtPatches: _dirtPatches,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WindshieldWiperPainter extends CustomPainter {
  final double progress;
  final List<WindshieldElement> foamBubbles;
  final List<WindshieldElement> waterDroplets;
  final List<WindshieldElement> dirtPatches;

  WindshieldWiperPainter({
    required this.progress,
    required this.foamBubbles,
    required this.waterDroplets,
    required this.dirtPatches,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Pivot is located at bottom center, slightly below the screen
    final Offset pivotPoint = Offset(width / 2, height + 80);

    // R_max should cover the top corners of the screen
    final double rMax = math.sqrt((width / 2) * (width / 2) + (height + 80) * (height + 80)) + 60;
    const double rMin = 110.0;

    // Wiper angles in radians (from left to right)
    // -155 degrees to -25 degrees
    const double thetaStart = -155 * math.pi / 180;
    const double thetaEnd = -25 * math.pi / 180;

    // Current angle of the wiper blade
    final double thetaCurrent = thetaStart + progress * (thetaEnd - thetaStart);

    // Define the cleared path (annular sector)
    final Path clearPath = Path();
    clearPath.moveTo(
      pivotPoint.dx + rMin * math.cos(thetaStart),
      pivotPoint.dy + rMin * math.sin(thetaStart),
    );
    clearPath.lineTo(
      pivotPoint.dx + rMax * math.cos(thetaStart),
      pivotPoint.dy + rMax * math.sin(thetaStart),
    );
    clearPath.arcTo(
      Rect.fromCircle(center: pivotPoint, radius: rMax),
      thetaStart,
      thetaCurrent - thetaStart,
      false,
    );
    clearPath.lineTo(
      pivotPoint.dx + rMin * math.cos(thetaCurrent),
      pivotPoint.dy + rMin * math.sin(thetaCurrent),
    );
    clearPath.arcTo(
      Rect.fromCircle(center: pivotPoint, radius: rMin),
      thetaCurrent,
      -(thetaCurrent - thetaStart),
      false,
    );
    clearPath.close();

    // Draw the dirty layer with saveLayer for BlendMode clearing
    canvas.saveLayer(Rect.fromLTWH(0, 0, width, height), Paint());

    _drawWindshieldDirt(canvas, size);

    // Clear the swept sector
    final Paint clearPaint = Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.fill;
    canvas.drawPath(clearPath, clearPaint);

    canvas.restore();

    // Draw the wiper arm and blade
    _drawWiper(canvas, pivotPoint, rMin, rMax, thetaCurrent, progress);
  }

  void _drawWindshieldDirt(Canvas canvas, Size size) {
    // 1. Draw soft dirt patches (grey/brownish smudges)
    final Paint dirtPaint = Paint()..style = PaintingStyle.fill;
    for (var patch in dirtPatches) {
      final center = Offset(patch.xRatio * size.width, patch.yRatio * size.height);
      dirtPaint.color = const Color(0xFF5D4037).withValues(alpha: patch.opacity); // brown tint
      canvas.drawCircle(center, patch.radius, dirtPaint);
    }

    // 2. Draw condensation/steam haze (glass look)
    final Paint hazePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05) // reduced opacity so text/background shine through
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), hazePaint);

    // 3. Draw foam bubbles
    for (var bubble in foamBubbles) {
      final center = Offset(bubble.xRatio * size.width, bubble.yRatio * size.height);

      // Draw bubble fill (soft white)
      final Paint fillPaint = Paint()
        ..color = Colors.white.withValues(alpha: bubble.opacity * 0.45)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, bubble.radius, fillPaint);

      // Draw bubble outline (crisp white)
      final Paint outlinePaint = Paint()
        ..color = Colors.white.withValues(alpha: bubble.opacity * 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(center, bubble.radius, outlinePaint);

      // Draw a small inner reflection highlight inside the bubble
      final Paint highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: bubble.opacity * 0.9)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(center.dx - bubble.radius * 0.4, center.dy - bubble.radius * 0.4),
        bubble.radius * 0.15,
        highlightPaint,
      );
    }

    // 4. Draw water droplets
    for (var drop in waterDroplets) {
      final center = Offset(drop.xRatio * size.width, drop.yRatio * size.height);

      // Drop Shadow (bottom-right):
      final Paint shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: drop.opacity * 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: drop.radius),
        0, // 0 to pi is bottom half
        math.pi,
        false,
        shadowPaint,
      );

      // Highlight (top-left):
      final Paint highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: drop.opacity * 0.8)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(center.dx - drop.radius * 0.3, center.dy - drop.radius * 0.3),
        drop.radius * 0.25,
        highlightPaint,
      );

      // Highlight outline (top-left arc):
      final Paint whiteArcPaint = Paint()
        ..color = Colors.white.withValues(alpha: drop.opacity * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: drop.radius),
        math.pi,
        math.pi,
        false,
        whiteArcPaint,
      );
    }
  }

  void _drawWiper(
    Canvas canvas,
    Offset pivot,
    double rMin,
    double rMax,
    double theta,
    double progress,
  ) {
    // 1. Calculate positions
    final Offset bladeStart = Offset(
      pivot.dx + rMin * math.cos(theta),
      pivot.dy + rMin * math.sin(theta),
    );
    final Offset bladeEnd = Offset(
      pivot.dx + rMax * math.cos(theta),
      pivot.dy + rMax * math.sin(theta),
    );

    // 2. Draw pushed water wave (crest) along the leading edge
    // The leading edge is slightly ahead of the blade (increasing angle)
    final double waveAngle = theta + 0.012;
    final Paint wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    for (double r = rMin; r <= rMax * 0.95; r += 12.0) {
      final double noise = (math.sin(r * 0.05 + progress * 20) * 3.0);
      final double waveR = r;
      final double waveA = waveAngle + (noise / r);
      final double bubbleRadius = 3.0 + (math.sin(r * 0.1) + 1.0) * 3.0; // 3 to 9

      final waveOffset = Offset(
        pivot.dx + waveR * math.cos(waveA),
        pivot.dy + waveR * math.sin(waveA),
      );
      canvas.drawCircle(waveOffset, bubbleRadius, wavePaint);

      // Secondary spray
      final double sprayA = waveAngle + 0.02 + (noise / r);
      final sprayOffset = Offset(
        pivot.dx + waveR * math.cos(sprayA),
        pivot.dy + waveR * math.sin(sprayA),
      );
      canvas.drawCircle(
        sprayOffset,
        bubbleRadius * 0.5,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..style = PaintingStyle.fill,
      );
    }

    // 3. Draw wiper blade (rubber block)
    final Paint bladePaint = Paint()
      ..color = const Color(0xFF1E293B) // slate dark
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(bladeStart, bladeEnd, bladePaint);

    // 4. Draw metal backing of the blade (thin line right next to it or on it)
    final Paint metalBackingPaint = Paint()
      ..color = const Color(0xFF475569) // slate grey
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(bladeStart, bladeEnd, metalBackingPaint);

    // 5. Draw wiper arm (from pivot to the blade attachment point)
    final double attachmentRadius = rMin + (rMax - rMin) * 0.25;
    final Offset attachmentPoint = Offset(
      pivot.dx + attachmentRadius * math.cos(theta),
      pivot.dy + attachmentRadius * math.sin(theta),
    );

    // Draw main arm (double strut near pivot)
    final Offset armSplitPoint = Offset(
      pivot.dx + (rMin - 40.0) * math.cos(theta),
      pivot.dy + (rMin - 40.0) * math.sin(theta),
    );

    final Paint armPaint = Paint()
      ..color = const Color(0xFF0F172A) // deep black-blue
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pivot, armSplitPoint, armPaint);

    // From split to attachment, slightly thinner
    final Paint armThinPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(armSplitPoint, attachmentPoint, armThinPaint);

    // Connector pin/bracket at attachment point
    final Paint bracketPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(attachmentPoint, 6.0, bracketPaint);
    canvas.drawCircle(attachmentPoint, 3.0, Paint()..color = Colors.black);

    // Draw pivot cap at bottom
    canvas.drawCircle(pivot, 12.0, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(pivot, 6.0, Paint()..color = const Color(0xFF475569));
  }

  @override
  bool shouldRepaint(covariant WindshieldWiperPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class UncleanAreaClipper extends CustomClipper<Path> {
  final double progress;

  UncleanAreaClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final double width = size.width;
    final double height = size.height;
    final Offset pivotPoint = Offset(width / 2, height + 80);
    final double rMax = math.sqrt((width / 2) * (width / 2) + (height + 80) * (height + 80)) + 60;
    const double rMin = 110.0;
    const double thetaStart = -155 * math.pi / 180;
    const double thetaEnd = -25 * math.pi / 180;
    final double thetaCurrent = thetaStart + progress * (thetaEnd - thetaStart);

    final Path clearPath = Path();
    clearPath.moveTo(
      pivotPoint.dx + rMin * math.cos(thetaStart),
      pivotPoint.dy + rMin * math.sin(thetaStart),
    );
    clearPath.lineTo(
      pivotPoint.dx + rMax * math.cos(thetaStart),
      pivotPoint.dy + rMax * math.sin(thetaStart),
    );
    clearPath.arcTo(
      Rect.fromCircle(center: pivotPoint, radius: rMax),
      thetaStart,
      thetaCurrent - thetaStart,
      false,
    );
    clearPath.lineTo(
      pivotPoint.dx + rMin * math.cos(thetaCurrent),
      pivotPoint.dy + rMin * math.sin(thetaCurrent),
    );
    clearPath.arcTo(
      Rect.fromCircle(center: pivotPoint, radius: rMin),
      thetaCurrent,
      -(thetaCurrent - thetaStart),
      false,
    );
    clearPath.close();

    final Path screenPath = Path()..addRect(Rect.fromLTWH(0, 0, width, height));
    return Path.combine(PathOperation.difference, screenPath, clearPath);
  }

  @override
  bool shouldReclip(covariant UncleanAreaClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
