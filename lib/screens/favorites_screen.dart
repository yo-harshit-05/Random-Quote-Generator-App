import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/firestore_service.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final FirestoreService firestoreService =
  FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [

              const SizedBox(height: 20),

              Text(
                "Favorite Quotes ❤️",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                  firestoreService.getFavorites(),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "No Favorites Yet",
                          style:
                          GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    final favorites =
                        snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: favorites.length,
                      padding:
                      const EdgeInsets.all(16),
                      itemBuilder:
                          (context, index) {

                        final data =
                        favorites[index].data()
                        as Map<String,
                            dynamic>;

                        return Container(
                          margin:
                          const EdgeInsets.only(
                              bottom: 15),

                          padding:
                          const EdgeInsets.all(
                              18),

                          decoration:
                          BoxDecoration(
                            color: Colors.white
                                .withOpacity(
                                0.15),
                            borderRadius:
                            BorderRadius
                                .circular(20),
                          ),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [

                              Text(
                                data['text'] ??
                                    '',
                                style:
                                GoogleFonts
                                    .poppins(
                                  color:
                                  Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(
                                "- ${data['author']}",
                                style:
                                GoogleFonts
                                    .poppins(
                                  color: Colors
                                      .white70,
                                ),
                              ),

                              const SizedBox(
                                  height: 10),

                              Align(
                                alignment:
                                Alignment
                                    .centerRight,
                                child:
                                IconButton(
                                  onPressed:
                                      () async {

                                    await firestoreService
                                        .removeFavorite(
                                      favorites[
                                      index]
                                          .id,
                                    );

                                    ScaffoldMessenger.of(
                                        context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                        Text(
                                          "Removed from Favorites",
                                        ),
                                      ),
                                    );
                                  },
                                  icon:
                                  const Icon(
                                    Icons.delete,
                                    color:
                                    Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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