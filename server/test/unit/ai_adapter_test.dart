import 'dart:convert';

import 'package:owncoffer_server/src/ai/ai_adapter.dart';
import 'package:owncoffer_server/src/ai/ai_context.dart';
import 'package:test/test.dart';

void main() {
  group('OpenAI-compatible (ChatGPT, Gemini, Ollama…)', () {
    test('a function without parameters has no schema (Gemini refuses an '
        'empty object), the others keep theirs', () {
      final wire = OpenAiCompatibleAdapter.wireTools(AiContext.tools);
      Map<String, Object?> f(String name) => wire
          .map((t) => t['function']! as Map<String, Object?>)
          .firstWhere((f) => f['name'] == name);
      expect(f('get_account_overview').containsKey('parameters'), isFalse);
      final tx = f('get_transactions')['parameters']! as Map;
      expect(tx['properties'], isNotEmpty);
      expect(tx.containsKey('required'), isFalse, reason: 'empty list');
      expect(
        (f('propose_category')['parameters']! as Map)['required'],
        contains('transaction_id'),
      );
      expect(
        (AiContext.tools.first['function']! as Map)['parameters'],
        isNotNull,
        reason: 'the definitions themselves are left as they are (MCP)',
      );
    });

    test('what only another adapter needs is not sent', () {
      final wire = OpenAiCompatibleAdapter.wireMessages([
        {
          'role': 'assistant',
          'content': 'x',
          '_anthropic_content': [1],
        },
      ]);
      expect(wire.single.keys, ['role', 'content']);
    });

    test('model ids as users pick them', () {
      expect(
        chatModelIds([
          'models/gemini-2.5-flash',
          'models/text-embedding-004',
          'models/imagen-3.0-generate-002',
          'gpt-4o',
          'whisper-1',
          'gpt-4o',
        ]),
        ['gemini-2.5-flash', 'gpt-4o'],
      );
    });

    test('the usual models: no preview, experiment, snapshot or special '
        'variant; newest first; a few only', () {
      expect(
        commonModelIds([
          'models/gemini-2.5-flash',
          'models/gemini-3.8-flash',
          'models/gemini-3.8-pro',
          'models/gemini-3.8-flash-preview-09-2026',
          'models/gemini-2.0-flash-exp',
          'models/gemini-2.0-flash-001',
          'models/gemini-3.8-flash-live',
          'models/gemma-3-27b-it',
          'models/text-embedding-004',
        ]),
        ['gemini-3.8-flash', 'gemini-3.8-pro', 'gemini-2.5-flash'],
      );
      expect(
        commonModelIds([
          'gpt-4o',
          'gpt-5-mini',
          'gpt-5-2026-08-07',
          'gpt-4o-realtime-preview',
          'gpt-5',
        ]),
        ['gpt-5', 'gpt-5-mini', 'gpt-4o'],
      );
      expect(
        commonModelIds(['claude-sonnet-5-5', 'claude-3-5-sonnet-20241022']),
        ['claude-sonnet-5-5'],
      );
      expect(
        commonModelIds([for (var i = 0; i < 30; i++) 'gpt-$i']).length,
        12,
      );
    });

    test("the provider's own error message, short", () {
      expect(
        providerError(
          jsonEncode({
            'error': {
              'message': 'API key not valid. Please pass a valid API key.',
            },
          }),
        ),
        'API key not valid. Please pass a valid API key.',
      );
      expect(
        providerError(
          jsonEncode([
            {
              'error': {'message': 'quota'},
            },
          ]),
        ),
        'quota',
      );
      expect(providerError('<html>'), isNull);
      expect(
        providerError(
          jsonEncode({
            'error': {'message': 'x' * 500},
          }),
        )!.length,
        201,
      );
    });
  });

  group('Claude (Anthropic Messages API)', () {
    test('system apart, tool calls and results as blocks, consecutive '
        'results in one user turn, images as base64 blocks', () {
      final body = AnthropicAdapter.request(
        'claude-opus-5-5',
        [
          {'role': 'system', 'content': 'Rules.'},
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': 'Lis ce tableau'},
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/png;base64,aGVsbG8='},
              },
            ],
          },
          {
            'role': 'assistant',
            'content': null,
            'tool_calls': [
              {
                'id': 't1',
                'type': 'function',
                'function': {'name': 'get_categories', 'arguments': '{}'},
              },
              {
                'id': 't2',
                'type': 'function',
                'function': {
                  'name': 'get_transactions',
                  'arguments': '{"limit": 5}',
                },
              },
            ],
          },
          {'role': 'tool', 'tool_call_id': 't1', 'content': '{"a":1}'},
          {'role': 'tool', 'tool_call_id': 't2', 'content': '{"b":2}'},
        ],
        AiContext.tools,
      );
      expect(body['model'], 'claude-opus-5-5');
      expect(body['system'], 'Rules.');
      expect(body.containsKey('temperature'), isFalse);
      final messages = body['messages']! as List;
      expect(
        [for (final m in messages) m['role']],
        [
          'user',
          'assistant',
          'user',
        ],
      );
      final image = (messages[0]['content'] as List)[1] as Map;
      expect(image['type'], 'image');
      expect(image['source'], {
        'type': 'base64',
        'media_type': 'image/png',
        'data': 'aGVsbG8=',
      });
      final calls = messages[1]['content'] as List;
      expect(calls[1], {
        'type': 'tool_use',
        'id': 't2',
        'name': 'get_transactions',
        'input': {'limit': 5},
      });
      final results = messages[2]['content'] as List;
      expect([for (final r in results) r['tool_use_id']], ['t1', 't2']);
      final tools = body['tools']! as List;
      expect(tools.first['input_schema'], isA<Map>());
      expect(tools.first.containsKey('function'), isFalse);
    });

    test("Claude's answer becomes an OpenAI message, its own blocks kept "
        'and sent back unchanged on the next round', () {
      final blocks = [
        {'type': 'thinking', 'thinking': '', 'signature': 'sig'},
        {'type': 'text', 'text': 'Je regarde.'},
        {
          'type': 'tool_use',
          'id': 'toolu_1',
          'name': 'get_categories',
          'input': <String, Object?>{},
        },
      ];
      final answer = AnthropicAdapter.answer({
        'content': blocks,
        'stop_reason': 'tool_use',
      });
      expect(answer['content'], 'Je regarde.');
      final call = (answer['tool_calls']! as List).single as Map;
      expect(call['id'], 'toolu_1');
      expect((call['function'] as Map)['name'], 'get_categories');
      final next = AnthropicAdapter.request('claude-opus-5-5', [
        {'role': 'user', 'content': 'Q'},
        {...answer},
        {'role': 'tool', 'tool_call_id': 'toolu_1', 'content': '{}'},
      ], null);
      expect((next['messages']! as List)[1]['content'], blocks);
    });
  });
}
