import 'package:get/get.dart';
import 'package:unchi_cricket/models/match_model.dart';
import 'package:unchi_cricket/services/firestore_service.dart';

class MatchController extends GetxController {
  final FirestoreService _service = FirestoreService();

  // Observable lists - jeta automatically UI update korbe
  final RxList<MatchModel> liveMatches = <MatchModel>[].obs;
  final RxList<MatchModel> upcomingMatches = <MatchModel>[].obs;

  // Loading states
  final RxBool isLoadingLive = true.obs;
  final RxBool isLoadingUpcoming = true.obs;

  // Error messages
  final RxString liveError = ''.obs;
  final RxString upcomingError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('🚀 MatchController initialized!');
    fetchLiveMatches();
    fetchUpcomingMatches();
  }

  // Live matches load kora
  void fetchLiveMatches() {
    print('📡 Fetching LIVE matches...');
    isLoadingLive.value = true;
    liveError.value = '';

    _service.getLiveMatches().listen(
      (matches) {
        print('✅ LIVE MATCHES RECEIVED: ${matches.length} matches');
        for (var match in matches) {
          print(
            '   - ${match.team1} vs ${match.team2} (isLive: ${match.isLive})',
          );
        }
        liveMatches.value = matches;
        isLoadingLive.value = false;
      },
      onError: (error) {
        print('❌ ERROR loading LIVE matches: $error');
        liveError.value = 'Failed to load live matches';
        isLoadingLive.value = false;
      },
    );
  }

  // Upcoming matches load kora
  void fetchUpcomingMatches() {
    print('📡 Fetching UPCOMING matches...');
    isLoadingUpcoming.value = true;
    upcomingError.value = '';

    _service.getUpcomingMatches().listen(
      (matches) {
        print('✅ UPCOMING MATCHES RECEIVED: ${matches.length} matches');
        for (var match in matches) {
          print(
            '   - ${match.team1} vs ${match.team2} (Date: ${match.matchDate})',
          );
        }
        upcomingMatches.value = matches;
        isLoadingUpcoming.value = false;
      },
      onError: (error) {
        print('❌ ERROR loading UPCOMING matches: $error');
        upcomingError.value = 'Failed to load upcoming matches';
        isLoadingUpcoming.value = false;
      },
    );
  }

  // Refresh kora (Pull to refresh er jonno)
  void refreshMatches() {
    print('🔄 Refreshing all matches...');
    fetchLiveMatches();
    fetchUpcomingMatches();
  }
}
