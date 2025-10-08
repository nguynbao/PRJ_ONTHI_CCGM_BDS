import 'package:client_app/common/app_button.dart';
import 'package:client_app/config/assets/app_icon.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';

class OptPage extends StatelessWidget {
  const OptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        minimum: EdgeInsets.only(bottom: 80),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Let\'s you in',
                style: TextStyle(
                  color: AppColor.textpriCol,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              _buildOpt(
                icons: AppIcon.googleIcon,
                method: "Google",
                context: context,
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              _buildOpt(
                icons: AppIcon.apppleIcon,
                method: "Apple",
                context: context,
                onPressed: () {},
              ),
              const SizedBox(height: 60),
              const Text(
                '( Or )',
                style: TextStyle(
                  color: AppColor.textpriCol,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: AppButton(
                  content: 'Sign In with Your Account',
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 30),
              _moveOnSignUp(),
            ],
          ),
        ),
      ),
    );
  }

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
            minimumSize: Size(0, 0), 
            tapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // 🔹 giảm vùng nhấn
          ),
          onPressed: () {},
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

  Widget _buildOpt({
    required VoidCallback onPressed,
    icons,
    required String method,
    required BuildContext context,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .55,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
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
              alignment: Alignment.center,
              child: Center(
                child: Image.asset(
                  icons,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Continue with ${method}',
              style: TextStyle(
                color: AppColor.textpriCol,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
