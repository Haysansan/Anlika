import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:apploan/core/core.dart';

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({
    Key? key,
    required this.amountToCollect,
    required this.amountCollected,
    required this.amountToCollectKhr,
    required this.amountCollectedKhr,
    this.userName = '',
    this.companyName = 'Soft Creative CO.,LTD',
  }) : super(key: key);

  final String amountToCollect;
  final String amountCollected;
  final String amountToCollectKhr;
  final String amountCollectedKhr;
  final String userName;
  final String companyName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20), // semi-transparent white
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Company + user row ──
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.6),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            AssetPath.appLogo.path,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            4.height,
                            Text(
                              'Hi, ${userName.isNotEmpty ? userName : 'User'}! Welcome to ANLIKA.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  16.height,

                  // ── Two stat boxes ──
                  Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          label: 'Amount to Collect',
                          usd: amountToCollect,
                          khr: amountToCollectKhr,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: _StatBox(
                          label: 'Amount Collected',
                          usd: amountCollected,
                          khr: amountCollectedKhr,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.usd, required this.khr});

  final String label;
  final String usd;
  final String khr;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        // ← blur inside stat boxes too
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              6.height,
              Text(
                usd,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              2.height,
              Text(
                khr,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
