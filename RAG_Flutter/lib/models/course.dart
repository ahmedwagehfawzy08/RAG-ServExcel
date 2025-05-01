import 'package:flutter/material.dart';

class Course {
  final String title, description, iconSrc;
  final Color bgColor;

  Course({
    required this.title,
    
    this.description = """- Ask your question directly without greetings or introductions
- Try to ask one clear question for a focused answer""",
    this.iconSrc = "assets/icons/En.svg",
    this.bgColor = const Color(0xFF7553F6),
  });
}

List<Course> courses = [
  Course(title: "Prompt in English"
  
  ),
  Course(
    title: "ازاي تكتب\n برومبت صح",
    description: """- اسأل سؤالك على طول بدون ترحيب أو مقدمات
-متستخدمش علامات ترقيم كتير
-حاول تسأل سؤال واحد بس علشان الرد يكون دقيق
""",
    iconSrc: "assets/icons/Ar.svg",
    bgColor: const Color(0xFF80A4FF),
  ),
];



List<Course> recentCourses = [
  Course(title: "E2EE",
  iconSrc: "assets/icons/Dataa.svg",
  description: "This feature ensures your chats are private"
  ),
  Course(
    title: "Local Model",
    bgColor: const Color(0xFF9CC5FF),
    iconSrc: "assets/icons/Dataa.svg",
    description: "AI runs locally on your device for privacy"
  ),

];