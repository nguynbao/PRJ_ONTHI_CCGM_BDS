import 'package:apptomate_custom_checkbox/apptomate_custom_checkbox.dart';
import 'package:client_app/common/app_button.dart';
import 'package:client_app/config/assets/app_icons.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/controllers/auth.controller.dart';

import 'package:client_app/views/intro/fill_profile_page.dart'; // Import trang Profile mới
import 'package:client_app/views/intro/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  final _auth = AuthController();
  bool _agree = false;
  bool _obscure = true;
  bool _loading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final email = v.trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!ok) return 'Email is invalid';
    return null;
  }

  String? _validatePwd(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'At least 6 characters';
    return null;
  }

  String? _validateConfirmPwd(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _pwdController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _onContinue() async {
    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Conditions')),
      );
      return;
    }
    
    // 🔥 BƯỚC 1: CHUYỂN HƯỚNG SANG TRANG PROFILE VỚI DỮ LIỆU EMAIL/PASSWORD
    setState(() => _loading = true);
    
    // Gửi dữ liệu email và password sang trang FillProfilePage
    if (!mounted) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FillProfilePage(
          email: _emailController.text.trim(),
          password: _pwdController.text,
        ),
      ),
    );
    
    // Đặt loading lại sau khi chuyển trang (Nếu không, loading sẽ bị lỗi sau khi quay lại)
    setState(() => _loading = false);
  }

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
                  _textFieldEmail(context),
                  const SizedBox(height: 12),
                  _textFieldPwd(context),
                  const SizedBox(height: 12),
                  _textFieldConfirmPwd(context),
                  const SizedBox(height: 12),
                  _checkBoxConfirm(),
                  const SizedBox(height: 16),

                  // Nút Continue
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AppButton(
                      content: _loading ? 'Please wait...' : 'Continue',
                      onPressed: _onContinue, // Đổi sang _onContinue
                    ),
                  ),

                  const SizedBox(height: 20),
                  _optSignUp(),
                  const SizedBox(height: 14),
                  _methodSignUp(),
                  const SizedBox(height: 16),
                  _moveOnSignIn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // (Các widget _moveOnSignIn, _methodSignUp, _iconMethod, _optSignUp, _checkBoxConfirm, 
  // _textFieldPwd, _textFieldEmail, _inputWrapper, _border, _titlePage giữ nguyên như code cũ của bạn)

  Widget _moveOnSignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an Account?',
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
            // TODO: điều hướng sang Sign In
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SigninPage()),
            );
          },
          child: const Text(
            'SIGN IN',
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
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
      ),
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

  Widget _checkBoxConfirm() {
    return Row(
      children: [
        CustomCheckbox(
          padding: EdgeInsets.zero,
          activeColor: const Color(0xff50B748),
          value: _agree,
          onChanged: (value) => setState(() => _agree = value ?? false),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Agree to Terms & Conditions',
            style: TextStyle(
              color: AppColor.textpriCol,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFieldPwd(BuildContext context) {
    return _inputWrapper(
      child: TextFormField(
        controller: _pwdController,
        obscureText: _obscure,
        cursorColor: AppColor.textpriCol,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(color: AppColor.textpriCol),
          prefixIcon: const Icon(Iconsax.lock, color: AppColor.textpriCol),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
              _obscure ? Iconsax.eye_slash : Iconsax.eye,
              color: AppColor.textpriCol,
              size: 20,
            ),
          ),
          border: _border(Colors.transparent),
          enabledBorder: _border(Colors.transparent),
          focusedBorder: _border(AppColor.buttonprimaryCol),
        ),
        validator: _validatePwd,
      ),
    );
  }

  Widget _textFieldEmail(BuildContext context) {
    return _inputWrapper(
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        cursorColor: AppColor.textpriCol,
        decoration: InputDecoration(
          prefixIcon: const Icon(Iconsax.sms, color: AppColor.textpriCol),
          hintText: 'Email',
          hintStyle: const TextStyle(color: AppColor.textpriCol),
          border: _border(Colors.transparent),
          enabledBorder: _border(Colors.transparent),
          focusedBorder: _border(AppColor.buttonprimaryCol),
        ),
        validator: _validateEmail,
      ),
    );
  }

  Widget _textFieldConfirmPwd(BuildContext context) {
    return _inputWrapper(
      child: TextFormField(
        controller: _confirmPwdController,
        obscureText: _obscure,
        cursorColor: AppColor.textpriCol,
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          hintStyle: const TextStyle(color: AppColor.textpriCol),
          prefixIcon: const Icon(Iconsax.lock, color: AppColor.textpriCol),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
              _obscure ? Iconsax.eye_slash : Iconsax.eye,
              color: AppColor.textpriCol,
              size: 20,
            ),
          ),
          border: _border(Colors.transparent),
          enabledBorder: _border(Colors.transparent),
          focusedBorder: _border(AppColor.buttonprimaryCol),
        ),
        validator: _validateConfirmPwd,
      ),
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

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color),
    borderRadius: BorderRadius.circular(10),
  );

  Widget _titlePage() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Getting Started.!',
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Create an Account to Continue your allCourses',
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