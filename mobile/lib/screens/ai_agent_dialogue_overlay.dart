import 'package:flutter/material.dart';
import '../models/ai_agent_models.dart';
import '../models/screen_context.dart';
import '../services/ai_agent_service.dart';

class AiAgentDialogueOverlay extends StatefulWidget {
  final AiAgentService? aiAgentService;

  /// The current screen context injected from [MainNavigationScreen].
  /// When provided, the overlay shows a context banner and surfaces
  /// proactive 1-tap recommendation chips relevant to the active screen.
  final ScreenContext? screenContext;

  const AiAgentDialogueOverlay({
    super.key,
    this.aiAgentService,
    this.screenContext,
  });

  @override
  State<AiAgentDialogueOverlay> createState() => _AiAgentDialogueOverlayState();
}

class _ChatMessage {
  final String sender; // 'user' or 'ai'
  final String message;
  final String? actionExecuted;
  final ReservationDetails? details;

  _ChatMessage({
    required this.sender,
    required this.message,
    this.actionExecuted,
    this.details,
  });
}

class _AiAgentDialogueOverlayState extends State<AiAgentDialogueOverlay> {
  late final AiAgentService _service;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _service = widget.aiAgentService ?? AiAgentService();

    // Context-aware greeting: reference the current screen in the opening message
    final ctx = widget.screenContext;
    final greeting = ctx != null
        ? '안녕하세요, ARATEL AI 에이전트입니다.\n현재 [${ctx.screenName}] 화면을 보고 계시네요. 관련해서 도움이 필요하신 것이 있으신가요?'
        : '안녕하세요, ARATEL AI 에이전트입니다. 어떤 도움이 필요하신가요?';

    _messages.add(_ChatMessage(sender: 'ai', message: greeting));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? prefilled]) async {
    final text = prefilled ?? _inputController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(_ChatMessage(sender: 'user', message: text));
      _inputController.clear();
      _isSending = true;
    });

    _scrollToBottom();

    try {
      final res = await _service.sendDialogue(
        AiAgentRequest(
          message: text,
          screenContext: widget.screenContext,
        ),
      );
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            sender: 'ai',
            message: res.reply,
            actionExecuted: res.actionExecuted,
            details: res.reservationDetails,
          ));
          _isSending = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            sender: 'ai',
            message: 'AI 응답 처리 중 오류가 발생했습니다: $e',
          ));
          _isSending = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161920),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.smart_toy_outlined, color: Color(0xFFD4AF37)),
              const SizedBox(width: 8),
              const Text(
                'ARATEL AI 에이전트',
                style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.maybePop(context),
              ),
            ],
          ),

          // ── Context Banner ──────────────────────────────────────────────
          if (widget.screenContext != null) _buildContextBanner(widget.screenContext!),

          const Divider(color: Colors.white12),

          // ── Chat Messages ───────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg.sender == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFFD4AF37).withOpacity(0.2)
                          : const Color(0xFF222630),
                      borderRadius: BorderRadius.circular(12),
                      border: isUser
                          ? Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5))
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.message,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        if (msg.actionExecuted != null && msg.actionExecuted != 'NONE') ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '실행 액션: ${msg.actionExecuted}',
                              style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        if (msg.details != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            '시설: ${msg.details!.facility} (${msg.details!.partySize}명)\n상태: ${msg.details!.status}',
                            style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── 1-Tap Proactive Suggestion Chips ────────────────────────────
          _buildSuggestionChips(),

          // ── Thinking Indicator ──────────────────────────────────────────
          if (_isSending) ...[
            _buildAudioWaveformVisualizer(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
            ),
          ],

          // ── Input Row ───────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('ai_input_field'),
                  controller: _inputController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '자연어로 요청해보세요',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF0F1115),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                key: const Key('ai_send_button'),
                icon: const Icon(Icons.send_rounded, color: Color(0xFFD4AF37)),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Widget Builders ──────────────────────────────────────────────────────

  /// Context banner displayed below the header when a ScreenContext is present.
  Widget _buildContextBanner(ScreenContext ctx) {
    return Container(
      key: const Key('ai_context_banner'),
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.track_changes_rounded, color: Color(0xFFD4AF37), size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              ctx.contextLabel,
              style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Proactive 1-tap recommendation chips — context-aware when ScreenContext is set.
  Widget _buildSuggestionChips() {
    final suggestions = widget.screenContext?.proactiveSuggestions ?? [
      '라운지 조식 2명 예약',
      '피트니스 센터 혼잡도 조회',
      '사우나 현재 이용 상태',
    ];

    return SingleChildScrollView(
      key: const Key('ai_suggestion_chips_row'),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: suggestions.map((chipText) {
          return Padding(
            padding: const EdgeInsets.only(right: 6, bottom: 8),
            child: ActionChip(
              key: Key('chip_${chipText.substring(0, 4)}'),
              backgroundColor: const Color(0xFF1E222B),
              side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.4)),
              label: Text(
                chipText,
                style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _sendMessage(chipText),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAudioWaveformVisualizer() {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(12, (index) {
          final heights = [8.0, 16.0, 12.0, 20.0, 14.0, 22.0, 10.0, 18.0, 14.0, 22.0, 12.0, 8.0];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 3,
            height: _isSending ? heights[index % heights.length] : 6.0,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
