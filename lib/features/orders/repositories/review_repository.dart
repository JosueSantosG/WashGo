import 'package:washgo/features/orders/models/washgo_review.dart';

abstract class ReviewRepository {
  Future<void> createReview({
    required String orderId,
    required String businessId,
    String? employeeId,
    required int calificacion,
    String? comentario,
    int? appCalificacion,
    String? appComentario,
  });

  Future<List<WashGoReview>> getBusinessReviews(String businessId);

  Future<WashGoReview?> getOrderReview(String orderId);

  Future<List<WashGoReview>> getGlobalAppRatings();
}
