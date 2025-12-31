import 'package:get/get.dart';
import 'package:unchi_cricket/models/team_model.dart';
import 'package:unchi_cricket/services/firestore_service.dart';

class TeamController extends GetxController {
  final FirestoreService _service = FirestoreService();

  // Observable list
  final RxList<TeamModel> teams = <TeamModel>[].obs;

  // Loading state
  final RxBool isLoading = true.obs;

  // Error message
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeams();
  }

  // All teams load kora
  void fetchTeams() {
    isLoading.value = true;
    error.value = '';

    _service.getAllTeams().listen(
      (teamList) {
        teams.value = teamList;
        isLoading.value = false;
      },
      onError: (err) {
        error.value = 'Failed to load teams';
        isLoading.value = false;
        print('Error loading teams: $err');
      },
    );
  }

  // Refresh kora
  void refreshTeams() {
    fetchTeams();
  }
}
