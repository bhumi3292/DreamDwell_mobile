import 'package:flutter/material.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;

  const ChatInputWidget({
    super.key,
    required this.onSendMessage,
    this.isLoading = false,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final message = _controller.text.trim();
    print('=== CHAT INPUT DEBUG ===');
    print('Message: "$message"');
    print('Message is empty: ${message.isEmpty}');
    print('Is loading: ${widget.isLoading}');
    
    if (message.isNotEmpty && !widget.isLoading) {
      print('Calling onSendMessage with: "$message"');
      widget.onSendMessage(message);
      _controller.clear();
      _focusNode.unfocus();
      print('Message sent successfully');
    } else {
      print('Message not sent - empty or loading');
    }
    print('=== END CHAT INPUT DEBUG ===');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 120,
          minHeight: 80,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text input
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 80,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: !widget.isLoading,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: widget.isLoading 
                              ? 'Sending...' 
                              : 'Type your message...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Send button
                  Container(
                    decoration: BoxDecoration(
                      color: widget.isLoading || _controller.text.trim().isEmpty
                          ? Colors.grey[400]
                          : const Color(0xFF002B5B),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        print('=== SEND BUTTON PRESSED ===');
                        print('Button pressed!');
                        print('Controller text: "${_controller.text}"');
                        print('Text trimmed: "${_controller.text.trim()}"');
                        print('Is loading: ${widget.isLoading}');
                        print('Text is empty: ${_controller.text.trim().isEmpty}');
                        
                        if (widget.isLoading || _controller.text.trim().isEmpty) {
                          print('Button is disabled - loading or empty text');
                          return;
                        }
                        
                        print('Calling _handleSend...');
                        _handleSend();
                      },
                      icon: widget.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey[600]!,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
              
              // Disclaimer
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'AI can make mistakes. Cross-check important information.',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 