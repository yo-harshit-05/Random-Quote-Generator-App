import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  List<QuoteModel> allQuotes = [];
  List<QuoteModel> filteredQuotes = [];

  final TextEditingController searchController =
  TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuotes();
  }

  Future<void> loadQuotes() async {
    try {
      final quotes =
      await QuoteService().getAllQuotes();

      setState(() {
        allQuotes = quotes;
        filteredQuotes = quotes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchQuotes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredQuotes = allQuotes;
      } else {
        filteredQuotes = allQuotes.where((quote) {
          return quote.quote
              .toLowerCase()
              .contains(query.toLowerCase()) ||
              quote.author
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              quote.category
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildQuoteCard(QuoteModel quote) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote,
            size: 40,
            color: Color(0xFF6A11CB),
          ),

          const SizedBox(height: 10),

          Text(
            quote.quote,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 15),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "- ${quote.author}",
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                "Quotes Library",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: searchQuotes,
                  decoration: InputDecoration(
                    hintText:
                    "Search quote, author or category...",
                    prefixIcon:
                    const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                          15),
                      borderSide:
                      BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: isLoading
                    ? const Center(
                  child:
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : filteredQuotes.isEmpty
                    ? const Center(
                  child: Text(
                    "No quotes found",
                    style: TextStyle(
                      color:
                      Colors.white,
                      fontSize: 18,
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 16,
                  ),
                  itemCount:
                  filteredQuotes
                      .length,
                  itemBuilder:
                      (context,
                      index) {
                    return buildQuoteCard(
                      filteredQuotes[
                      index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}