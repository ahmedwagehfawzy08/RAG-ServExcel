import 'package:flutter/material.dart';
import 'chat.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center( // Added Center widget here
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Added for horizontal centering
                children: [
                  // صورة الروبوت (Robot image)
                  Image.asset(
                    "images/c.png",
                    height: 400, // زيادة حجم الصورة
                  ),
                  const SizedBox(height: 25), // زيادة المسافة بعد الصورة
                  const Text(
                    'I am ServExcel!\nYour Own AI Assistant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 24), // زيادة المسافة بين العناوين
                  const Text(
                    'Ask Your questions and Boost productivity\nWith an AI-Powered personal Assistant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 50), // زيادة المسافة قبل الزر
                  // زر مخصص مع سهم على الجانب الأيمن
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatServ()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF333333),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 24, right: 4),
                      height: 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Chat With ServExcel',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // حاوية السهم الأرجواني على الجانب الأيمن
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8A2BE2), // لون أرجواني
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 26,
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
        ),
      ),
    );
  }
}
