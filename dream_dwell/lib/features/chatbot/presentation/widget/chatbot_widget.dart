import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/chatbot/presentation/widget/chat_message_widget.dart';
import 'package:dream_dwell/features/chatbot/presentation/widget/chat_input_widget.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_event.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_state.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_query_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_message_entity.dart';

class ChatbotWidget extends StatefulWidget {
  final VoidCallback? onClose;
  final bool isMinimized;

  const ChatbotWidget({
    super.key,
    this.onClose,
    this.isMinimized = false,
  });

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize chatbot when widget is created
    context.read<ChatbotBloc>().add(const InitializeChatbot());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage(String message) {
    if (message.trim().isEmpty) return;

    final bloc = context.read<ChatbotBloc>();
    final currentState = bloc.state;

    if (currentState is ChatbotLoaded) {
      // Format history for API (exclude initial bot greeting)
      final history = currentState.messages
          .skip(1) // Skip initial bot message
          .map((msg) => ChatHistoryEntity(
                role: msg.sender == 'bot' ? 'model' : 'user',
                text: msg.text,
              ))
          .toList();

      bloc.add(SendChatMessage(
        message: message,
        history: history,
      ));
    }
  }

  void _handleMinimize() {
    context.read<ChatbotBloc>().add(const MinimizeChatbot());
  }

  void _handleMaximize() {
    context.read<ChatbotBloc>().add(const MaximizeChatbot());
  }

  @override
  Widget build(BuildContext context) {
    print('=== CHATBOT WIDGET BUILD ===');
    return BlocConsumer<ChatbotBloc, ChatbotState>(
      listener: (context, state) {
        print('Chatbot state changed: ${state.runtimeType}');
        if (state is ChatbotLoaded) {
          print('ChatbotLoaded - messages: ${state.messages.length}, isVisible: ${state.isVisible}, isMinimized: ${state.isMinimized}');
          // Scroll to bottom when new messages are added
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      },
      builder: (context, state) {
        print('Chatbot builder called with state: ${state.runtimeType}');
        if (state is ChatbotLoaded) {
          print('Building ChatbotLoaded state');
          if (state.isMinimized) {
            print('Building minimized widget');
            return _buildMinimizedWidget(state);
          }
          print('Building full widget');
          return _buildFullWidget(state);
        }
        
        print('Building initial/loading state');
        // Show loading or initial state
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMinimizedWidget(ChatbotLoaded state) {
    return Positioned(
      bottom: 100,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 80,
              minHeight: 60,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF002B5B),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Text(
                          'DreamBot - AI Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: _handleMaximize,
                        icon: const Icon(
                          Icons.open_in_full,
                          color: Colors.white,
                          size: 18,
                      ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidget(ChatbotLoaded state) {
    return Positioned(
      bottom: 100,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 500,
              minHeight: 200,
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF002B5B),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Text(
                          'DreamBot - AI Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: _handleMinimize,
                        icon: const Icon(
                          Icons.minimize,
                          color: Colors.white,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                
                // Messages area
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length && state.isLoading) {
                          return const ChatMessageWidget(
                            message: ChatMessageEntity(
                              id: 'loading',
                              text: 'DreamBot is typing...',
                              sender: 'bot',
                              timestamp: null,
                            ),
                            isLoading: true,
                          );
                        }
                        
                        return ChatMessageWidget(
                          message: state.messages[index],
                          isLoading: false,
                        );
                      },
                    ),
                  ),
                ),
                
                // Input area
                ChatInputWidget(
                  onSendMessage: _handleSendMessage,
                  isLoading: state.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 