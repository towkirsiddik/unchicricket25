import 'package:get/get.dart';
import 'package:unchi_cricket/models/tournament_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Active tournament
  final Rx<TournamentModel?> activeTournament = Rx<TournamentModel?>(null);

  // Loading state
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveTournament();
  }

  // Active tournament load kora
  void fetchActiveTournament() {
    isLoading.value = true;

    _db
        .collection('tournaments')
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.docs.isNotEmpty) {
              activeTournament.value = TournamentModel.fromFirestore(
                snapshot.docs.first,
              );
            } else {
              activeTournament.value = null;
            }
            isLoading.value = false;
          },
          onError: (err) {
            isLoading.value = false;
            print('Error loading tournament: $err');
          },
        );
  }
}
