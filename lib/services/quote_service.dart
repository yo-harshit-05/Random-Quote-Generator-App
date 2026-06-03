import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/quote_model.dart';

class QuoteService {

  Future<QuoteModel> getRandomQuote() async {

    try {

      final response = await http.get(
        Uri.parse('https://zenquotes.io/api/random'),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return QuoteModel(
          quote: data[0]['q'],
          author: data[0]['a'],
          category: "Online",
        );
      }

      throw Exception();

    } catch (_) {

      final jsonString =
      await rootBundle.loadString(
        'assets/quotes.json',
      );

      final List data =
      jsonDecode(jsonString);

      final random =
      data[Random().nextInt(data.length)];

      return QuoteModel.fromJson(random);
    }
  }

  // NEW METHOD FOR QUOTES SCREEN
  Future<List<QuoteModel>> getAllQuotes() async {

    final jsonString =
    await rootBundle.loadString(
      'assets/quotes.json',
    );

    final List data =
    jsonDecode(jsonString);

    return data
        .map(
          (quote) =>
          QuoteModel.fromJson(quote),
    )
        .toList();
  }
}