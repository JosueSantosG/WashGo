import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/orders/models/washgo_review.dart';
import 'package:washgo/features/orders/repositories/review_repository.dart';
import 'package:washgo/features/orders/repositories/firebase_review_repository.dart';

class AppRatingsTab extends StatefulWidget {
  final ReviewRepository? reviewRepository;

  const AppRatingsTab({
    super.key,
    this.reviewRepository,
  });

  @override
  State<AppRatingsTab> createState() => _AppRatingsTabState();
}

class _AppRatingsTabState extends State<AppRatingsTab> with SingleTickerProviderStateMixin {
  late final ReviewRepository _reviewRepository;
  List<WashGoReview> _appReviews = [];
  bool _isLoading = true;
  String? _errorMessage;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  // Stats
  double _averageRating = 0.0;
  int _totalReviews = 0;
  final Map<int, int> _starDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

  @override
  void initState() {
    super.initState();
    _reviewRepository = widget.reviewRepository ?? FirebaseReviewRepository();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _loadRatings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadRatings() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reviewsList = await _reviewRepository.getGlobalAppRatings();
      
      // Filter out reviews where appCalificacion is null
      final filteredList = reviewsList.where((r) => r.appCalificacion != null).toList();

      // Sort by creation date descending
      filteredList.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));

      if (mounted) {
        setState(() {
          _appReviews = filteredList;
          _totalReviews = filteredList.length;

          // Reset distribution
          for (int i = 1; i <= 5; i++) {
            _starDistribution[i] = 0;
          }

          if (_totalReviews > 0) {
            double sum = 0.0;
            for (var review in filteredList) {
              final rating = review.appCalificacion!;
              sum += rating;
              final val = rating.clamp(1, 5);
              _starDistribution[val] = (_starDistribution[val] ?? 0) + 1;
            }
            _averageRating = sum / _totalReviews;
          } else {
            _averageRating = 0.0;
          }
          
          _isLoading = false;
        });
        _animationController.forward(from: 0.0);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar las métricas de la app: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
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
              mainAxisSize: MainAxisSize.min,
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
                  onPressed: _loadRatings,
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
      opacity: _fadeAnimation,
      child: RefreshIndicator(
        onRefresh: _loadRatings,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usabilidad de la App',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Métricas globales y feedback de experiencia',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _loadRatings,
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                    tooltip: 'Actualizar métricas',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildStatsCard(),
              const SizedBox(height: 28),
              Text(
                'Feedback Reciente',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              _appReviews.isEmpty ? _buildEmptyState() : _buildReviewsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                style: GoogleFonts.outfit(
                  fontSize: 56,
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
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
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
                key: ValueKey('app_star_row_$stars'),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                      child: Text(
                        stars.toString(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
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
                          color: AppColors.onSurfaceVariant,
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

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Sin calificaciones aún',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aquí se mostrará el feedback y las opiniones sobre el funcionamiento de la aplicación.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
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
      itemCount: _appReviews.length,
      itemBuilder: (context, index) {
        final review = _appReviews[index];
        final rating = review.appCalificacion ?? 0;
        final comment = review.appComentario;
        final formattedDate = '${review.fechaCreacion.day.toString().padLeft(2, '0')}/${review.fechaCreacion.month.toString().padLeft(2, '0')}/${review.fechaCreacion.year}';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.01),
                blurRadius: 8,
                offset: const Offset(0, 2),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Usuario Anónimo',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formattedDate,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(5, (starIndex) {
                  return Icon(
                    starIndex < rating ? Icons.star : Icons.star_border,
                    color: starIndex < rating ? Colors.amber : Colors.grey.shade300,
                    size: 18,
                  );
                }),
              ),
              const SizedBox(height: 10),
              if (comment != null && comment.trim().isNotEmpty) ...[
                Text(
                  '"$comment"',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.onSurface,
                    height: 1.4,
                  ),
                ),
              ] else ...[
                Text(
                  'El usuario no dejó comentarios escritos.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
