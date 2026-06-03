import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService firestoreService = FirestoreService();

  void shareApp() {
    SharePlus.instance.share(
      ShareParams(
        text: '''
🌟 Random Quote Generator

Get daily inspirational quotes and save your favorites!

Built with Flutter ❤️
''',
      ),
    );
  }

  Future<void> showFeedbackDialog() async {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Send Feedback"),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Write your feedback...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) {
                  return;
                }

                final user =
                    FirebaseAuth.instance.currentUser;

                await firestoreService.submitFeedback(
                  feedback: controller.text.trim(),
                  email: user?.email ?? "",
                  uid: user?.uid ?? "",
                );

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Thank you for your feedback ❤️",
                    ),
                  ),
                );
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        width: double.infinity,
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
          child: SingleChildScrollView(
            child:Column(
            children: [
              const SizedBox(height: 40),

              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: Text(
                  (user?.displayName?.isNotEmpty ?? false)
                      ? user!.displayName![0].toUpperCase()
                      : "U",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A11CB),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                user?.displayName ?? "User",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                user?.email ?? "",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      title:
                      const Text("Favorite Quotes"),
                      subtitle: const Text(
                        "View your saved quotes",
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FavoritesScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.feedback,
                        color: Colors.orange,
                      ),
                      title: const Text("Feedback"),
                      subtitle: const Text(
                        "Help us improve the app",
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      onTap: showFeedbackDialog,
                    ),

                    const Divider(),


                    ListTile(
                      leading: const Icon(
                        Icons.share,
                        color: Colors.green,
                      ),
                      title: const Text("Share App"),
                      subtitle: const Text(
                        "Share with friends",
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      onTap: shareApp,
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.info,
                        color: Colors.blue,
                      ),
                      title:
                      const Text("App Version"),
                      subtitle:
                      const Text("1.0.0"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                      const Color(0xFF6A11CB),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .signOut();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}