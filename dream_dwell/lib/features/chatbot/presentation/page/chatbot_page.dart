import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/chatbot/presentation/widget/chatbot_widget.dart';
import 'package:dream_dwell/features/chatbot/presentation/widget/chatbot_fab.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_event.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_state.dart';

class ChatbotPage extends StatelessWidget {
  final Widget child;

  const ChatbotPage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatbotBloc(
        sendChatQueryUseCase: context.read(), // This will be provided by dependency injection
      ),
      child: BlocBuilder<ChatbotBloc, ChatbotState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Main content
              child,
              
              // Chatbot FAB
              ChatbotFAB(
                onPressed: () {
                  context.read<ChatbotBloc>().add(const ToggleChatbotVisibility());
                },
                isVisible: state is ChatbotLoaded && !state.isVisible,
              ),
              
              // Chatbot Widget
              if (state is ChatbotLoaded && state.isVisible)
                ChatbotWidget(
                  onClose: () {
                    context.read<ChatbotBloc>().add(const ToggleChatbotVisibility());
                  },
                  isMinimized: state.isMinimized,
                ),
            ],
          );
        },
      ),
    );
  }
} 