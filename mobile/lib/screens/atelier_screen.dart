import 'package:flutter/material.dart';
import '../models/atelier_models.dart';
import '../services/atelier_service.dart';

class AtelierScreen extends StatefulWidget {
  final AtelierService? atelierService;

  const AtelierScreen({super.key, this.atelierService});

  @override
  State<AtelierScreen> createState() => _AtelierScreenState();
}

class _AtelierScreenState extends State<AtelierScreen> {
  late final AtelierService _service;
  bool _isLoading = true;
  String? _errorMessage;
  String? _flatMapUrl;
  List<FurnitureItem> _catalog = [];
  final List<FurnitureItem> _placedItems = [];
  bool _is3dMode = true;

  @override
  void initState() {
    super.initState();
    _service = widget.atelierService ?? AtelierService();
    _fetchFlatMaps();
  }

  Future<void> _fetchFlatMaps() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _service.getFlatMaps();
      setState(() {
        _flatMapUrl = res.flatMapUrl;
        _catalog = res.furnitureCatalog;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '평면도를 불러올 수 없습니다: $e';
        _isLoading = false;
      });
    }
  }

  void _addFurnitureToSimulation(FurnitureItem item) {
    setState(() {
      _placedItems.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name}가 3D 평면도 시뮬레이션에 추가되었습니다.')),
    );
  }

  Future<void> _saveSimulation() async {
    if (_placedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('배치할 가구를 하나 이상 선택해주세요.')),
      );
      return;
    }

    try {
      final placements = _placedItems.map((item) {
        return PlacementItem(
          furnitureId: item.id,
          position: [1.2, 0.0, 3.4],
          rotation: [0, 90, 0],
        );
      }).toList();

      final res = await _service.createSimulation(
        SimulationRequest(flatMapId: 'flat_84a', placedItems: placements),
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF161920),
            title: const Text('시뮬레이션 저장 완료', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('시뮬레이션 ID: ${res.simulationId}', style: const TextStyle(color: Colors.white)),
                if (res.clubDealTriggered) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF9C27B0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🎁 클럽딜 연결 혜택', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('배치된 가구 공동구매 딜 (${res.clubDealId})이 매칭되었습니다!', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('확인', style: TextStyle(color: Color(0xFFD4AF37))),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('시뮬레이션 저장 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text('AI 아뜰리에 3D 평면도', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF161920),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchFlatMaps,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
              child: const Text('재시도', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 3D/2D Viewport Container with Camera Mode Switcher
        Container(
          height: 220,
          margin: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF161920),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
          ),
          child: Column(
            children: [
              // Top Viewport Control Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _is3dMode ? '🎥 3D Orbit View (Perspective)' : '📐 2D Top-Down (Orthographic)',
                      style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        ChoiceChip(
                          key: const Key('camera_mode_3d'),
                          label: const Text('3D Orbit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          selected: _is3dMode,
                          selectedColor: const Color(0xFFD4AF37),
                          backgroundColor: const Color(0xFF1E222B),
                          labelStyle: TextStyle(color: _is3dMode ? Colors.black : Colors.white),
                          onSelected: (val) {
                            if (val) setState(() => _is3dMode = true);
                          },
                        ),
                        const SizedBox(width: 6),
                        ChoiceChip(
                          key: const Key('camera_mode_2d'),
                          label: const Text('2D Top', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          selected: !_is3dMode,
                          selectedColor: const Color(0xFFD4AF37),
                          backgroundColor: const Color(0xFF1E222B),
                          labelStyle: TextStyle(color: !_is3dMode ? Colors.black : Colors.white),
                          onSelected: (val) {
                            if (val) setState(() => _is3dMode = false);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, height: 1),
              Expanded(
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _is3dMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstChild: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.view_in_ar_rounded, color: Color(0xFFD4AF37), size: 44),
                        const SizedBox(height: 6),
                        Text(
                          '3D 평면도 시뮬레이션 (${_flatMapUrl?.split('/').last ?? ''})',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '배치된 가구 (${_placedItems.length}개)',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  secondChild: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.grid_on_rounded, color: Color(0xFF38BDF8), size: 44),
                        const SizedBox(height: 6),
                        const Text(
                          '2D 평면 도면 그리드',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '탑다운 정사영 뷰 | 배치 가구 (${_placedItems.length}개)',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('수입 명품 가구 카탈로그', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton(
                key: const Key('save_simulation_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: _saveSimulation,
                child: const Text('시뮬레이션 저장', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _catalog.length,
            itemBuilder: (context, index) {
              final item = _catalog[index];
              return Card(
                key: Key('furniture_item_${item.id}'),
                color: const Color(0xFF161920),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF222630),
                    child: Icon(Icons.chair_rounded, color: Color(0xFFD4AF37)),
                  ),
                  title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('${item.brand} | ${item.price}원 (재고 ${item.stock}개)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF222630)),
                    onPressed: () => _addFurnitureToSimulation(item),
                    child: const Text('배치', style: TextStyle(color: Color(0xFFD4AF37))),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
