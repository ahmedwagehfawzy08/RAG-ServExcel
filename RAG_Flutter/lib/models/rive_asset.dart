import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';
import '../../../../models/course.dart';
// import '../../../../page1.dart';
// import '../../../../page2.dart';
// import '../../../../page3.dart';
// import 'home/components/course_card.dart';
import 'package:rive_animation/screens/onboding/home/components/course_card.dart';
// import 'package:rive_animation/screens/onboding/home/home_screen.dart';
// كلاس RiveAsset
class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

// قائمة الأيقونات
List<RiveAsset> bottomNavs = [
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "BELL",
      stateMachineName: "BELL_Interactivity",
      title: "Page1"),
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "CHAT",
      stateMachineName: "CHAT_Interactivity",
      title: "Page2"),
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "TIMER",
      stateMachineName: "TIMER_Interactivity",
      title: "Page3"),
];

// الصفحة الرئيسية HomeScreen
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // void _navigateToPage(BuildContext context, String title) {
  //   Widget page;
  //   switch (title) {
  //     case "Home":
  //       page = HomeScreen();
  //       break;
  //     case "Page2":
  //       page = const Page2();
  //       break;
  //     case "Page3":
  //       page = const Page3();
  //       break;
  //     default:
  //       return;
  //   }
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Prompt",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: courses
                      .map((course) => Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: CourseCard(course: course),
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Features",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ...recentCourses.map(
                (course) => Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: SecondaryCourseCard(course: course),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   margin: const EdgeInsets.all(16),
      //   padding: const EdgeInsets.symmetric(horizontal: 20),
      //   height: 70,
      //   decoration: BoxDecoration(
      //     color: const Color(0xFF2C3243),
      //     borderRadius: BorderRadius.circular(30),
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: bottomNavs.map((riveAsset) {
      //       return GestureDetector(
      //         onTap: () {
      //           if (riveAsset.input != null) {
      //             riveAsset.input!.change(true);
      //             Future.delayed(const Duration(milliseconds: 800), () {
      //               riveAsset.input!.change(false);
      //             });
      //           }
      //           _navigateToPage(context, riveAsset.title);
      //         },
      //         child: SizedBox(
      //           height: 40,
      //           width: 40,
      //           child: RiveAnimation.asset(
      //             riveAsset.src,
      //             artboard: riveAsset.artboard,
      //             stateMachines: [riveAsset.stateMachineName],
      //             onInit: (artboard) {
      //               final controller = StateMachineController.fromArtboard(
      //                 artboard,
      //                 riveAsset.stateMachineName,
      //               );
      //               if (controller != null) {
      //                 artboard.addController(controller);
      //                 final input = controller.findInput<bool>("active");
      //                 if (input is SMIBool) {
      //                   riveAsset.setInput = input;
      //                 }
      //               }
      //             },
      //           ),
      //         ),
      //       );
      //     }).toList(),
      //   ),
      // ),
    );
  }
}

class SecondaryCourseCard extends StatelessWidget {
  const SecondaryCourseCard({Key? key, required this.course}) : super(key: key);

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: course.bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  course.title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  course.description,
                  style: const TextStyle(color: Colors.white60, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40, child: VerticalDivider(color: Colors.white70)),
          const SizedBox(width: 8),
          SvgPicture.asset(course.iconSrc),
        ],
      ),
    );
  }
}
