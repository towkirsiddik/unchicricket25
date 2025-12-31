import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unchi_cricket/utils/colors.dart';

class SponsorsScreen extends StatelessWidget {
  const SponsorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Our Sponsors',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 🔹 Top banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.85),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Amader Tournament er Committee",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// 🔹 Title sponsor heading
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'TITLE SPONSOR',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 Title sponsor card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: _buildSponsorCard(
                  name: 'LocalMart Superstore',
                  type: 'Official Title Sponsor',
                  logoUrl:
                      'https://cdn.logojoy.com/wp-content/uploads/20230621140450/supermarket-logo.png',
                  isTitle: true,
                ),
              ),

              const SizedBox(height: 36),

              /// 🔹 Platinum heading
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'PLATINUM SPONSORS',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 Platinum grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildPlatinumSponsorsGrid(screenWidth),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ================= GRID =================

  Widget _buildPlatinumSponsorsGrid(double screenWidth) {
    final sponsors = [
      {
        'name': 'City Bank',
        'type': 'Banking Partner',
        'logo':
            'https://cdn.logojoy.com/wp-content/uploads/20230621140450/bank-logo.png',
      },
      {
        'name': 'SportsGear Pro',
        'type': 'Equipment Partner',
        'logo':
            'https://cdn.logojoy.com/wp-content/uploads/20230621140450/sports-logo.png',
      },
      {
        'name': 'Refresh Drinks',
        'type': 'Beverage Partner',
        'logo':
            'https://cdn.logojoy.com/wp-content/uploads/20230621140450/drink-logo.png',
      },
      {
        'name': 'FitLife Gym',
        'type': 'Fitness Partner',
        'logo':
            'https://cdn.logojoy.com/wp-content/uploads/20230621140450/gym-logo.png',
      },
    ];

    int crossAxisCount = 2;
    if (screenWidth > 800) {
      crossAxisCount = 4;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
    }

    /// 🔥 FIX IS HERE
    /// Mobile → height বেশি
    /// Desktop → balanced
    final aspectRatio = screenWidth < 380 ? 0.70 : 0.85;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sponsors.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        final item = sponsors[index];
        return _buildSponsorCard(
          name: item['name']!,
          type: item['type']!,
          logoUrl: item['logo']!,
        );
      },
    );
  }

  // ================= CARD =================

  Widget _buildSponsorCard({
    required String name,
    required String type,
    required String logoUrl,
    bool isTitle = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isTitle
            ? Border.all(color: Colors.amber.shade600, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Logo
          Container(
            width: isTitle ? 100 : 78,
            height: isTitle ? 100 : 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              image: DecorationImage(
                image: NetworkImage(logoUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// Name
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: isTitle ? 18 : 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          /// Type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isTitle
                  ? Colors.amber.withOpacity(0.12)
                  : AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              type,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isTitle ? Colors.amber : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
