import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';

class BankTransferInstructionsPage extends StatefulWidget {
  final String orderId;
  final double amount;
  final String serviceName;
  final String businessName;
  final String? businessId;

  const BankTransferInstructionsPage({
    super.key,
    required this.orderId,
    required this.amount,
    required this.serviceName,
    required this.businessName,
    this.businessId,
  });

  @override
  State<BankTransferInstructionsPage> createState() =>
      _BankTransferInstructionsPageState();
}

class _BankTransferInstructionsPageState
    extends State<BankTransferInstructionsPage> {
  final BankTransferRepository _repository = BankTransferRepository();

  @override
  void initState() {
    super.initState();
    _checkExistingProof();
  }

  Future<void> _checkExistingProof() async {
    try {
      final proof = await _repository.getProofStatus(widget.orderId);
      if (mounted && proof != null) {
        // Navigate to proof status page if proof already exists
        context.pushReplacementNamed(
          AppRoutes.proofStatus,
          extra: {
            'orderId': widget.orderId,
            'proofStatus': proof.status.name,
            'amount': widget.amount,
            'serviceName': widget.serviceName,
            'businessName': widget.businessName,
          },
        );
      }
    } catch (_) {
      // No existing proof, continue showing instructions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Transferencia Bancaria',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildWarningBanner(),
                    const SizedBox(height: 24),
                    _buildBankAccountCard(
                      'Banco Guayaquil',
                      'Cuenta de ahorro',
                      '29691954',
                      'Josue Santos Gonzabay',
                      '0928074954',
                      const Color(0xFF1A3A5C),
                    ),
                    const SizedBox(height: 16),
                    _buildBankAccountCard(
                      'Banco Pichincha',
                      'Cuenta de ahorro',
                      '2213487506',
                      'Josue Santos Gonzabay',
                      '0928074954',
                      const Color(0xFF0F265C),
                    ),
                    const SizedBox(height: 24),
                    _buildInstructions(),
                    const SizedBox(height: 24),
                    _buildAmountCard(),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.account_balance_rounded, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            'Realiza tu Transferencia',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Puedes elegir a qué banco realizar la transferencia, copiar los datos de la cuenta y luego seguir los pasos indicados abajo para validar tu pago.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFD97706),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Límite de tiempo importante',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tienes 30 minutos desde la creación de la reserva para realizar el pago y subir tu comprobante. De lo contrario, se cancelará automáticamente.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFFB45309),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountCard(
    String bankName,
    String accountType,
    String accountNumber,
    String holder,
    String identity,
    Color bankColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bankColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.account_balance, color: bankColor, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                bankName,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Tipo: $accountType', Icons.account_balance_wallet_rounded),
          Row(
            children: [
              Expanded(
                child: _buildInfoRow('No. Cuenta: $accountNumber', Icons.pin_rounded),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: accountNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Número de cuenta copiado al portapapeles',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy_rounded, size: 14, color: bankColor),
                        const SizedBox(width: 4),
                        Text(
                          'Copiar número de cuenta',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: bankColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildInfoRow('Titular: $holder', Icons.person_rounded),
          _buildInfoRow('Identificación: $identity', Icons.badge_rounded),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    final steps = [
      'Abre tu aplicación bancaria.',
      'Selecciona la opción de transferencia.',
      'Ingresa el monto exacto de \$${widget.amount.toStringAsFixed(2)}.',
      'Confirma la transferencia.',
      'Toma una captura de pantalla del comprobante.',
      'Toca "Ya hice la transferencia" y sube la imagen.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pasos a seguir',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: List.generate(steps.length, (i) {
              return Padding(
                padding: EdgeInsets.only(top: i > 0 ? 12 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        steps[i],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: i < 4
                              ? const Color(0xFF475569)
                              : AppColors.primary,
                          fontWeight: i >= 4 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCD34D)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFFD97706), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monto a transferir',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF92400E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.amount.toStringAsFixed(2)} USD',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Servicio: ${widget.serviceName}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await context.pushNamed(
              AppRoutes.proofUpload,
              extra: {
                'orderId': widget.orderId,
                'amount': widget.amount,
                'serviceName': widget.serviceName,
                'businessName': widget.businessName,
              },
            );
            if (result != null && mounted) {
              context.pushReplacementNamed(
                AppRoutes.proofStatus,
                extra: {
                  'orderId': widget.orderId,
                  'proofStatus': 'PENDIENTE',
                  'amount': widget.amount,
                  'serviceName': widget.serviceName,
                  'businessName': widget.businessName,
                },
              );
            }
          },
          icon: const Icon(Icons.file_upload_rounded, size: 20),
          label: Text(
            'Ya hice la transferencia',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
