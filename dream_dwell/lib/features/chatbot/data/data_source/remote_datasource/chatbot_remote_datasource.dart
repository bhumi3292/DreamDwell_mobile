import 'package:dio/dio.dart';
import 'package:dream_dwell/features/chatbot/data/data_source/chatbot_data_source.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_message_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_query_entity.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';
import 'package:dream_dwell/features/chatbot/data/model/chat_message_model.dart';
import 'package:dream_dwell/features/chatbot/data/model/chat_query_model.dart';

class ChatbotRemoteDatasource implements ChatbotDataSource {
  final Dio _dio;

  ChatbotRemoteDatasource({required Dio dio}) : _dio = dio;

  @override
  Future<ChatMessageEntity> sendChatQuery(ChatQueryEntity query) async {
    try {
      print('=== CHATBOT API CALL ===');
      print('Sending chat query to: ${ApiEndpoints.sendChatQuery}');
      print('Query: "${query.query}"');
      print('History length: ${query.history.length}');
      
      final queryModel = ChatQueryModel.fromEntity(query);
      final requestData = queryModel.toJson();
      
      print('Chat query data: $requestData');
      print('Request data type: ${requestData.runtimeType}');
      
      final response = await _dio.post(
        ApiEndpoints.sendChatQuery,
        data: requestData,
      );

      print('Chatbot API Response: ${response.data}');
      print('Response status: ${response.statusCode}');
      print('Response type: ${response.data.runtimeType}');
      print('=== END CHATBOT API CALL ===');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('Processing response data: $responseData');
        
        if (responseData is Map<String, dynamic> && responseData['success'] == true) {
          final reply = responseData['data']?['reply'] ?? responseData['reply'] ?? '';
          print('Extracted reply: "$reply"');
          
          if (reply.isNotEmpty) {
            final message = ChatMessageModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: reply,
              sender: 'bot',
              timestamp: DateTime.now(),
            ).toEntity();
            print('Created message entity: "${message.text}"');
            return message;
          } else {
            print('Empty reply received');
            throw Exception('Empty response from chatbot');
          }
        } else {
          print('Invalid response format: $responseData');
          throw Exception('Invalid response format: ${response.data}');
        }
      } else {
        print('Non-200 status code: ${response.statusCode}');
        throw Exception('Failed to send chat query: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print('DioException in sendChatQuery: ${e.response?.data ?? e.message}');
      print('DioException type: ${e.type}');
      print('DioException status: ${e.response?.statusCode}');
      print('DioException message: ${e.message}');
      
      String errorMessage = 'Failed to send chat query';
      
      if (e.response?.data != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        errorMessage = data['message'] ?? errorMessage;
      }
      
      print('Throwing exception: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      print('Exception in sendChatQuery: $e');
      print('Exception type: ${e.runtimeType}');
      throw Exception('Failed to send chat query: $e');
    }
  }

  @override
  Future<List<ChatMessageEntity>> getChatHistory() async {
    // For now, return empty list as we're not implementing chat history persistence
    // This can be extended later with local storage or API calls
    return [];
  }

  @override
  Future<void> clearChatHistory() async {
    // For now, do nothing as we're not implementing chat history persistence
    // This can be extended later with local storage or API calls
  }
} 