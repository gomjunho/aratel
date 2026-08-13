import 'package:flutter/material.dart';
import 'verification_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '💎 GOLD 회원',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
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
