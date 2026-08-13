import 'dart:io';
import 'package:flutter/material.dart';
import 'screens/lounge_screen.dart';
import 'screens/curation_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/ai_agent_dialogue_overlay.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  // Allow self-signed or development SSL certificates in Flutter HttpClient
  HttpOverrides.global = DevHttpOverrides();
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
    LoungeScreen(),
    CurationScreen(),
    InsightsScreen(),
    ProfileScreen(),
  ];

  void _openAiAgentOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const FractionallySizedBox(
        heightFactor: 0.75,
        child: AiAgentDialogueOverlay(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              key: const Key('ai_agent_fab'),
              backgroundColor: const Color(0xFFD4AF37),
              onPressed: _openAiAgentOverlay,
              icon: const Icon(Icons.smart_toy_outlined, color: Colors.black),
              label: const Text('AI 에이전트', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF161920),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '웰컴 홈'),
          BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.diamond_rounded), label: 'VVIP큐레이션'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: '자산증식인사이트'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: '내 정보'),
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
                _buildQuickCard('자산 인증', Icons.verified, const Color(0xFF4CAF50)),
                const SizedBox(width: 12),
                _buildQuickCard('암호화 라운지', Icons.lock, const Color(0xFF2196F3)),
                const SizedBox(width: 12),
                _buildQuickCard('VVIP 큐레이션', Icons.diamond, const Color(0xFF9C27B0)),
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
