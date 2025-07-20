import 'package:flutter_test/flutter_test.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_message_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_query_entity.dart';
import 'package:dream_dwell/features/chatbot/data/model/chat_message_model.dart';
import 'package:dream_dwell/features/chatbot/data/model/chat_query_model.dart';

void main() {
  group('Chatbot Entity Tests', () {
    test('should create ChatMessageEntity with correct properties', () {
      final message = ChatMessageEntity(
        id: '1',
        text: 'Hello',
        sender: 'user',
        timestamp: DateTime(2024, 1, 1),
      );

      expect(message.id, '1');
      expect(message.text, 'Hello');
      expect(message.sender, 'user');
      expect(message.timestamp, DateTime(2024, 1, 1));
    });

    test('should create ChatQueryEntity with correct properties', () {
      final history = [
        ChatHistoryEntity(role: 'user', text: 'Hello'),
        ChatHistoryEntity(role: 'model', text: 'Hi there!'),
      ];

      final query = ChatQueryEntity(
        query: 'How are you?',
        history: history,
      );

      expect(query.query, 'How are you?');
      expect(query.history.length, 2);
      expect(query.history[0].role, 'user');
      expect(query.history[1].role, 'model');
    });
  });

  group('Chatbot Model Tests', () {
    test('should create ChatMessageModel from JSON', () {
      final json = {
        'id': '1',
        'text': 'Hello',
        'sender': 'user',
        'timestamp': '2024-01-01T00:00:00.000Z',
      };

      final model = ChatMessageModel.fromJson(json);

      expect(model.id, '1');
      expect(model.text, 'Hello');
      expect(model.sender, 'user');
      expect(model.timestamp?.year, 2024);
    });

    test('should convert ChatMessageModel to JSON', () {
      final model = ChatMessageModel(
        id: '1',
        text: 'Hello',
        sender: 'user',
        timestamp: DateTime(2024, 1, 1),
      );

      final json = model.toJson();

      expect(json['id'], '1');
      expect(json['text'], 'Hello');
      expect(json['sender'], 'user');
      expect(json['timestamp'], '2024-01-01T00:00:00.000Z');
    });

    test('should create ChatQueryModel from entity', () {
      final history = [
        ChatHistoryEntity(role: 'user', text: 'Hello'),
      ];

      final entity = ChatQueryEntity(
        query: 'How are you?',
        history: history,
      );

      final model = ChatQueryModel.fromEntity(entity);

      expect(model.query, 'How are you?');
      expect(model.history.length, 1);
      expect(model.history[0].role, 'user');
    });
  });

  group('ChatHistoryModel Tests', () {
    test('should create ChatHistoryModel from JSON', () {
      final json = {
        'role': 'user',
        'text': 'Hello',
      };

      final model = ChatHistoryModel.fromJson(json);

      expect(model.role, 'user');
      expect(model.text, 'Hello');
    });

    test('should convert ChatHistoryModel to JSON', () {
      final model = ChatHistoryModel(
        role: 'model',
        text: 'Hi there!',
      );

      final json = model.toJson();

      expect(json['role'], 'model');
      expect(json['text'], 'Hi there!');
    });
  });
} 