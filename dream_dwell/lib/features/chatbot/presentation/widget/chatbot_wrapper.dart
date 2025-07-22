import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/chatbot/presentation/widget/chatbot_widget.dart';
import 'package:dream_dwell/features/chatbot/presentation/widget/chatbot_fab.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_event.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_state.dart';
import 'package:dream_dwell/features/chatbot/domain/use_case/send_chat_query_usecase.dart';
import 'package:dream_dwell/app/service_locator/service_locator.dart';

class ChatbotWrapper extends StatelessWidget {
  final Widget child;
  final bool showChatbot;

  const ChatbotWrapper({
    Key? key,
    required this.child,
    this.showChatbot = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showChatbot) {
      return child;
    }

    return BlocProvider(
      create: (context) => ChatbotBloc(
        sendChatQueryUseCase: serviceLocator<SendChatQueryUseCase>(),
      )..add(const InitializeChatbot()),
      child: BlocBuilder<ChatbotBloc, ChatbotState>(
        builder: (context, state) {
          print('=== CHATBOT WRAPPER DEBUG ===');
          print('Current state: ${state.runtimeType}');
          if (state is ChatbotLoaded) {
            print('isVisible: ${state.isVisible}');
            print('isMinimized: ${state.isMinimized}');
            print('messages count: ${state.messages.length}');
          }
          print('=== END CHATBOT WRAPPER DEBUG ===');
          
          return Stack(
            children: [
              // Main content
              child,
              
              // Chatbot FAB - show when chatbot is not visible
              if (state is ChatbotLoaded && !state.isVisible)
                ChatbotFAB(
                  onPressed: () {
                    print('FAB pressed - toggling chatbot visibility');
                    context.read<ChatbotBloc>().add(const ToggleChatbotVisibility());
                  },
                  isVisible: true,
                ),
              
              // Chatbot Widget - show when chatbot is visible
              if (state is ChatbotLoaded && state.isVisible)
                ChatbotWidget(
                  onClose: () {
                    print('Chatbot close button pressed');
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