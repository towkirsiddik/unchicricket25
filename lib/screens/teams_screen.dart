import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:unchi_cricket/utils/colors.dart';
import 'package:unchi_cricket/controllers/team_controller.dart';
import 'package:unchi_cricket/controllers/player_controller.dart';
import 'package:unchi_cricket/widgets/loading_widget.dart';
import 'package:unchi_cricket/widgets/error_widget.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TeamController teamController = Get.put(TeamController());
    final PlayerController playerController = Get.put(PlayerController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teams & Players',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          teamController.refreshTeams();
          playerController.refreshPlayers();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// ================= TEAMS GRID =================
              Obx(() {
                if (teamController.isLoading.value) {
                  return const SizedBox(
                    height: 300,
                    child: LoadingWidget(message: 'Loading teams...'),
                  );
                }

                if (teamController.error.value.isNotEmpty) {
                  return SizedBox(
                    height: 300,
                    child: CustomErrorWidget(
                      message: teamController.error.value,
                      onRetry: teamController.fetchTeams,
                    ),
                  );
                }

                if (teamController.teams.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: EmptyStateWidget(
                      message: 'No teams available',
                      icon: Icons.groups_outlined,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.78, // SAFE VALUE
                        ),
                    itemCount: teamController.teams.length,
                    itemBuilder: (context, index) {
                      final team = teamController.teams[index];
                      return _buildTeamCard(
                        team.name,
                        'Captain: ${team.captain}',
                        _getColorFromHex(team.colorHex),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 32),

              /// ================= TOP PLAYERS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOP PLAYERS',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'VIEW ALL',
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Obx(() {
                if (playerController.isLoading.value) {
                  return const SizedBox(
                    height: 250,
                    child: LoadingWidget(message: 'Loading players...'),
                  );
                }

                if (playerController.error.value.isNotEmpty) {
                  return SizedBox(
                    height: 250,
                    child: CustomErrorWidget(
                      message: playerController.error.value,
                      onRetry: playerController.fetchTopPlayers,
                    ),
                  );
                }

                if (playerController.topPlayers.isEmpty) {
                  return const SizedBox(
                    height: 250,
                    child: EmptyStateWidget(
                      message: 'No players data available',
                      icon: Icons.person_outline,
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: playerController.topPlayers.take(5).map((player) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildPlayerProfileCard(
                          name: player.name,
                          role: player.role,
                          team: player.team,
                          image: player.imageUrl,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ================= COLOR =================

  Color _getColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) hexColor = 'FF$hexColor';
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  // ================= TEAM CARD (FIXED) =================

  Widget _buildTeamCard(String teamName, String captain, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.25),
                            color.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color: color.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        teamName.substring(0, 2).toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      teamName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      captain,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.withOpacity(0.12),
                      foregroundColor: color,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'VIEW TEAM',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= PLAYER CARD =================

  Widget _buildPlayerProfileCard({
    required String name,
    required String role,
    required String team,
    required String image,
  }) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary.withOpacity(0.6),
                ],
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 38,
                backgroundImage: CachedNetworkImageProvider(image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$role • $team',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
