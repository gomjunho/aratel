import 'package:flutter/material.dart';

void main() {
  runApp(const AratelApp());
}

class AratelApp extends StatelessWidget {
  const AratelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARATEL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        primaryColor: const Color(0xFFD4AF37), // Satin Gold
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFF1E222B),
          surface: Color(0xFF161920),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    VerificationScreen(),
    LoungeScreen(),
    AtelierScreen(),
    ConciergeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161920),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.verified_user_rounded), label: '인증'),
          BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: '라운지'),
          BottomNavigationBarItem(icon: Icon(Icons.view_in_ar_rounded), label: 'AI아뜰리에'),
          BottomNavigationBarItem(icon: Icon(Icons.room_service_rounded), label: '컨시어지'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ARATEL', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0, color: Color(0xFFD4AF37))),
        backgroundColor: const Color(0xFF161920),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // Banner / Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E222B), Color(0xFF2A2F3D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('DIAMOND TIER', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.shield_outlined, color: Color(0xFFD4AF37)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('디에이치 방배 소유주', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('무결한 신뢰 자본과 고해상도 네트워크', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('주요 가치 사슬 (Value Chain)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildQuickCard('1분 자동 인증', Icons.verified, const Color(0xFF4CAF50)),
                const SizedBox(width: 12),
                _buildQuickCard('암호화 라운지', Icons.lock, const Color(0xFF2196F3)),
                const SizedBox(width: 12),
                _buildQuickCard('AI 3D 아뜰리에', Icons.space_dashboard, const Color(0xFF9C27B0)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCard(String title, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF161920),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('자산 인증 센터'), backgroundColor: const Color(0xFF161920)),
      body: const Center(child: Text('1분 자동 등기 API 연동 및 VVIP 자산 인증', style: TextStyle(color: Colors.grey))),
    );
  }
}

class LoungeScreen extends StatelessWidget {
  const LoungeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('하이엔드 암호화 라운지'), backgroundColor: const Color(0xFF161920)),
      body: const Center(child: Text('검증된 실소유주 전용 24시간 익명 소통 라운지', style: TextStyle(color: Colors.grey))),
    );
  }
}

class AtelierScreen extends StatelessWidget {
  const AtelierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 아뜰리에 (3D 인테리어)'), backgroundColor: const Color(0xFF161920)),
      body: const Center(child: Text('평면도 기반 수입 리빙 브랜드 가상 배치 & 클럽 딜', style: TextStyle(color: Colors.grey))),
    );
  }
}

class ConciergeScreen extends StatelessWidget {
  const ConciergeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VIP 컨시어지'), backgroundColor: const Color(0xFF161920)),
      body: const Center(child: Text('자산관리, 하이엔드 주거 방역, 문화 예약 컨시어지', style: TextStyle(color: Colors.grey))),
    );
  }
}
