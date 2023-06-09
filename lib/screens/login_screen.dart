import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/controller/auth_controller.dart';
import '/screens/signup_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var style = Theme.of(context);
    var headstyle = style.textTheme.displaySmall!.copyWith(color: Colors.black);
    var subheadstyle = style.textTheme.headlineSmall!
        .copyWith(color: Colors.grey, fontSize: 20);
    var btnstyle = style.textTheme.headlineSmall!.copyWith(color: Colors.white);
    var emailcontroller = TextEditingController();
    var passwordcontroller = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(20),
              Container(
                width: w,
                height: h * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('img/loginimg.png'),
                  ),
                ),
              ),
              Container(
                width: w,
                height: h * 0.6,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'WINNER\'s WORLD',
                      style: headstyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Sign into your account',
                      style: subheadstyle,
                    ),
                    const Gap(30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: const Offset(1, 1),
                              color: Colors.grey.shade200),
                        ],
                      ),
                      child: TextField(
                        controller: emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Enter your Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                    const Gap(20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: const Offset(1, 1),
                              color: Colors.grey.shade200),
                        ],
                      ),
                      child: TextField(
                        controller: passwordcontroller,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            hintText: 'Enter your Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Text(
                          'forgot your password?',
                          style: subheadstyle,
                        ),
                      ],
                    ),
                    const Gap(40),
                    Center(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AuthController.instance.login(
                              emailcontroller.text.trim(),
                              passwordcontroller.text.trim());
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: w * 0.5,
                          height: h * 0.07,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                              child: Text(
                            'Sign in',
                            style: btnstyle,
                          )),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: subheadstyle,
                          children: [
                            TextSpan(
                              text: 'Create',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  HapticFeedback.selectionClick();
                                  Get.to(() => const SignupPage());
                                },
                              style: subheadstyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
