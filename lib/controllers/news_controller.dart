import 'package:get/get.dart';
import 'package:unchi_cricket/models/news_model.dart';
import 'package:unchi_cricket/services/firestore_service.dart';

class NewsController extends GetxController {
  final FirestoreService _service = FirestoreService();

  // Observable lists
  final RxList<NewsModel> allNews = <NewsModel>[].obs;
  final Rx<NewsModel?> featuredNews = Rx<NewsModel?>(null);

  // Loading states
  final RxBool isLoading = true.obs;
  final RxBool isFeaturedLoading = true.obs;

  // Error messages
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllNews();
    fetchFeaturedNews();
  }

  // All news load kora
  void fetchAllNews() {
    isLoading.value = true;
    error.value = '';

    _service.getAllNews().listen(
      (newsList) {
        allNews.value = newsList;
        isLoading.value = false;
      },
      onError: (err) {
        error.value = 'Failed to load news';
        isLoading.value = false;
        print('Error loading news: $err');
      },
    );
  }

  // Featured news load kora
  void fetchFeaturedNews() {
    isFeaturedLoading.value = true;

    _service.getFeaturedNews().listen(
      (news) {
        featuredNews.value = news;
        isFeaturedLoading.value = false;
      },
      onError: (err) {
        isFeaturedLoading.value = false;
        print('Error loading featured news: $err');
      },
    );
  }

  // Refresh kora
  void refreshNews() {
    fetchAllNews();
    fetchFeaturedNews();
  }
}
