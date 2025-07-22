import 'package:flutter/material.dart';

class ChatbotFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isVisible;

  const ChatbotFAB({
    Key? key,
    required this.onPressed,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('=== CHATBOT FAB DEBUG ===');
    print('isVisible: $isVisible');
    print('onPressed: ${onPressed != null}');
    
    if (!isVisible) {
      print('FAB not visible, returning SizedBox.shrink()');
      return const SizedBox.shrink();
    }

    print('Rendering FAB at bottom: 16, right: 16');
    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              print('FAB tapped!');
              onPressed();
            },
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF002B5B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.message,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 