import 'package:get/get.dart';
import 'package:unchi_cricket/models/player_model.dart';
import 'package:unchi_cricket/services/firestore_service.dart';

class PlayerController extends GetxController {
  final FirestoreService _service = FirestoreService();

  // Observable list
  final RxList<PlayerModel> topPlayers = <PlayerModel>[].obs;

  // Loading state
  final RxBool isLoading = true.obs;

  // Error message
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopPlayers();
  }

  // Top players load kora
  void fetchTopPlayers() {
    isLoading.value = true;
    error.value = '';

    _service.getTopPlayers().listen(
      (players) {
        topPlayers.value = players;
        isLoading.value = false;
      },
      onError: (err) {
        error.value = 'Failed to load players';
        isLoading.value = false;
        print('Error loading players: $err');
      },
    );
  }

  // Refresh kora
  void refreshPlayers() {
    fetchTopPlayers();
  }
}
