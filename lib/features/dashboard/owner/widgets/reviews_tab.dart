import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/orders/models/washgo_review.dart';
import 'package:washgo/features/orders/repositories/review_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_review_repository.dart';

class ReviewsTab extends StatefulWidget {
  final String businessId;
  final AnimationController animationController;
  final ReviewRepository? reviewRepository;

  const ReviewsTab({
    super.key,
    required this.businessId,
    required this.animationController,
    this.reviewRepository,
  });

  @override
  State<ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<ReviewsTab> {
  late final ReviewRepository _reviewRepository;
  List<WashGoReview> _reviews = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Stats
  double _averageRating = 0.0;
  int _totalReviews = 0;
  final Map<int, int> _starDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

  @override
  void initState() {
    super.initState();
    _reviewRepository = widget.reviewRepository ?? FirebaseReviewRepository();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reviewsList = await _reviewRepository.getBusinessReviews(widget.businessId);
      
      // Sort by creation date descending
      reviewsList.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));

      if (mounted) {
        setState(() {
          _reviews = reviewsList;
          _totalReviews = reviewsList.length;

          // Reset distribution
          for (int i = 1; i <= 5; i++) {
            _starDistribution[i] = 0;
          }

          if (_totalReviews > 0) {
            double sum = 0.0;
            for (var review in reviewsList) {
              sum += review.calificacion;
              final val = review.calificacion.clamp(1, 5);
              _starDistribution[val] = (_starDistribution[val] ?? 0) + 1;
            }
            _averageRating = sum / _totalReviews;
          } else {
            _averageRating = 0.0;
          }
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar las reseñas: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return FadeTransition(
        opacity: widget.animationController,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return FadeTransition(
        opacity: widget.animationController,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Column(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 48),
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadReviews,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: widget.animationController,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reputación del Local',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: _loadReviews,
                  icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                  tooltip: 'Actualizar',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatsCard(),
            const SizedBox(height: 32),
            Text(
              'Reseñas Recientes',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _reviews.isEmpty ? _buildEmptyReviewsState() : _buildReviewsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 550;
          
          final summaryBlock = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _averageRating.toStringAsFixed(1),
                style: GoogleFonts.inter(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              _buildStarRatingRow(_averageRating, size: 24),
              const SizedBox(height: 12),
              Text(
                '$_totalReviews opiniones',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          );

          final distributionBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(5, (index) {
              final stars = 5 - index;
              final count = _starDistribution[stars] ?? 0;
              final percent = _totalReviews > 0 ? (count / _totalReviews) : 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                key: ValueKey('star_row_$stars'),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                      child: Text(
                        stars.toString(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 25,
                      child: Text(
                        count.toString(),
                        textAlign: TextAlign.end,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(flex: 3, child: summaryBlock),
                Container(
                  height: 120,
                  width: 1,
                  color: Colors.grey.shade100,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                ),
                Expanded(flex: 5, child: distributionBlock),
              ],
            );
          } else {
            return Column(
              children: [
                summaryBlock,
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                distributionBlock,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildStarRatingRow(double rating, {double size = 16}) {
    int fullStars = rating.floor();
    bool hasHalf = (rating - fullStars) >= 0.25;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (index == fullStars && hasHalf) {
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.grey.shade300, size: size);
        }
      }),
    );
  }

  Widget _buildEmptyReviewsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Sin calificaciones aún',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aquí se mostrará el feedback y las opiniones de los clientes para ayudarte a mejorar el servicio.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        final formattedDate = '${review.fechaCreacion.day.toString().padLeft(2, '0')}/${review.fechaCreacion.month.toString().padLeft(2, '0')}/${review.fechaCreacion.year}';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < review.calificacion ? Icons.star : Icons.star_border,
                        color: starIndex < review.calificacion ? Colors.amber : Colors.grey.shade300,
                        size: 18,
                      );
                    }),
                  ),
                  Text(
                    formattedDate,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (review.comentario != null && review.comentario!.trim().isNotEmpty) ...[
                Text(
                  '"${review.comentario}"',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ] else ...[
                Text(
                  'El cliente no dejó comentarios escritos.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              if (review.employeeName != null && review.employeeName!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.badge_outlined,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Atendido por: ${review.employeeName}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
