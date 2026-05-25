import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:apploan/core/core.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class CustomSummaryCard extends StatelessWidget {
  final int clientCount;
  final double totalRepaymentUsd;
  final double collectedUsd;
  final double exchangeRate;
  final String totalRepaymentFormatted;
  final String totalRepaymentKhrFormatted;
  final VoidCallback? onClientsTap;

  const CustomSummaryCard({
    Key? key,
    required this.clientCount,
    required this.totalRepaymentUsd,
    required this.collectedUsd,
    required this.exchangeRate,
    required this.totalRepaymentFormatted,
    required this.totalRepaymentKhrFormatted,
    this.onClientsTap,
  }) : super(key: key);

  double get _percentage {
    if (totalRepaymentUsd == 0) return 0;
    return (collectedUsd / totalRepaymentUsd).clamp(0.0, 1.0);
  }

  String get _percentageLabel => '${(_percentage * 100).toStringAsFixed(0)}%';

  String get _totalUsd =>
      '\$${NumberFormat('#,##0.00').format(totalRepaymentUsd)}';

  String get _totalKhr =>
      '${NumberFormat('#,##0.00').format(totalRepaymentUsd * exchangeRate)}៛';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF0000).withValues(alpha: 0.55),
              Color(0xFFFF8386),
              Color(0xFFFF0000).withValues(alpha: 0.55),
            ],
            stops: [0.0, 0.51, 0.92],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53935).withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCircularProgress(),

              const SizedBox(width: 16),

              // Vertical divider
              Container(
                width: 1,
                height: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(child: _buildRightSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProgress() {
    const double size = 130;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(size, size),
            painter: _ArcPainter(progress: _percentage),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total\nRepaid',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _percentageLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Clients row ──
        InkWell(
          onTap: onClientsTap,
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.people_alt,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$clientCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'Clients',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white, size: 22),
            ],
          ),
        ),

        const SizedBox(height: 14),
        // Divider
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.0),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ── Total repayment section ──
        Text(
          'Total Repayment',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13, // matches _StatBox label
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          totalRepaymentFormatted,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          totalRepaymentKhrFormatted,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  _ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    const strokeWidth = 14.0;
    const startAngle = math.pi * 0.25;
    const sweepTotal = math.pi * 1.5;

    final bgPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      bgPaint,
    );

    if (progress > 0) {
      final progressPaint =
          Paint()
            ..color = Colors.green
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepTotal * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}
