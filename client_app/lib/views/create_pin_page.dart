import 'package:client_app/common/app_button.dart';
import 'package:client_app/config/routes/app_navigator.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CreatePinPage extends StatelessWidget {
  const CreatePinPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                'Create New Pin',
                style: TextStyle(
                  color: AppColor.textpriCol,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80,),
              _titlePage(), 
              const SizedBox(height: 86,),
              _txtFiePinCode(context),
              const SizedBox(height: 86,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: AppButton(content: 'Continue', onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _txtFiePinCode(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 80,
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
            onChanged: (value) {
              if(value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
            keyboardType: TextInputType.number,
            cursorHeight: 30,
            maxLines: 1,
            obscureText: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.textpriCol,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            obscuringCharacter: '*',
            cursorColor: AppColor.textpriCol,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
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
      }),
    );
  }

  Widget _titlePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: const Text(
        'Add a Pin Number to Make Your Account more Secure',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColor.textpriCol,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}
