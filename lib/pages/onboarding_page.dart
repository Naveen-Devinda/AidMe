import 'package:aidme/data/onboardingdata.dart';
import 'package:aidme/pages/create_acc.dart';

import 'package:aidme/pages/onboarding/sharedonbrdscreens.dart';
import 'package:aidme/widgets/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:aidme/pages/onboarding/firstpage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController controller = PageController();
  bool showDetailsPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                //Onboarding screens
                PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() {
                      showDetailsPage = index == 3;
                    });
                  },
                  children: [
                    FrontPage(),

                    Sharedonbrdscreens(
                      title: Onboardingdata.onBoardingdatalist[0].title,
                      imagepath: Onboardingdata.onBoardingdatalist[0].imagepath,
                      description:
                          Onboardingdata.onBoardingdatalist[0].description,
                    ),
                    Sharedonbrdscreens(
                      title: Onboardingdata.onBoardingdatalist[1].title,
                      imagepath: Onboardingdata.onBoardingdatalist[1].imagepath,
                      description:
                          Onboardingdata.onBoardingdatalist[1].description,
                    ),
                    Sharedonbrdscreens(
                      title: Onboardingdata.onBoardingdatalist[2].title,
                      imagepath: Onboardingdata.onBoardingdatalist[2].imagepath,
                      description:
                          Onboardingdata.onBoardingdatalist[2].description,
                    ),
                  ],
                ),

                // page doc indigators
                Container(
                  alignment: const Alignment(0, 0.75),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 4,
                    effect: const WormEffect(
                      activeDotColor: Color(0xff3FBBBB),
                      dotColor: Color(0xf06B6B6F),
                    ),
                  ),
                ),

                //navigation button impliment
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GestureDetector(
                      onTap: () {
                        if (showDetailsPage) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAcc(),
                            ),
                          );
                        } else {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },

                      child: Custombutton(
                        buttonName: showDetailsPage ? "Get Started" : "Next",
                        buttonColor: const Color(0xff3FBBBB),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
