import 'package:flutter/material.dart';
import '../models/ai_agent_models.dart';
import '../services/ai_agent_service.dart';

class AiAgentDialogueOverlay extends StatefulWidget {
  final AiAgentService? aiAgentService;

  const AiAgentDialogueOverlay({super.key, this.aiAgentService});

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
  final List<_ChatMessage> _messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _service = widget.aiAgentService ?? AiAgentService();
    _messages.add(_ChatMessage(
      sender: 'ai',
      message: '안녕하세요, ARATEL AI 에이전트입니다. 어떤 도움이 필요하신가요?',
    ));
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(_ChatMessage(sender: 'user', message: text));
      _inputController.clear();
      _isSending = true;
    });

    try {
      final res = await _service.sendDialogue(AiAgentRequest(message: text));
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
      }
    }
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
          const Divider(color: Colors.white12),
          Expanded(
            child: ListView.builder(
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
                      color: isUser ? const Color(0xFFD4AF37).withOpacity(0.2) : const Color(0xFF222630),
                      borderRadius: BorderRadius.circular(12),
                      border: isUser ? Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)) : null,
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
          if (_isSending)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('ai_input_field'),
                  controller: _inputController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '자연어로 요청해보세요 (예: 라운지 조식 2명 예약)',
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
}
