import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const VIPConciergeApp());
}

// Design System Colors
class AppColors {
  static const Color onyxBlack = Color(0xFF030303);
  static const Color charcoal = Color(0xFF141414);
  static const Color champagne = Color(0xFFF2ECE4);
  static const Color warmGrey = Color(0xFF999999);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color subtleBorder = Color(0x33D4AF37);
}

class VIPConciergeApp extends StatelessWidget {
  const VIPConciergeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIP Concierge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.onyxBlack,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.playfairDisplay(
              color: AppColors.champagne,
              fontSize: 36,
              fontWeight: FontWeight.w400),
          headlineMedium: GoogleFonts.manrope(
              color: AppColors.warmGrey,
              fontSize: 12,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600),
          bodyLarge: GoogleFonts.manrope(
              color: AppColors.champagne,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          bodyMedium: GoogleFonts.manrope(
              color: AppColors.warmGrey,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _orbController;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _orbController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _orbController.repeat(reverse: true);
      } else {
        _orbController.stop();
        _orbController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background blur or glow
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.goldAccent.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good evening, Sir.',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'How may I assist you today?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      children: const [
                        ActionCard(title: 'Charter\nFlight', icon: Icons.flight_takeoff),
                        ActionCard(title: 'Portfolio\nReview', icon: Icons.insights),
                        ActionCard(title: 'Send\nGift', icon: Icons.card_giftcard),
                        ActionCard(title: 'Dinner\nReservations', icon: Icons.restaurant),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                    child: Text(
                      'RECENT ACTIVITY',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const ActivityItem(
                        text: 'Confirmed table at Le Bernardin for 8:00 PM.',
                        time: '2 hrs ago',
                        icon: Icons.check_circle_outline,
                      ),
                      const ActivityItem(
                        text: 'Sent flowers to Mrs. Adeoye in London.',
                        time: '5 hrs ago',
                        icon: Icons.local_florist,
                      ),
                      const ActivityItem(
                        text: 'Quarterly portfolio summary generated.',
                        time: 'Yesterday',
                        icon: Icons.file_present,
                      ),
                      const SizedBox(height: 120), // Padding for FAB
                    ],
                  ),
                ),
              ],
            ),
            // Floating Orb
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedBuilder(
                    animation: _orbController,
                    builder: (context, child) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening ? AppColors.charcoal : AppColors.onyxBlack,
                          border: Border.all(
                            color: AppColors.goldAccent.withOpacity(_isListening ? 0.8 : 0.4),
                            width: 1,
                          ),
                          boxShadow: _isListening
                              ? [
                                  BoxShadow(
                                    color: AppColors.goldAccent.withOpacity(0.2 * _orbController.value),
                                    blurRadius: 20 * _orbController.value,
                                    spreadRadius: 10 * _orbController.value,
                                  )
                                ]
                              : [],
                        ),
                        child: Icon(
                          _isListening ? Icons.graphic_eq : Icons.mic_none,
                          color: AppColors.goldAccent,
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const ActionCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.goldAccent, size: 28),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String text;
  final String time;
  final IconData icon;

  const ActivityItem({
    super.key,
    required this.text,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.subtleBorder),
            ),
            child: Icon(icon, color: AppColors.goldAccent, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
