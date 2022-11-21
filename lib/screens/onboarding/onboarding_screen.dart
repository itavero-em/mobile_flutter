import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:itavero_mobile/main.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  /*SizedBox get _signupButton {
    return SizedBox(
      width: width,
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          borderRadius: defaultProceedButtonBorderRadius,
          color: defaultProceedButtonColor,
          child: InkWell(
            borderRadius: defaultProceedButtonBorderRadius,
            onTap: () {},
            child: const Padding(
              padding: defaultProceedButtonPadding,
              child: Text(
                'Sign up',
                style: defaultProceedButtonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  void _onIntroEnd(context) {
    Provider.of<SettingsProvider>(context, listen: false).setShowIntro(false);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MobileApp()),
    );
  }

  final Widget svg = SvgPicture.asset(
      "assets/images/undraw_mobile_development_re_wwsn.svg",
      semanticsLabel: 'Image 1',
  height: 40,);

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      titlePadding: EdgeInsets.fromLTRB(0, 140.0, 0, 0),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: const Image(image: AssetImage('assets/images/logo_ita.gif')),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Überspringen',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Willkommen",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: SvgPicture.asset(
          "assets/images/undraw_mobile_application_re_13u3.svg",
            semanticsLabel: 'Image 1',
            height: 150,),
                ),
              SizedBox(height: 20),
              Text(
                  "Nun ist es endlich soweit.\nDu kannst ab sofort "
                  "ausgewählte Logistikprozesse auch ganz bequem über dein mobiles "
                  "Endgerät durchführen.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center),
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Inspiration",
          bodyWidget: Column(
            children: [
              Text(
                  "Sprich uns an, wenn du Ideen hast, wie wir deine Arbeit erleichtern können, indem wir neue Web-Apps bauen.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center),
              SizedBox(height: 20),
              SvgPicture.asset(
                "assets/images/undraw_mobile_development_re_wwsn.svg",
                semanticsLabel: 'Image 1',
                height: 150,),
            ],
          ),
          decoration: pageDecoration,
        )
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          )),
      dotsContainerDecorator: const ShapeDecoration(
          color: Colors.black87,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)))),
    );
  }
}
