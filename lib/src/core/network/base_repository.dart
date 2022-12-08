import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

typedef ClientReturn<T> = Future<T> Function();

class RequestException implements Exception {}

abstract class BaseRepository {
  static const _baseUrl = 'itunes.apple.com';

  final _client = http.Client();

  BaseRepository();

  Future<T> clientExecutor<T, R>({
    required ClientReturn<R> execute,
    required T Function(R data) transform,
  }) async {
    try {
      final response = await execute();
      return transform(response);
    } catch (error) {
      throw RequestException();
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final request = Uri.https(
        _baseUrl,
        path,
        query,
      );
      final response = await _client.get(request);

      if (response.statusCode != 200) {
        throw RequestException();
      }
      return json.decode(response.body);
    } catch (e) {
      debugPrint('Exception: $e');
      rethrow;
    }
  }
}
