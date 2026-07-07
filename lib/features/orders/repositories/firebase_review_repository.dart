// ignore_for_file: avoid_print
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/orders/models/washgo_review.dart';
import 'review_repository.dart';

class FirebaseReviewRepository implements ReviewRepository {
  final ExampleConnector _connector = ExampleConnector.instance;

  @override
  Future<void> createReview({
    required String orderId,
    required String businessId,
    String? employeeId,
    required int calificacion,
    String? comentario,
    int? appCalificacion,
    String? appComentario,
  }) async {
    await _connector
        .createReview(
          orderId: orderId,
          businessId: businessId,
          calificacion: calificacion,
        )
        .employeeId(employeeId)
        .comentario(comentario)
        .appCalificacion(appCalificacion)
        .appComentario(appComentario)
        .execute();
  }

  @override
  Future<List<WashGoReview>> getBusinessReviews(String businessId) async {
    try {
      final response = await _connector
          .getBusinessReviews(businessId: businessId)
          .ref()
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
      return response.data.reviews.map((r) {
        return WashGoReview(
          id: r.id,
          calificacion: r.calificacion,
          comentario: r.comentario,
          fechaCreacion: r.fechaCreacion.toDateTime(),
          employeeId: r.employee?.id,
          employeeName: r.employee?.nombreCompleto,
        );
      }).toList();
    } catch (e) {
      print("Error fetching business reviews: $e");
      return [];
    }
  }

  @override
  Future<WashGoReview?> getOrderReview(String orderId) async {
    try {
      final response = await _connector
          .getOrderReview(orderId: orderId)
          .ref()
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
      if (response.data.reviews.isEmpty) return null;
      final r = response.data.reviews.first;
      return WashGoReview(
        id: r.id,
        calificacion: r.calificacion,
        comentario: r.comentario,
        appCalificacion: r.appCalificacion,
        appComentario: r.appComentario,
        fechaCreacion: r.fechaCreacion.toDateTime(),
      );
    } catch (e) {
      print("Error fetching order review: $e");
      return null;
    }
  }

  @override
  Future<List<WashGoReview>> getGlobalAppRatings() async {
    try {
      final response = await _connector
          .getGlobalAppRatings()
          .ref()
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
      return response.data.reviews.map((r) {
        return WashGoReview(
          id: r.id,
          calificacion: 0,
          comentario: null,
          appCalificacion: r.appCalificacion,
          appComentario: r.appComentario,
          fechaCreacion: r.fechaCreacion.toDateTime(),
        );
      }).toList();
    } catch (e) {
      print("Error fetching global app ratings: $e");
      return [];
    }
  }
}
