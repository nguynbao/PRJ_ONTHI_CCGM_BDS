import 'package:client_app/common/app_button.dart';
import 'package:client_app/config/assets/app_images.dart';
import 'package:client_app/config/routes/app_navigator.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FillProfilePage extends StatelessWidget {
  const FillProfilePage({super.key});

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
              'Fill Your Profile',
              style: TextStyle(
                color: AppColor.textpriCol,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        spacing: 18,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _editAvt(),
          const SizedBox(height: 6),
          _textFieldFullName(context),
          _textFieldUserName(context),
          _textFieldDateBirth(context),
          _textFieldEmail(context),
          _textFieldPhoneNum(context),
          _textFieldGender(context),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: AppButton(content: 'Sign In', onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget _textFieldUserName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
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
          decoration: InputDecoration(
            hint: Text(
              'Full Name',
              style: TextStyle(color: AppColor.textpriCol),
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
      ),
    );
  }

  Widget _textFieldFullName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
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
          decoration: InputDecoration(
            hint: Text(
              'Full Name',
              style: TextStyle(color: AppColor.textpriCol),
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
      ),
    );
  }

  Widget _textFieldDateBirth(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
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
          decoration: InputDecoration(
            hint: Text(
              'Date of Birth',
              style: TextStyle(color: AppColor.textpriCol),
            ),
            prefixIcon: Icon(Iconsax.calendar, color: AppColor.textpriCol),

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
      ),
    );
  }

  Widget _textFieldEmail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
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
          decoration: InputDecoration(
            hint: Text('Email', style: TextStyle(color: AppColor.textpriCol)),
            prefixIcon: Icon(Iconsax.sms, color: AppColor.textpriCol),
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
      ),
    );
  }

  Widget _textFieldPhoneNum(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
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
          decoration: InputDecoration(
            hint: Text(
              'Phone Number',
              style: TextStyle(color: AppColor.textpriCol),
            ),
            prefixIcon: Icon(Iconsax.call, color: AppColor.textpriCol),
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
      ),
    );
  }

  Widget _textFieldGender(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
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
          decoration: InputDecoration(
            hint: Text('Gender', style: TextStyle(color: AppColor.textpriCol)),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(
                Iconsax.arrow_down_14,
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
      ),
    );
  }

  Widget _editAvt() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.demoAvt),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 1),
              blurRadius: 10,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.buttomSecondCol,
                ),
                child: Icon(Iconsax.edit, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
