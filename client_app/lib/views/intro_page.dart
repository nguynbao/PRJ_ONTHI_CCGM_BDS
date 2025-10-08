import 'package:client_app/common/app_button.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      extendBody: true,
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              //To do Skip
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: AppColor.textpriCol,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            padEnds: true,
            controller: pageController,
            children: [
              _screenIntro(
                'Online Learning',
                'We Provide Classes Online Classes and Pre Recorded Leactures.!',
              ),
              _screenIntro(
                'Learn from Anytime',
                'Booked or Same the Lectures for Future',
              ),
              _screenIntro(
                'Get Online Certificate',
                'Analyse your scores and Track your results',
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _indicator(),
                  AppButton(
                    content: 'Get Started',
                    onPressed: () {
                      if (currentIndex == 2) {
                        //CARRY OUT TO MOVE ON NEW PAGE
                      } else {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.bounceInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicator() {
    return SmoothPageIndicator(
      controller: pageController,
      count: 3,
      effect: ExpandingDotsEffect(
        activeDotColor: AppColor.buttonprimaryCol,
        dotColor: Colors.grey.shade400,
        dotHeight: 10,
        dotWidth: 10,
      ),
    );
  }

  Widget _screenIntro(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColor.textpriCol,
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.textpriCol,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
