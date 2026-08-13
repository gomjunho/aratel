import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/sticky_bottom_cta.dart';

class LoginScreen extends StatefulWidget {
  final AuthService? authService;
  final VoidCallback? onLoginSuccess;

  const LoginScreen({super.key, this.authService, this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthService _service;
  final _userIdController = TextEditingController(text: 'usr_1001');
  final _passwordController = TextEditingController(text: 'password123');
  bool _isRegisterMode = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.authService ?? AuthService();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isRegisterMode) {
        await _service.register(
          _userIdController.text.trim(),
          _passwordController.text.trim(),
          '신규 소유주 회원',
        );
      } else {
        await _service.login(
          _userIdController.text.trim(),
          _passwordController.text.trim(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isRegisterMode ? '회원가입 완료 및 로그인 성공' : 'ARATEL VVIP 인증 로그인 성공')),
        );
        widget.onLoginSuccess?.call();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: Text(
          _isRegisterMode ? 'ARATEL 회원가입' : 'ARATEL VVIP 로그인',
          style: const TextStyle(color: AppColors.satinGold, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.bgSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.satinGold.withOpacity(0.5), width: 2),
                      ),
                      child: const Icon(Icons.security_rounded, color: AppColors.satinGold, size: 48),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      '무결한 신뢰 자본과 VVIP 네트워크',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      '디에이치 방배 소유주 전용 암호화 플랫폼',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 32),

                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.statusError.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.statusError),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.statusError, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(_errorMessage!, style: const TextStyle(color: AppColors.statusError, fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  TextField(
                    key: const Key('login_user_id_field'),
                    controller: _userIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: _isRegisterMode ? '이메일 주소' : '아이디 또는 이메일',
                      labelStyle: const TextStyle(color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.satinGold),
                      filled: true,
                      fillColor: AppColors.bgSurface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    key: const Key('login_password_field'),
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: const TextStyle(color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.satinGold),
                      filled: true,
                      fillColor: AppColors.bgSurface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isRegisterMode ? '이미 계정이 있으신가요?' : '신규 소유주이신가요?',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                      TextButton(
                        key: const Key('toggle_auth_mode_button'),
                        onPressed: () {
                          setState(() {
                            _isRegisterMode = !_isRegisterMode;
                            _errorMessage = null;
                          });
                        },
                        child: Text(
                          _isRegisterMode ? '로그인하기' : '회원가입하기',
                          style: const TextStyle(color: AppColors.satinGold, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          StickyBottomCTA(
            key: const Key('submit_auth_button'),
            label: _isRegisterMode ? 'VVIP 회원가입' : 'VVIP 로그인',
            isLoading: _isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
