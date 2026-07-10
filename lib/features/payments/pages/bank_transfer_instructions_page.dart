import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';

/// Cuenta para depósito en Banco Guayaquil.
const _guayaquilAccount = _BankAccount(
  bankName: 'Banco Guayaquil',
  accountType: 'Cuenta de Ahorros',
  accountNumber: '2969195409',
  titular: 'WASHGO S.A.',
  ruc: '1234567890001',
  accountKey: 'GUAYAQUIL',
);

/// Cuenta para depósito en Banco Pichincha.
const _pichinchaAccount = _BankAccount(
  bankName: 'Banco Pichincha',
  accountType: 'Cuenta de Ahorros',
  accountNumber: '2213487509',
  titular: 'WASHGO S.A.',
  ruc: '1234567890001',
  accountKey: 'PICHINCHA',
);

class _BankAccount {
  final String bankName;
  final String accountType;
  final String accountNumber;
  final String titular;
  final String ruc;
  final String accountKey;

  const _BankAccount({
    required this.bankName,
    required this.accountType,
    required this.accountNumber,
    required this.titular,
    required this.ruc,
    required this.accountKey,
  });
}

/// Page that shows bank account details for the client to make a transfer.
///
/// After making the transfer, the user taps "Ya hice el depósito" to proceed
/// to upload the proof of payment.
=======
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';

>>>>>>> worktree-fix-flutter-analyze-errors
class BankTransferInstructionsPage extends StatefulWidget {
  final String orderId;
  final double amount;
  final String serviceName;
  final String businessName;
<<<<<<< HEAD
=======
  final String? businessId;
>>>>>>> worktree-fix-flutter-analyze-errors

  const BankTransferInstructionsPage({
    super.key,
    required this.orderId,
    required this.amount,
    required this.serviceName,
    required this.businessName,
<<<<<<< HEAD
=======
    this.businessId,
>>>>>>> worktree-fix-flutter-analyze-errors
  });

  @override
  State<BankTransferInstructionsPage> createState() =>
      _BankTransferInstructionsPageState();
}

class _BankTransferInstructionsPageState
    extends State<BankTransferInstructionsPage> {
<<<<<<< HEAD
  String? _selectedAccount;
  bool _hasCopied = false;
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors

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
<<<<<<< HEAD
                    // Header
                    _buildHeaderSection(),
                    const SizedBox(height: 24),

                    // Resumen del pedido
                    _buildOrderSummary(),
                    const SizedBox(height: 24),

                    // Selección de banco
                    Text(
                      'Selecciona el banco para transferir',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Banco Guayaquil
                    _buildBankAccountCard(_guayaquilAccount),
                    const SizedBox(height: 12),

                    // Banco Pichincha
                    _buildBankAccountCard(_pichinchaAccount),
                    const SizedBox(height: 20),

                    // Important notes
                    _buildImportantNotes(),
=======
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildBankAccountCard(
                      'Banco Guayaquil',
                      'Tipo: Ahorros',
                      'No. Cuenta: 1234567890',
                      'Titular: WashGo S.A.',
                      'RUC: 0999999999001',
                      const Color(0xFF1A3A5C),
                    ),
                    const SizedBox(height: 16),
                    _buildBankAccountCard(
                      'Banco Pichincha',
                      'Tipo: Corriente',
                      'No. Cuenta: 0987654321',
                      'Titular: WashGo S.A.',
                      'RUC: 0999999999001',
                      const Color(0xFFD32F2F),
                    ),
                    const SizedBox(height: 24),
                    _buildInstructions(),
                    const SizedBox(height: 24),
                    _buildAmountCard(),
>>>>>>> worktree-fix-flutter-analyze-errors
                  ],
                ),
              ),
            ),
