import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:unchi_cricket/utils/colors.dart';
import 'package:unchi_cricket/controllers/team_controller.dart';
import 'package:unchi_cricket/controllers/match_controller.dart';
import 'package:unchi_cricket/widgets/loading_widget.dart';
import 'package:unchi_cricket/widgets/error_widget.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tournament',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'POINTS TABLE'),
              Tab(text: 'SCHEDULE'),
              Tab(text: 'KNOCKOUT'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [PointsTableTab(), ScheduleTab(), KnockoutTab()],
        ),
      ),
    );
  }
}

class PointsTableTab extends StatelessWidget {
  const PointsTableTab({super.key});

  @override
  Widget build(BuildContext context) {
    final TeamController teamController = Get.put(TeamController());

    return RefreshIndicator(
      onRefresh: () async {
        teamController.refreshTeams();
      },
      child: Obx(() {
        if (teamController.isLoading.value) {
          return const LoadingWidget(message: 'Loading points table...');
        }

        if (teamController.error.value.isNotEmpty) {
          return CustomErrorWidget(
            message: teamController.error.value,
            onRetry: teamController.fetchTeams,
          );
        }

        if (teamController.teams.isEmpty) {
          return const EmptyStateWidget(
            message: 'No teams data available',
            icon: Icons.table_chart_outlined,
          );
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTableHeader(),
                      const SizedBox(height: 16),
                      ...teamController.teams.asMap().entries.map((entry) {
                        int rank = entry.key + 1;
                        var team = entry.value;
                        return _buildTeamRow(
                          rank,
                          team.name,
                          team.played,
                          team.won,
                          team.lost,
                          team.points,
                          team.nrr,
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Text(
              'TEAM',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
          _buildHeaderCell('P'),
          _buildHeaderCell('W'),
          _buildHeaderCell('L'),
          _buildHeaderCell('PTS'),
          _buildHeaderCell('NRR'),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTeamRow(
    int rank,
    String team,
    int played,
    int won,
    int lost,
    int points,
    String nrr,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rank <= 4
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: rank <= 4 ? AppColors.primary : Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              team,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          _buildTableCell('$played'),
          _buildTableCell('$won'),
          _buildTableCell('$lost'),
          _buildTableCell('$points'),
          _buildTableCell(nrr),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final MatchController matchController = Get.put(MatchController());

    return RefreshIndicator(
      onRefresh: () async {
        matchController.refreshMatches();
      },
      child: Obx(() {
        if (matchController.isLoadingUpcoming.value) {
          return const LoadingWidget(message: 'Loading schedule...');
        }

        if (matchController.upcomingError.value.isNotEmpty) {
          return CustomErrorWidget(
            message: matchController.upcomingError.value,
            onRetry: matchController.fetchUpcomingMatches,
          );
        }

        if (matchController.upcomingMatches.isEmpty) {
          return const EmptyStateWidget(
            message: 'No scheduled matches',
            icon: Icons.calendar_today_outlined,
          );
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: matchController.upcomingMatches.map((match) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildMatchFixture(
                  date: _formatDate(match.matchDate),
                  team1: match.team1,
                  team2: match.team2,
                  time: match.time,
                  venue: match.venue,
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  Widget _buildMatchFixture({
    required String date,
    required String team1,
    required String team2,
    required String time,
    required String venue,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              date,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Team 1
              Expanded(child: _buildTeamLogo(team1)),

              // VS + Time
              Column(
                children: [
                  Text(
                    'VS',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      time,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              // Team 2
              Expanded(child: _buildTeamLogo(team2)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  venue,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLogo(String teamName) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.2),
                AppColors.primary.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              teamName.substring(0, 2).toUpperCase(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          teamName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class KnockoutTab extends StatelessWidget {
  const KnockoutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'KNOCKOUT STAGE',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildKnockoutMatch(
            'Quarter Final 1',
            'Local Lions',
            'City Chargers',
            '15 Mar',
          ),
          const SizedBox(height: 16),
          _buildKnockoutMatch(
            'Quarter Final 2',
            'Village Warriors',
            'Town Titans',
            '16 Mar',
          ),
          const SizedBox(height: 16),
          _buildKnockoutMatch(
            'Quarter Final 3',
            'District Dragons',
            'State Strikers',
            '17 Mar',
          ),
          const SizedBox(height: 16),
          _buildKnockoutMatch('Quarter Final 4', 'Team A', 'Team B', '18 Mar'),
        ],
      ),
    );
  }

  Widget _buildKnockoutMatch(
    String round,
    String team1,
    String team2,
    String date,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              round,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.primary.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          team1.substring(0, 2).toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      team1,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    'VS',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      date,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondary.withOpacity(0.2),
                            AppColors.secondary.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.secondary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          team2.substring(0, 2).toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      team2,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
