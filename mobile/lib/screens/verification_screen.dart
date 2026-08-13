import 'package:flutter/material.dart';
import '../models/verification_models.dart';
import '../services/verification_service.dart';
import '../services/security_service.dart';
import '../widgets/security_glow_frame.dart';

class VerificationScreen extends StatefulWidget {
  final VerificationService? verificationService;
  final SecurityService? securityService;

  const VerificationScreen({
    super.key,
    this.verificationService,
    this.securityService,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final VerificationService _service;
  late final SecurityService _security;

  int _currentStep = 0;
  int _step3SubTab = 0;
  bool _isLoading = false;

  // Step 1 Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthController = TextEditingController();

  // Step 2 Controllers
  final _complexController = TextEditingController(text: '디에이치 방배');
  final _buildingController = TextEditingController(text: '101동');
  final _unitController = TextEditingController(text: '1502호');

  // Step 3 Controllers
  final _evidenceTypeController = TextEditingController(text: 'INCOME_CERT');
  final _docUrlController = TextEditingController();
  final _instagramController = TextEditingController();
  final _referralController = TextEditingController();

  final _relationshipController = TextEditingController(text: 'FAMILY');
  final _delegatedDocUrlController = TextEditingController();

  final _delegationIdController = TextEditingController();

  // Results
  IdentityVerifyResponse? _identityResult;
  TrustApiSyncResponse? _trustResult;
  TierEvidenceResponse? _evidenceResult;
  DelegatedAccessResponse? _delegationResult;
  OwnerApprovalResponse? _approvalResult;
  UserTierResponse? _userTier;

  @override
  void initState() {
    super.initState();
    _service = widget.verificationService ?? VerificationService();
    _security = widget.securityService ?? SecurityService();
    _security.addListener(_onSecurityChanged);
    _loadUserTier();
  }

  @override
  void dispose() {
    _security.removeListener(_onSecurityChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    _complexController.dispose();
    _buildingController.dispose();
    _unitController.dispose();
    _evidenceTypeController.dispose();
    _docUrlController.dispose();
    _instagramController.dispose();
    _referralController.dispose();
    _relationshipController.dispose();
    _delegatedDocUrlController.dispose();
    _delegationIdController.dispose();
    super.dispose();
  }

  void _onSecurityChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadUserTier() async {
    try {
      final tierData = await _service.getUserTier();
      if (mounted) {
        setState(() {
          _userTier = tierData;
        });
      }
    } catch (_) {
      // Ignore if unauthenticated or error in initial fetch
    }
  }

  Future<void> _handleIdentityVerify() async {
    setState(() => _isLoading = true);
    try {
      final res = await _service.identityVerify(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        birthDate: _birthController.text.trim(),
      );
      if (mounted) {
        setState(() {
          _identityResult = res;
          _currentStep = 1;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('본인확인 실패: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleTrustApiSync() async {
    setState(() => _isLoading = true);
    try {
      final token = _identityResult?.verificationToken ?? 'ver_tok_default';
      final res = await _service.trustApiSync(
        verificationToken: token,
        complexName: _complexController.text.trim(),
        buildingNumber: _buildingController.text.trim(),
        unitNumber: _unitController.text.trim(),
      );
      if (mounted) {
        setState(() {
          _trustResult = res;
          _currentStep = 2;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등기부 연동 실패: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSubmitEvidence() async {
    setState(() => _isLoading = true);
    try {
      final res = await _service.submitTierEvidence(
        evidenceType: _evidenceTypeController.text.trim(),
        documentUrl: _docUrlController.text.trim(),
        instagramHandle: _instagramController.text.trim().isNotEmpty ? _instagramController.text.trim() : null,
        referralCode: _referralController.text.trim().isNotEmpty ? _referralController.text.trim() : null,
      );
      if (mounted) {
        setState(() {
          _evidenceResult = res;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('증빙 제출 실패: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRequestDelegation() async {
    setState(() => _isLoading = true);
    try {
      final res = await _service.requestDelegatedAccess(
        relationship: _relationshipController.text.trim(),
        documentUrl: _delegatedDocUrlController.text.trim(),
      );
      if (mounted) {
        setState(() {
          _delegationResult = res;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('위임 신청 실패: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleApproveDelegation(bool approved) async {
    setState(() => _isLoading = true);
    try {
      final res = await _service.approveDelegatedAccess(
        delegationId: _delegationIdController.text.trim(),
        approved: approved,
      );
      if (mounted) {
        setState(() {
          _approvalResult = res;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('위임 승인 처리 실패: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSecure = _security.isScreenCapturePrevented || _security.isPrivacyMasked;

    return SecurityGlowFrame(
      isSecure: isSecure,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1115),
        appBar: AppBar(
          title: Row(
            children: [
              const Text(
                '자산 인증 센터',
                style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
              ),
              if (isSecure) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield_rounded, color: Color(0xFFD4AF37), size: 11),
                      SizedBox(width: 3),
                      Text('보안모드', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ],
          ),
          backgroundColor: const Color(0xFF161920),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSecurityHeader(),
              const SizedBox(height: 16),
              _buildStepTabs(),
              const SizedBox(height: 16),
              if (_isLoading) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                  ),
                ),
              ] else ...[
                if (_currentStep == 0) _buildStep1IdentityAuth(),
                if (_currentStep == 1) _buildStep2RegistrySync(),
                if (_currentStep == 2) _buildStep3EvidenceAndDelegation(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityHeader() {
    final currentTier = _trustResult?.assignedTier.toValue() ?? _userTier?.tier.toValue() ?? 'UNVERIFIED';
    final complexName = _trustResult != null ? _complexController.text : (_userTier?.complexName ?? '미인증');
    final buildingUnit = _trustResult != null ? '${_buildingController.text} ${_unitController.text}' : (_userTier?.buildingUnit ?? '-');

    final displayComplexName = _security.isPrivacyMasked && complexName.isNotEmpty ? _security.maskName(complexName) : complexName;
    final displayUnit = _security.isPrivacyMasked && buildingUnit.isNotEmpty ? _security.maskUnitNumber(buildingUnit) : buildingUnit;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161920),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$currentTier TIER',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Row(
                children: [
                  Icon(
                    _security.isScreenCapturePrevented ? Icons.security_rounded : Icons.security_update_warning_rounded,
                    color: _security.isScreenCapturePrevented ? Colors.greenAccent : Colors.orangeAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _security.isScreenCapturePrevented ? 'SECURE ON' : 'SECURE OFF',
                    style: TextStyle(
                      color: _security.isScreenCapturePrevented ? Colors.greenAccent : Colors.orangeAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$displayComplexName $displayUnit',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.white12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('화면 캡처 방지 (FLAG_SECURE)', style: TextStyle(color: Colors.white70, fontSize: 13)),
              Switch(
                key: const Key('switch_screen_capture'),
                value: _security.isScreenCapturePrevented,
                activeColor: const Color(0xFFD4AF37),
                onChanged: (val) => _security.setScreenCapturePrevention(val),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('개인정보 마스킹', style: TextStyle(color: Colors.white70, fontSize: 13)),
              Switch(
                key: const Key('switch_privacy_masking'),
                value: _security.isPrivacyMasked,
                activeColor: const Color(0xFFD4AF37),
                onChanged: (val) => _security.setPrivacyMasking(val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepTabs() {
    return Row(
      children: [
        _buildStepTabItem(0, '1. 본인확인'),
        const SizedBox(width: 8),
        _buildStepTabItem(1, '2. 등기부 연동'),
        const SizedBox(width: 8),
        _buildStepTabItem(2, '증빙 제출'),
      ],
    );
  }

  Widget _buildStepTabItem(int step, String label) {
    final isActive = _currentStep == step;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentStep = step),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFD4AF37) : const Color(0xFF1E222B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1IdentityAuth() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161920),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('휴대폰 본인확인', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            key: const Key('input_name'),
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: '이름 (성명)',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('input_phone'),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: '휴대폰 번호 (-없이 입력)',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('input_birth'),
            controller: _birthController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: '생년월일 (8자리, 예: 19800101)',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('btn_identity_verify'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _handleIdentityVerify,
              child: const Text('본인확인 진행', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          if (_identityResult != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                '인증 성공! 토큰: ${_identityResult!.verificationToken} (${_identityResult!.maskedName})',
                style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep2RegistrySync() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161920),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('1분 자동 등기부 연동', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('대법원 등기소 Trust API 기반 실소유주 검증', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          _buildLiveProgressTracker(),
          const SizedBox(height: 16),

          TextField(
            key: const Key('input_complex_name'),
            controller: _complexController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: '단지명 (예: 디에이치 방배)',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('input_building_number'),
            controller: _buildingController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: '동 (예: 101동)',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('input_unit_number'),
            controller: _unitController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: '호수 (예: 1502호)',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  key: const Key('btn_trust_api_sync'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _handleTrustApiSync,
                  child: const Text('등기부 자동 연동', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                key: const Key('btn_1tap_retry'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  side: const BorderSide(color: Color(0xFFD4AF37)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _handleTrustApiSync,
                child: const Text('⚡ 1-Tap 재시도', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (_trustResult != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD4AF37)),
              ),
              child: Text(
                '등기부 연동 완료! (${_trustResult!.assignedTier.toValue()}) 배지: ${_trustResult!.badge.toValue()}',
                style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLiveProgressTracker() {
    final step1Done = _identityResult != null;
    final step2Done = _trustResult != null;
    final step3Done = _trustResult?.status == 'VERIFIED';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.radar_rounded, color: Color(0xFFD4AF37), size: 16),
              SizedBox(width: 6),
              Text('Trust API 라이브 스캐닝 3단계', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildProgressStepItem(1, '1. 본인인증', step1Done, step1Done ? '완료' : '진행중'),
              _buildProgressStepItem(2, '2. 등기부 조회', step2Done, step2Done ? '완료' : (_isLoading ? '스캐닝...' : '대기')),
              _buildProgressStepItem(3, '3. 소유권 검증', step3Done, step3Done ? '완료' : '대기'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStepItem(int step, String label, bool isDone, String statusText) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: isDone ? const Color(0xFF4CAF50).withOpacity(0.15) : const Color(0xFF161920),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isDone ? Colors.greenAccent : Colors.white12),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: isDone ? Colors.greenAccent : Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(statusText, style: TextStyle(color: isDone ? Colors.greenAccent : (statusText.contains('스캐닝') ? const Color(0xFFD4AF37) : Colors.grey), fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3EvidenceAndDelegation() {

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161920),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('VVIP 자산 증빙 & 권한 위임', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSubTabItem(0, '자산 증빙 제출', const Key('tab_tier_evidence')),
              const SizedBox(width: 6),
              _buildSubTabItem(1, '가족/대리인 위임', const Key('tab_delegated_access')),
              const SizedBox(width: 6),
              _buildSubTabItem(2, '명의자 승인', const Key('tab_owner_approval')),
            ],
          ),
          const SizedBox(height: 16),
          if (_step3SubTab == 0) _buildSubTabEvidence(),
          if (_step3SubTab == 1) _buildSubTabDelegation(),
          if (_step3SubTab == 2) _buildSubTabApproval(),
        ],
      ),
    );
  }

  Widget _buildSubTabItem(int index, String title, Key key) {
    final isActive = _step3SubTab == index;
    return Expanded(
      child: GestureDetector(
        key: key,
        onTap: () => setState(() => _step3SubTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2A2F3D) : const Color(0xFF0F1115),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: isActive ? const Color(0xFFD4AF37) : Colors.transparent),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? const Color(0xFFD4AF37) : Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubTabEvidence() {
    return Column(
      children: [
        TextField(
          key: const Key('input_evidence_type'),
          controller: _evidenceTypeController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: '증빙 유형 (INCOME_CERT, PROPERTY_TAX)',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('input_doc_url'),
          controller: _docUrlController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: '증빙 문서 URL',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('input_instagram'),
          controller: _instagramController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Instagram 핸들 (선택)',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('input_referral'),
          controller: _referralController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: '추천인 코드 (선택)',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            key: const Key('btn_submit_evidence'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _handleSubmitEvidence,
            child: const Text('증빙 서류 제출', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
        if (_evidenceResult != null) ...[
          const SizedBox(height: 12),
          Text(
            '증빙 제출 완료 (${_evidenceResult!.status})',
            style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }

  Widget _buildSubTabDelegation() {
    return Column(
      children: [
        TextField(
          key: const Key('input_relationship'),
          controller: _relationshipController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: '관계 (FAMILY, SPOUSE)',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('input_delegated_doc_url'),
          controller: _delegatedDocUrlController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: '가족관계증명서 URL',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            key: const Key('btn_request_delegation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _handleRequestDelegation,
            child: const Text('권한 위임 신청', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
        if (_delegationResult != null) ...[
          const SizedBox(height: 12),
          Text(
            '위임 신청 완료 (${_delegationResult!.status})',
            style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }

  Widget _buildSubTabApproval() {
    return Column(
      children: [
        TextField(
          key: const Key('input_delegation_id'),
          controller: _delegationIdController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: '위임 요청 ID (delegation_id)',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                key: const Key('btn_approve_delegation'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                onPressed: () => _handleApproveDelegation(true),
                child: const Text('위임 승인', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                key: const Key('btn_reject_delegation'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () => _handleApproveDelegation(false),
                child: const Text('위임 거절', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        if (_approvalResult != null) ...[
          const SizedBox(height: 12),
          Text(
            '위임 승인 완료 (${_approvalResult!.status})',
            style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }
}