<<<<<<< HEAD

            // Bottom Button
            Container(
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
                child: ElevatedButton(
                  onPressed: _selectedAccount == null
                      ? null
                      : () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/bank-transfer/upload-proof',
                            extra: {
                              'orderId': widget.orderId,
                              'amount': widget.amount,
                              'serviceName': widget.serviceName,
                              'businessName': widget.businessName,
                              'paymentAccountType': _selectedAccount,
                            },
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Ya hice el depósito',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
=======
            _buildBottomButton(),
>>>>>>> worktree-fix-flutter-analyze-errors
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildHeaderSection() {
=======
  Widget _buildHeader() {
>>>>>>> worktree-fix-flutter-analyze-errors
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
<<<<<<< HEAD
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Realiza tu transferencia',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Transfiere el monto exacto a una de las cuentas '
            'mostradas abajo y luego sube el comprobante para '
            'que podamos verificar tu pago.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
=======
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
            'Sigue las instrucciones y luego sube tu comprobante para validar el pago.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
>>>>>>> worktree-fix-flutter-analyze-errors
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildOrderSummary() {
=======
  Widget _buildBankAccountCard(
    String bankName,
    String accountType,
    String accountNumber,
    String holder,
    String ruc,
    Color bankColor,
  ) {
>>>>>>> worktree-fix-flutter-analyze-errors
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
<<<<<<< HEAD
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resumen',
                style: GoogleFonts.inter(
                  fontSize: 14,
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
<<<<<<< HEAD
              Text(
                '\$${widget.amount.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.serviceName,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.store_rounded, size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Text(
                widget.businessName,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
=======
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(accountType, Icons.account_balance_wallet_rounded),
          _buildInfoRow(accountNumber, Icons.pin_rounded),
          _buildInfoRow(holder, Icons.person_rounded),
          _buildInfoRow(ruc, Icons.badge_rounded),
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
>>>>>>> worktree-fix-flutter-analyze-errors
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildBankAccountCard(_BankAccount account) {
    final isSelected = _selectedAccount == account.accountKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAccount = account.accountKey;
          _hasCopied = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    color: isSelected ? AppColors.primary : const Color(0xFF64748B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        account.accountType,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _buildDetailRow('Número de Cuenta', account.accountNumber),
            const SizedBox(height: 8),
            _buildDetailRow('Titular', account.titular),
            const SizedBox(height: 8),
            _buildDetailRow('RUC', account.ruc),
            const SizedBox(height: 12),
            if (isSelected)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: account.accountNumber),
                    );
                    setState(() => _hasCopied = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Número de cuenta copiado'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(
                    _hasCopied ? Icons.check_rounded : Icons.copy_rounded,
                    size: 16,
                  ),
                  label: Text(
                    _hasCopied ? 'Copiado' : 'Copiar número de cuenta',
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
=======
  Widget _buildInstructions() {
    final steps = [
      'Abre tu aplicación bancaria.',
      'Selecciona la opción de transferencia.',
      'Ingresa el monto exacto de \$${widget.amount.toStringAsFixed(2)}.',
      'Usa como referencia tu número de orden: ${widget.orderId.substring(0, 8)}...',
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
>>>>>>> worktree-fix-flutter-analyze-errors
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
<<<<<<< HEAD
=======
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
                          color: i < 5
                              ? const Color(0xFF475569)
                              : AppColors.primary,
                          fontWeight: i >= 5 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
>>>>>>> worktree-fix-flutter-analyze-errors
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildImportantNotes() {
=======
  Widget _buildAmountCard() {
>>>>>>> worktree-fix-flutter-analyze-errors
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
<<<<<<< HEAD
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCD34D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: Color(0xFFD97706), size: 18),
              const SizedBox(width: 8),
              Text(
                'Importante',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Transfiere el monto EXACTO mostrado en el resumen.\n'
            '• Una vez realizada la transferencia, sube el comprobante.\n'
            '• El negocio verificará el pago antes de confirmar el servicio.\n'
            '• Si no se verifica en 24h, la reserva se cancelará automáticamente.',
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.6,
              color: const Color(0xFF92400E),
=======
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
>>>>>>> worktree-fix-flutter-analyze-errors
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
=======

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
          onPressed: () {
            context.pushNamed(
              AppRoutes.proofUpload,
              extra: {
                'orderId': widget.orderId,
                'amount': widget.amount,
                'serviceName': widget.serviceName,
                'businessName': widget.businessName,
              },
            );
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
>>>>>>> worktree-fix-flutter-analyze-errors
}
