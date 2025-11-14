import 'package:client_app/common/app_button.dart';
import 'package:client_app/config/routes/app_navigator.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/widget/modal/show_modal.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CreateNewPasswordPage extends StatelessWidget {
  const CreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Title Page
            _titlePage(),
            const SizedBox(height: 25),
            _textFieldPwd(context),
            const SizedBox(height: 20),
            _textFieldNewPwd(context),
            const SizedBox(height: 50),
            AppButton(
              content: 'Continue',
              onPressed: () {
                showSuccessDialog(
                  context,
                  title: 'Lưu thành công',
                  message: 'Dữ liệu đã được lưu vào hệ thống.',
                  autoCloseAfter: const Duration(seconds: 2),
                  barrierDismissible: false,
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _textFieldNewPwd(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: -5,
          ),
        ],
      ),
      child: TextField(
        cursorColor: AppColor.textpriCol,
        obscureText: true,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hint: Text(
            'New Password',
            style: TextStyle(color: AppColor.textpriCol),
          ),
          prefixIcon: Icon(Iconsax.lock, color: AppColor.textpriCol),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.eye_slash,
              color: AppColor.textpriCol,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.buttonprimaryCol),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _textFieldPwd(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: -5,
          ),
        ],
      ),
      child: TextField(
        cursorColor: AppColor.textpriCol,
        obscureText: true,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hint: Text(
            'Password',
            style: TextStyle(color: AppColor.textpriCol),
          ),
          prefixIcon: Icon(Iconsax.lock, color: AppColor.textpriCol),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.eye_slash,
              color: AppColor.textpriCol,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.buttonprimaryCol),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _titlePage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Create Your New Password',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.textpriCol,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}