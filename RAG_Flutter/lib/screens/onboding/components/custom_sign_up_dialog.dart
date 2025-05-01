import 'package:flutter/material.dart';
import 'sign_up_form.dart';

Future<Object?> customSignupDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Sign Up",
    context: context,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (_, animation, __, child) {
      Tween<Offset> tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 600,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: const [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 34,
                      fontFamily: "Poppins",
                      color: Color.fromARGB(137, 209, 44, 44),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Create your account and join ServExcel",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SignUpForm(),
                ],
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}
