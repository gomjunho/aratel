import 'package:flutter/material.dart';
import 'atelier_screen.dart';
import 'club_deal_workflow.dart';
import 'concierge_screen.dart';

class CurationScreen extends StatefulWidget {
  const CurationScreen({super.key});

  @override
  State<CurationScreen> createState() => _CurationScreenState();
}

class _CurationScreenState extends State<CurationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '💎 VVIP 큐레이션 Hub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Color(0xFFD4AF37),
          ),
        ),
        backgroundColor: const Color(0xFF161920),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD4AF37),
          labelColor: const Color(0xFFD4AF37),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.space_dashboard_outlined), text: '3D 아뜰리에'),
            Tab(icon: Icon(Icons.shopping_bag_outlined), text: 'VVIP 클럽딜'),
            Tab(icon: Icon(Icons.room_service_outlined), text: 'VIP 컨시어지'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AtelierScreen(),
          ClubDealWorkflowWidget(),
          ConciergeScreen(),
        ],
      ),
    );
  }
}
