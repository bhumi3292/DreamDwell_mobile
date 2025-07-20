# Quick Integration Guide

## Step 1: Add Chatbot to Your Page

Simply wrap your existing widget with `ChatbotWrapper`:

```dart
import 'package:dream_dwell/features/chatbot/presentation/widget/chatbot_wrapper.dart';

// Before
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Center(child: Text('Hello World')),
    );
  }
}

// After
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChatbotWrapper(
      child: Scaffold(
        appBar: AppBar(title: Text('My Page')),
        body: Center(child: Text('Hello World')),
      ),
    );
  }
}
```

## Step 2: Verify Dependencies

The chatbot dependencies are already registered in `service_locator.dart`. Make sure your app initializes dependencies:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies(); // This includes chatbot dependencies
  runApp(const MyApp());
}
```

## Step 3: Test the Integration

1. Run your app
2. Navigate to the page with the chatbot
3. Look for a floating action button in the bottom-right corner
4. Tap it to open the chat interface
5. Send a test message

## Step 4: Customize (Optional)

### Change Initial Message
Edit `chatbot_bloc.dart` in the `_onInitializeChatbot` method:

```dart
final initialMessage = ChatMessageEntity(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  text: 'Your custom welcome message here!',
  sender: 'bot',
  timestamp: DateTime.now(),
);
```

### Conditional Display
```dart
ChatbotWrapper(
  showChatbot: someCondition, // true/false
  child: YourWidget(),
)
```

## Troubleshooting

### Chatbot not appearing?
- Ensure `ChatbotWrapper` is wrapping your widget
- Check that dependencies are initialized
- Verify the page has enough space (not covered by other widgets)

### API errors?
- Check console for debug messages starting with `=== CHATBOT API CALL ===`
- Verify backend chatbot endpoint is working
- Check network connectivity

### Build errors?
- Run `flutter pub get` to ensure all dependencies are installed
- Check that all imports are correct

## API Requirements

Your backend needs to support:
- **Endpoint**: `POST /api/chatbot/query`
- **Request**: `{"query": "user message", "history": [...]}`
- **Response**: `{"success": true, "data": {"reply": "bot response"}}`

That's it! The chatbot should now be working on your page. 