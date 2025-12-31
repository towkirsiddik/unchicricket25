import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:unchi_cricket/utils/colors.dart';
import 'package:unchi_cricket/controllers/match_controller.dart';
import 'package:unchi_cricket/controllers/player_controller.dart';
import 'package:unchi_cricket/widgets/loading_widget.dart';
import 'package:unchi_cricket/widgets/error_widget.dart';
import 'package:unchi_cricket/controllers/tournament_controller.dart';
import 'package:unchi_cricket/screens/match_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MatchController matchController = Get.put(MatchController());
    final PlayerController playerController = Get.put(PlayerController());
    final TournamentController tournamentController = Get.put(
      TournamentController(),
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          matchController.refreshMatches();
          playerController.refreshPlayers();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'Local Cricket League',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 28,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month_rounded, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() {
                      if (tournamentController.isLoading.value) {
                        return const SizedBox(
                          height: 60,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (tournamentController.activeTournament.value == null) {
                        return Text(
                          "Unchiprang Cricket Tournament",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }

                      return Text(
                        tournamentController.activeTournament.value!.name,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // LIVE MATCHES HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LIVE MATCHES',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const MatchDetailScreen());
                      },
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
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 320,
                child: Obx(() {
                  if (matchController.isLoadingLive.value) {
                    return const Center(child: LoadingWidget());
                  }
                  if (matchController.liveError.value.isNotEmpty) {
                    return Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomErrorWidget(
                          message: matchController.liveError.value,
                          onRetry: matchController.fetchLiveMatches,
                        ),
                      ),
                    );
                  }
                  if (matchController.liveMatches.isEmpty) {
                    return Center(
                      child: Text(
                        'No live matches at the moment',
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: matchController.liveMatches.length,
                    itemBuilder: (context, index) {
                      var match = matchController.liveMatches[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildLiveCard(
                          team1: match.team1,
                          team2: match.team2,
                          score1: match.score1,
                          score2: match.score2,
                          over1: match.over1,
                          over2: match.over2,
                          status: match.status,
                          isLive: match.isLive,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // UPCOMING MATCHES HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'UPCOMING MATCHES',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
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
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: Obx(() {
                  if (matchController.isLoadingUpcoming.value) {
                    return const Center(child: LoadingWidget());
                  }
                  if (matchController.upcomingError.value.isNotEmpty) {
                    return Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomErrorWidget(
                          message: matchController.upcomingError.value,
                          onRetry: matchController.fetchUpcomingMatches,
                        ),
                      ),
                    );
                  }
                  if (matchController.upcomingMatches.isEmpty) {
                    return Center(
                      child: Text(
                        'No upcoming matches',
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: matchController.upcomingMatches.length,
                    itemBuilder: (context, index) {
                      var match = matchController.upcomingMatches[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildUpcomingCard(
                          team1: match.team1,
                          team2: match.team2,
                          date: _formatDate(match.matchDate),
                          time: match.time,
                          venue: match.venue,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            // TOP PLAYERS HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'TOP PLAYERS',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Obx(() {
                  if (playerController.isLoading.value) {
                    return const Center(child: LoadingWidget());
                  }
                  if (playerController.error.value.isNotEmpty) {
                    return Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomErrorWidget(
                          message: playerController.error.value,
                          onRetry: playerController.fetchTopPlayers,
                        ),
                      ),
                    );
                  }
                  if (playerController.topPlayers.isEmpty) {
                    return Center(
                      child: Text(
                        'No players data available',
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: playerController.topPlayers.take(4).length,
                    itemBuilder: (context, index) {
                      var player = playerController.topPlayers[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: _buildPlayerCard(
                          name: player.name,
                          role: player.role,
                          runs: player.runs,
                          wickets: player.wickets,
                          image: player.imageUrl,
                          rank: player.rank,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  // -------------------- Card Builders (unchanged) --------------------
  Widget _buildLiveCard({
    required String team1,
    required String team2,
    required String score1,
    required String score2,
    required String over1,
    required String over2,
    required String status,
    required bool isLive,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isLive ? Colors.red : Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isLive ? 'LIVE' : 'UPCOMING',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isLive ? Colors.red : Colors.orange,
                ),
              ),
              const Spacer(),
              Text(
                'T20',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTeamRow(
            teamName: team1,
            score: score1,
            over: over1,
            isBatting: true,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildTeamRow(
            teamName: team2,
            score: score2,
            over: over2,
            isBatting: false,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamRow({
    required String teamName,
    required String score,
    required String over,
    required bool isBatting,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            teamName.length >= 2
                ? teamName.substring(0, 2).toUpperCase()
                : teamName.toUpperCase(),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              color: color,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teamName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$score ($over)',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (isBatting)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'BAT',
              style: GoogleFonts.inter(
                color: Colors.green,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUpcomingCard({
    required String team1,
    required String team2,
    required String date,
    required String time,
    required String venue,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$team1 vs $team2',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.primary,
                size: 14,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$date • $time',
                  style: GoogleFonts.inter(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey.shade600,
                size: 12,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  venue,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required String role,
    String? runs,
    String? wickets,
    required String image,
    required int rank,
  }) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: CachedNetworkImageProvider(image),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: rank == 1 ? Colors.amber : AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    '#$rank',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              runs != null ? '$runs Runs' : '$wickets Wkts',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Date helpers (unchanged) ----------------
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final matchDay = DateTime(date.year, date.month, date.day);
    if (matchDay == today) return 'Today';
    if (matchDay == tomorrow) return 'Tomorrow';
    return '${date.day} ${_getMonthShort(date.month)}';
  }

  String _getMonthShort(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
