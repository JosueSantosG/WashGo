import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/orders/repositories/review_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_review_repository.dart';

class ReviewBottomSheet extends StatefulWidget {
  final String orderId;
  final String businessId;
  final String? employeeId;
  final String businessName;
  final int initialRating;
  final VoidCallback? onReviewSubmitted;

  const ReviewBottomSheet({
    super.key,
    required this.orderId,
    required this.businessId,
    this.employeeId,
    required this.businessName,
    this.initialRating = 0,
    this.onReviewSubmitted,
  });

  static Future<void> show(
    BuildContext context, {
    required String orderId,
    required String businessId,
    String? employeeId,
    required String businessName,
    int initialRating = 0,
    VoidCallback? onReviewSubmitted,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewBottomSheet(
        orderId: orderId,
        businessId: businessId,
        employeeId: employeeId,
        businessName: businessName,
        initialRating: initialRating,
        onReviewSubmitted: onReviewSubmitted,
      ),
    );
  }

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final ReviewRepository _reviewRepository = FirebaseReviewRepository();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _appCommentController = TextEditingController();

  int _rating = 0;
  int _appRating = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  void dispose() {
    _commentController.dispose();
    _appCommentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, califica el servicio con al menos 1 estrella.',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _reviewRepository.createReview(
        orderId: widget.orderId,
        businessId: widget.businessId,
        employeeId: widget.employeeId,
        calificacion: _rating,
        comentario: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
        appCalificacion: _appRating == 0 ? null : _appRating,
        appComentario: _appCommentController.text.trim().isEmpty ? null : _appCommentController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Muchas gracias por tus comentarios!',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
        widget.onReviewSubmitted?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al guardar la calificación. Por favor intenta de nuevo.',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildStarRating({
    required int currentRating,
    required ValueChanged<int> onRatingChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isSelected = starValue <= currentRating;
        return IconButton(
          onPressed: () => onRatingChanged(starValue),
          icon: Icon(
            isSelected ? Icons.star : Icons.star_border,
            color: isSelected ? Colors.amber : AppColors.textSecondary.withValues(alpha: 0.4),
            size: 40,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: 20 + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bottom sheet drag handle
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '¿Cómo estuvo tu servicio?',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tu calificación para ${widget.businessName}',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            _buildStarRating(
              currentRating: _rating,
              onRatingChanged: (val) {
                setState(() {
                  _rating = val;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              style: GoogleFonts.outfit(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Cuéntanos qué te pareció el servicio (opcional)...',
                hintStyle: GoogleFonts.outfit(color: AppColors.textSecondary.withValues(alpha: 0.7)),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            Divider(color: AppColors.textSecondary.withValues(alpha: 0.1)),
            const SizedBox(height: 16),
            Text(
              '¿Qué tal tu experiencia con la App?',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Ayúdanos a mejorar la aplicación de WashGo',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildStarRating(
              currentRating: _appRating,
              onRatingChanged: (val) {
                setState(() {
                  _appRating = val;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _appCommentController,
              maxLines: 2,
              style: GoogleFonts.outfit(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Comentarios sobre la app (opcional)...',
                hintStyle: GoogleFonts.outfit(color: AppColors.textSecondary.withValues(alpha: 0.7)),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    )
                  : Text(
                      'Enviar Calificación',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
