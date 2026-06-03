import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final QuoteService quoteService = QuoteService();
  final FirestoreService firestoreService = FirestoreService();

  QuoteModel? currentQuote;
  bool isLoading = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadQuote();
  }
  void copyQuote() {

    if (currentQuote == null) return;

    Clipboard.setData(
      ClipboardData(
        text:
        '"${currentQuote!.quote}" - ${currentQuote!.author}',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Quote Copied 📋"),
      ),
    );
  }

  Future<void> loadQuote() async {

    setState(() {
      isLoading = true;
    });

    final quote =
    await quoteService.getRandomQuote();

    setState(() {
      currentQuote = quote;
      isLoading = false;
      isFavorite = false;
    });
  }

  Future<void> addToFavorites() async {

    if (currentQuote == null) return;

    if (isFavorite) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Already added to Favorites ❤️",
          ),
        ),
      );

      return;
    }

    try {

      await firestoreService.addFavorite(
        text: currentQuote!.quote,
        author: currentQuote!.author,
      );

      setState(() {
        isFavorite = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Added to Favorites ❤️",
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/logo.png",
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Random Quote Genrator",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "Daily Inspiration",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: isLoading
                      ? const SizedBox(
                    height: 220,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                      : Column(
                    children: [

                      const Icon(
                        Icons.format_quote,
                        color: Colors.white,
                        size: 40,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        currentQuote?.quote ?? "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "- ${currentQuote?.author ?? ""}",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Chip(
                        label: Text(
                          currentQuote?.category ?? "",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [

                    GestureDetector(
                      onTap: addToFavorites,
                      child: AnimatedScale(
                        duration:
                        const Duration(milliseconds: 300),
                        scale: isFavorite ? 1.3 : 1.0,
                        child: Icon(
                          Icons.favorite,
                          size: 36,
                          color: isFavorite
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: copyQuote,
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: loadQuote,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "NEW QUOTE",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}