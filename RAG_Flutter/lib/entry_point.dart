import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/constants.dart';
import 'models/rive_asset.dart';
import 'package:rive_animation/utils/rive_utils.dart';
// import 'page1.dart';
import 'page2.dart';
import 'ChatHistoryScreen.dart';
// import 'screens/onboding/home/home_screen.dart';
import 'components/animated_bar.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  RiveAsset selectedBottomNav = bottomNavs.first;

  Widget _getSelectedPage() {
    switch (selectedBottomNav.title) {
      case "Home":
        return HomeScreen(); // استبدال  بـ HomeScreen
      case "Page2":
        return const Page2();
      case "Page3":
        return const ChatHistoryScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: _getSelectedPage(),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 80),
          decoration: BoxDecoration(
            color: backgroundColor2.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                bottomNavs.length,
                (index) => GestureDetector(
                  onTap: () {
                    bottomNavs[index].input!.change(true);
                    if (bottomNavs[index] != selectedBottomNav) {
                      setState(() {
                        selectedBottomNav = bottomNavs[index];
                      });
                    }
                    Future.delayed(const Duration(seconds: 1), () {
                      bottomNavs[index].input!.change(false);
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBar(
                        isActive: bottomNavs[index] == selectedBottomNav,
                      ),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: Opacity(
                          opacity: bottomNavs[index] == selectedBottomNav ? 1 : 0.5,
                          child: RiveAnimation.asset(
                            bottomNavs[index].src,
                            artboard: bottomNavs[index].artboard,
                            onInit: (artboard) {
                              StateMachineController controller =
                                  RiveUtils.getRiveController(
                                artboard,
                                stateMachineName:
                                    bottomNavs[index].stateMachineName,
                              );
                              bottomNavs[index].input =
                                  controller.findSMI("active") as SMIBool;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
