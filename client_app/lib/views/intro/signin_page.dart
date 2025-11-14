import 'package:apptomate_custom_checkbox/apptomate_custom_checkbox.dart';
import 'package:client_app/common/app_button.dart';
import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/controllers/auth.controller.dart';
import 'package:client_app/views/intro/signup_page.dart'; 
import 'package:client_app/views/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  // ---- FORM & CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();

  // ---- UI STATE
  bool _obscure = true;
  bool _loading = false;
  bool _rememberMe = false;

  final _auth = AuthController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  // ---- VALIDATORS
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Email is invalid';
  }

  String? _validatePwd(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'At least 6 characters';
    return null;
  }

  // ---- LOGIN HANDLER
  Future<void> _onLogin() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _loading = true);
    try {
      // 🔥 GỌI PHƯƠNG THỨC ĐĂNG NHẬP FIREBASE
      await _auth.signIn(
        email: _emailController.text.trim(),
        password: _pwdController.text,
      );

      if (!mounted) return;
      
      // ✅ Đăng nhập thành công, Firebase Auth tự động cập nhật trạng thái
      //    và AuthChecker (trong main.dart) sẽ tự động chuyển hướng sang MainScreen.
      //    Chúng ta chỉ cần quay lại màn hình trước đó (hoặc đóng màn hình đăng nhập
      //    nếu nó được push), hoặc popUntil root nếu muốn chắc chắn.
      
      // Sử dụng Navigator.of(context).pop() để đóng SigninPage
      // và AuthChecker sẽ hiển thị MainScreen.
     Navigator.push(context, MaterialPageRoute(builder: (_)=> const MainScreen()));

    } catch (e) {
      if (!mounted) return;
      // Hiển thị lỗi từ AuthService (ví dụ: 'Mật khẩu không chính xác.')
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login failed: ${e.toString().replaceFirst('Exception: ', '')}')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ====== UI ======
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titlePage(),
                  const SizedBox(height: 32),

                  // Email
                  _inputWrapper(
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: AppColor.textpriCol,
                      decoration: _decoration(
                        hint: 'Email',
                        prefix: const Icon(Iconsax.sms, color: AppColor.textpriCol),
                      ),
                      validator: _validateEmail,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Password
                  _inputWrapper(
                    child: TextFormField(
                      controller: _pwdController,
                      cursorColor: AppColor.textpriCol,
                      obscureText: _obscure,
                      decoration: _decoration(
                        hint: 'Password',
                        prefix: const Icon(Iconsax.lock, color: AppColor.textpriCol),
                        suffix: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Iconsax.eye_slash : Iconsax.eye,
                            color: AppColor.textpriCol,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: _validatePwd,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Remember me + Forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomCheckbox(
                              padding: EdgeInsets.zero,
                              activeColor: const Color(0xff50B748),
                              value: _rememberMe,
                              onChanged: (v) => setState(() => _rememberMe = v ?? false),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Remember Me',
                              style: TextStyle(
                                color: AppColor.textpriCol,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Forgot password flow
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColor.textpriCol,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nút Sign In (gọi _onLogin + loading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AppButton(
                      content: _loading ? 'Please wait...' : 'Sign In',
                      onPressed:  _onLogin, 
                    ),
                  ),
                  const SizedBox(height: 20),

                  _optSignUp(),
                  const SizedBox(height: 14),
                  _methodSignUp(),
                  const SizedBox(height: 16),
                  _moveOnSignUp(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---- Widgets phụ trợ UI ----
  Widget _moveOnSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an Account?',
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 5),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            // Điều hướng sang màn hình Đăng ký
            // Sử dụng pushReplacement vì SigninPage được gọi từ SignupPage,
            // hoặc dùng push nếu bạn muốn người dùng có thể quay lại Signin.
            // Trong luồng AuthChecker, dùng push Replacement là hợp lý hơn.
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SignupPage()),
            );
          },
          child: const Text(
            'SIGN UP',
            style: TextStyle(
              color: AppColor.buttonprimaryCol,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _methodSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconMethod(AppIcons.googleIcon, () {}),
        const SizedBox(width: 25),
        _iconMethod(AppIcons.apppleIcon, () {}),
      ],
    );
  }

  Widget _iconMethod(String icons, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.25),
              offset: const Offset(0, 1),
              blurRadius: 10,
              spreadRadius: -5,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Image.asset(icons, width: 20, height: 20, fit: BoxFit.contain),
      ),
    );
  }

  Widget _optSignUp() {
    return const Center(
      child: Text(
        'Or Continue With',
        style: TextStyle(
          color: AppColor.textpriCol,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  InputDecoration _decoration({required String hint, Widget? prefix, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColor.textpriCol),
      prefixIcon: prefix,
      suffixIcon: suffix,
      border: _border(Colors.transparent),
      enabledBorder: _border(Colors.transparent),
      focusedBorder: _border(AppColor.buttonprimaryCol),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }

  Widget _inputWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            offset: const Offset(0, 1),
            blurRadius: 10,
            spreadRadius: -5,
          ),
        ],
      ),
      child: child,
    );
  }

  OutlineInputBorder _border(Color c) =>
      OutlineInputBorder(borderSide: BorderSide(color: c), borderRadius: BorderRadius.circular(10));

  Widget _titlePage() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let’s Sign In.!',
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Login to Your Account to Continue your Courses',
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}