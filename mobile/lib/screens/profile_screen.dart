import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'verification_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _holoController;

  @override
  void initState() {
    super.initState();
    _holoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _holoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '👤 내 정보 및 자산 인증',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Color(0xFFD4AF37),
          ),
        ),
        backgroundColor: const Color(0xFF161920),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF161920),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '홍길동 님',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Holographic Diamond Badge
                      AnimatedBuilder(
                        animation: _holoController,
                        builder: (context, child) {
                          return _HolographicBadge(shimmerValue: _holoController.value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '🏢 소속: 디에이치 방배 101동 1502호',
                    style: TextStyle(color: Color(0xFFF1F5F9), fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '📱 연락처: 010-1234-5678',
                    style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Asset Verification Access Card
            const Text(
              '자산 인증 및 등기부 연동 관리',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161920),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_user_rounded, color: Color(0xFF38BDF8), size: 32),
                    title: const Text(
                      '🔐 본인확인 & 등기부 연동 대시보드',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: const Text(
                      'KCB 본인확인 및 대법원 등기부 등본 실시간 연동',
                      style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VerificationScreen()),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFF334155)),
                  ListTile(
                    leading: const Icon(Icons.note_add_rounded, color: Color(0xFFFBBF24), size: 32),
                    title: const Text(
                      '📄 VVIP 자산 증빙 서류 제출',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: const Text(
                      '소득증명, 추천인 코드 등 증빙 자료 제출 및 심사 현황',
                      style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VerificationScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Holographic Diamond Black badge with gyroscope/hover-reactive depth shimmer
class _HolographicBadge extends StatelessWidget {
  final double shimmerValue;

  const _HolographicBadge({required this.shimmerValue});

  @override
  Widget build(BuildContext context) {
    final shimmerAngle = shimmerValue * 2 * math.pi;
    final highlightX = 0.3 + math.cos(shimmerAngle) * 0.35;
    final highlightY = 0.3 + math.sin(shimmerAngle) * 0.3;
    final depth = 0.6 + shimmerValue * 0.4;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment(highlightX * 2 - 1, highlightY * 2 - 1),
          end: Alignment(-(highlightX * 2 - 1), -(highlightY * 2 - 1)),
          colors: [
            const Color(0xFF0A0A0E),
            Color.lerp(const Color(0xFF1A1A2E), const Color(0xFF2D1B69), shimmerValue)!,
            const Color(0xFF0A0A0E),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.15 + shimmerValue * 0.35),
            blurRadius: 12 + shimmerValue * 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.05 + shimmerValue * 0.1),
            blurRadius: 4,
            offset: Offset(math.cos(shimmerAngle) * 3, math.sin(shimmerAngle) * 3),
          ),
        ],
        border: Border.all(
          color: Color.lerp(
            const Color(0xFFD4AF37).withOpacity(0.6),
            Colors.white.withOpacity(0.9),
            depth - 0.5,
          )!,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.diamond_rounded,
            color: Color.lerp(
              const Color(0xFFD4AF37),
              Colors.white,
              (shimmerValue - 0.5).abs() * 2,
            ),
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            'DIAMOND',
            style: TextStyle(
              color: Color.lerp(
                const Color(0xFFD4AF37),
                Colors.white,
                shimmerValue * 0.7,
              ),
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
