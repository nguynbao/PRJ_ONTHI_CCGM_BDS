import 'package:client_app/config/routes/app_navigator.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client_app/common/app_button.dart';
import 'package:iconsax/iconsax.dart';
import 'forgot_password_page.dart';

class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() => _ForgotPasswordEmailPage();
}

class _ForgotPasswordEmailPage extends State<ForgotPasswordEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formkey.currentState!.validate()) {
      String email = _emailController.text;
      print('Email to send code: $email');

      AppNavigator.push(
        context,
        const ForgotPasswordPage()
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                AppNavigator.pop(context);
              },
              icon: Icon(
                Iconsax.arrow_left,
                size: 30,
                color: AppColor.textpriCol,
              ),
            ),
            Text(
              'Forgot Password',
              style: TextStyle(
                color: AppColor.textpriCol,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              _titleSection(),
              const SizedBox(height: 40),
              _emailInput(),
              const SizedBox(height: 40),
              AppButton(content: 'Tiếp tục', onPressed: _handleContinue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bạn quên mật khẩu?',
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Nhập email của bạn cần thay đổi mật khẩu để nhận mã xác thực.',
          style: TextStyle(
            color: AppColor.textpriCol.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        )
      ],
    );
  }

  Widget _emailInput() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if (value == null || value.isEmpty) {
          return 'Please enter your email.';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
          return 'Please enter a valid email address.';
        }
        return null;
      },
      style: TextStyle(
        color: AppColor.textpriCol,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'e.g., example@email.com',
        labelStyle: TextStyle(color: AppColor.textpriCol.withOpacity(0.8)),
        prefixIcon: Icon(Iconsax.sms, color: AppColor.buttonprimaryCol),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColor.textpriCol.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColor.textpriCol.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColor.buttonprimaryCol, width: 2
          ),
        ),
      )
    );
  }
}