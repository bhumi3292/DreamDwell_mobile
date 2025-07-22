# DreamDwell Chatbot Feature

This is a floating chatbot feature for the DreamDwell Flutter app, similar to the MERN web version. The chatbot provides an AI assistant interface that can be integrated into any page of the app.

## Features

- **Floating Action Button (FAB)**: A circular button that appears in the bottom-right corner
- **Expandable Chat Interface**: Click the FAB to open a full chat interface
- **Minimize/Maximize**: Toggle between minimized and full chat views
- **Real-time Messaging**: Send messages and receive AI responses
- **Message History**: Maintains conversation context
- **Loading States**: Shows typing indicators and loading states
- **Responsive Design**: Adapts to different screen sizes
- **Clean Architecture**: Follows the same architecture pattern as other features

## Architecture

The chatbot feature follows the Clean Architecture pattern with the following structure:

```
features/chatbot/
├── data/
│   ├── data_source/
│   │   └── remote_datasource/
│   │       └── chatbot_remote_datasource.dart
│   ├── model/
│   │   ├── chat_message_model.dart
│   │   └── chat_query_model.dart
│   └── repository/
│       └── chatbot_repository_impl.dart
├── domain/
│   ├── entity/
│   │   ├── chat_message_entity.dart
│   │   └── chat_query_entity.dart
│   ├── repository/
│   │   └── chatbot_repository.dart
│   └── use_case/
│       └── send_chat_query_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── chatbot_bloc.dart
    │   ├── chatbot_event.dart
    │   └── chatbot_state.dart
    ├── widget/
    │   ├── chatbot_widget.dart
    │   ├── chatbot_fab.dart
    │   ├── chatbot_wrapper.dart
    │   ├── chat_message_widget.dart
    │   └── chat_input_widget.dart
    ├── page/
    │   └── chatbot_page.dart
    └── example/
        └── chatbot_integration_example.dart
```

## API Integration

The chatbot integrates with the backend API endpoint:
- **Endpoint**: `POST /api/chatbot/query`
- **Request Format**: 
  ```json
  {
    "query": "user message",
    "history": [
      {
        "role": "user|model",
        "text": "message content"
      }
    ]
  }
  ```
- **Response Format**:
  ```json
  {
    "success": true,
    "data": {
      "reply": "bot response"
    }
  }
  ```

## Usage

### Basic Integration

To add the chatbot to any page, wrap your widget with `ChatbotWrapper`:

```dart
import 'package:dream_dwell/features/chatbot/presentation/widget/chatbot_wrapper.dart';

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

### Conditional Chatbot

You can conditionally show/hide the chatbot:

```dart
ChatbotWrapper(
  showChatbot: someCondition, // true/false
  child: YourWidget(),
)
```

### Integration with HomeView

To integrate with the existing HomeView, see the example in `chatbot_integration_example.dart`:

```dart
class HomeViewWithChatbot extends StatefulWidget {
  // ... existing HomeView code ...
  
  @override
  Widget build(BuildContext context) {
    return ChatbotWrapper(
      child: Scaffold(
        appBar: const HeaderNav(),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          // ... existing navigation bar ...
        ),
      ),
    );
  }
}
```

## Dependencies

The chatbot feature requires the following dependencies (already included in the project):

- `flutter_bloc`: For state management
- `dio`: For HTTP requests
- `equatable`: For value equality
- `get_it`: For dependency injection

## State Management

The chatbot uses BLoC pattern for state management:

- **Events**: `SendChatMessage`, `InitializeChatbot`, `ToggleChatbotVisibility`, etc.
- **States**: `ChatbotInitial`, `ChatbotLoading`, `ChatbotLoaded`, `ChatbotError`
- **Bloc**: `ChatbotBloc` handles all business logic

## Customization

### Styling

The chatbot uses the DreamDwell theme colors:
- Primary: `#002B5B`
- User messages: `#CCE0FF`
- Bot messages: White with shadow

### Messages

You can customize the initial bot message by modifying the `InitializeChatbot` event in `chatbot_bloc.dart`.

### API Configuration

The API endpoint is configured in `api_endpoints.dart`:
```dart
static const String sendChatQuery = "${baseUrl}chatbot/query";
```

## Error Handling

The chatbot includes comprehensive error handling:
- Network errors are caught and displayed to the user
- Empty responses are handled gracefully
- Loading states prevent multiple simultaneous requests

## Testing

To test the chatbot:
1. Ensure the backend API is running
2. Navigate to a page with the chatbot integrated
3. Click the floating action button
4. Send a message and verify the response

## Future Enhancements

Potential improvements:
- Message persistence using local storage
- Typing indicators
- Message timestamps
- File/image sharing
- Voice messages
- Chat history export
- Custom bot personalities

## Troubleshooting

### Common Issues

1. **Chatbot not appearing**: Ensure `ChatbotWrapper` is properly wrapping your widget
2. **API errors**: Check that the backend chatbot endpoint is working
3. **Dependency injection errors**: Verify that `SendChatQueryUseCase` is registered in `service_locator.dart`

### Debug Mode

Enable debug prints by checking the console output for:
- `=== CHATBOT API CALL ===`
- `=== END CHATBOT API CALL ===`

These will help identify API communication issues. 