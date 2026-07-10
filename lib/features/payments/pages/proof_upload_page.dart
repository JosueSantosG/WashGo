import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< HEAD
import 'package:image_picker/image_picker.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/payments/services/bank_transfer_service.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';

/// Page for uploading proof of payment (screenshot/photo of the transfer).
///
/// Users select an image from gallery or camera, confirm the amount,
/// and submit for review.
=======
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/payments/models/payment_proof_model.dart';
import 'package:washgo/features/payments/repositories/bank_transfer_repository.dart';

>>>>>>> worktree-fix-flutter-analyze-errors
class ProofUploadPage extends StatefulWidget {
  final String orderId;
  final double amount;
  final String serviceName;
  final String businessName;
<<<<<<< HEAD
  final String paymentAccountType; // 'GUAYAQUIL' or 'PICHINCHA'
=======
>>>>>>> worktree-fix-flutter-analyze-errors

  const ProofUploadPage({
    super.key,
    required this.orderId,
    required this.amount,
    required this.serviceName,
    required this.businessName,
<<<<<<< HEAD
    required this.paymentAccountType,
=======
>>>>>>> worktree-fix-flutter-analyze-errors
  });

  @override
  State<ProofUploadPage> createState() => _ProofUploadPageState();
}

class _ProofUploadPageState extends State<ProofUploadPage> {
<<<<<<< HEAD
  final _repository = BankTransferRepository();
  final _picker = ImagePicker();
  final _referenceController = TextEditingController();
  final _observationsController = TextEditingController();

  XFile? _selectedImage;
  bool _isUploading = false;
=======
  final BankTransferRepository _repository = BankTransferRepository();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _referenceController = TextEditingController();
  PaymentAccountType _selectedAccount = PaymentAccountType.GUAYAQUIL;
  XFile? _selectedImage;
  bool _isUploading = false;
  bool _agreed = false;
>>>>>>> worktree-fix-flutter-analyze-errors

  @override
  void dispose() {
    _referenceController.dispose();
<<<<<<< HEAD
    _observationsController.dispose();
=======
>>>>>>> worktree-fix-flutter-analyze-errors
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
<<<<<<< HEAD
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 80,
      );
      if (file != null) {
        setState(() => _selectedImage = file);
=======
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _selectedImage = image);
>>>>>>> worktree-fix-flutter-analyze-errors
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        SnackBar(
          content: Text('Error al seleccionar imagen: $e'),
          backgroundColor: AppColors.error,
        ),
=======
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
>>>>>>> worktree-fix-flutter-analyze-errors
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
<<<<<<< HEAD
      builder: (ctx) => SafeArea(
=======
      builder: (context) => SafeArea(
>>>>>>> worktree-fix-flutter-analyze-errors
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
<<<<<<< HEAD
                  color: const Color(0xFFCBD5E1),
=======
                  color: Colors.grey.shade300,
>>>>>>> worktree-fix-flutter-analyze-errors
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Seleccionar imagen',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
<<<<<<< HEAD
                  color: const Color(0xFF1E293B),
=======
>>>>>>> worktree-fix-flutter-analyze-errors
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
<<<<<<< HEAD
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: AppColors.primary),
                ),
                title: Text('Cámara',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                subtitle: Text('Toma una foto del comprobante',
                    style: GoogleFonts.inter(fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
=======
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                title: const Text('Cámara'),
                subtitle: const Text('Toma una foto del comprobante'),
                onTap: () {
                  Navigator.pop(context);
>>>>>>> worktree-fix-flutter-analyze-errors
                  _pickImage(ImageSource.camera);
                },
              ),
              const Divider(),
              ListTile(
<<<<<<< HEAD
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: Color(0xFF64748B)),
                ),
                title: Text('Galería',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                subtitle: Text('Selecciona de tus fotos',
                    style: GoogleFonts.inter(fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
=======
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                title: const Text('Galería'),
                subtitle: const Text('Selecciona de tu galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 10),
>>>>>>> worktree-fix-flutter-analyze-errors
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitProof() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        const SnackBar(
          content: Text('Selecciona una imagen del comprobante'),
          backgroundColor: AppColors.error,
        ),
=======
        const SnackBar(content: Text('Por favor selecciona una imagen del comprobante')),
      );
      return;
    }

    if (_referenceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa el número de referencia')),
      );
      return;
    }

    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los términos')),
>>>>>>> worktree-fix-flutter-analyze-errors
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
<<<<<<< HEAD
      final bytes = await _selectedImage!.readAsBytes();
      final ext = _selectedImage!.name.split('.').last.toLowerCase();
      final validExtensions = ['jpg', 'jpeg', 'png'];
      final safeExt = validExtensions.contains(ext) ? ext : 'jpg';

      final reference = _referenceController.text.trim();

      await _repository.uploadProof(
        orderId: widget.orderId,
        imageBytes: bytes,
        extension: safeExt,
        declaredAmount: widget.amount,
        paymentAccountType: widget.paymentAccountType,
        referenceNumber: reference.isNotEmpty ? reference : null,
        observations:
            _observationsController.text.trim().isNotEmpty
                ? _observationsController.text.trim()
                : null,
=======
      final proof = await _repository.uploadProof(
        orderId: widget.orderId,
        imagePath: _selectedImage!.path,
        accountType: _selectedAccount,
        referenceNumber: _referenceController.text.trim(),
        amount: widget.amount,
>>>>>>> worktree-fix-flutter-analyze-errors
      );

      if (!mounted) return;

<<<<<<< HEAD
      // Navigate to proof status page
      Navigator.pushReplacementNamed(
        context,
        '/bank-transfer/proof-status',
        extra: {
          'orderId': widget.orderId,
=======
      // Navigate to status page with the result
      context.pushReplacementNamed(
        AppRoutes.proofStatus,
        extra: {
          'orderId': widget.orderId,
          'proofStatus': proof.status.name,
          'amount': widget.amount,
>>>>>>> worktree-fix-flutter-analyze-errors
          'serviceName': widget.serviceName,
          'businessName': widget.businessName,
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al subir comprobante: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

<<<<<<< HEAD
  bool get _canSubmit => _selectedImage != null && !_isUploading;

  @override
  Widget build(BuildContext context) {
    final accountName = widget.paymentAccountType == 'GUAYAQUIL'
        ? 'Banco Guayaquil'
        : 'Banco Pichincha';

=======
  @override
  Widget build(BuildContext context) {
>>>>>>> worktree-fix-flutter-analyze-errors
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Subir Comprobante',
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
                    // Account info banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_rounded,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transferencia a $accountName',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Monto: \$${widget.amount.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.primary
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Image picker area
                    Text(
                      'Comprobante de pago',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sube una foto o captura de pantalla del comprobante '
                      'de la transferencia realizada.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),

=======
                    // Image picker area
>>>>>>> worktree-fix-flutter-analyze-errors
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        width: double.infinity,
<<<<<<< HEAD
                        height: 200,
=======
                        height: 220,
>>>>>>> worktree-fix-flutter-analyze-errors
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _selectedImage != null
                                ? AppColors.primary
                                : const Color(0xFFE2E8F0),
<<<<<<< HEAD
                            width: 2,
=======
                            width: _selectedImage != null ? 2 : 1,
>>>>>>> worktree-fix-flutter-analyze-errors
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      File(_selectedImage!.path),
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
<<<<<<< HEAD
                                        onTap: () =>
                                            setState(() => _selectedImage = null),
=======
                                        onTap: () => setState(() => _selectedImage = null),
>>>>>>> worktree-fix-flutter-analyze-errors
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
<<<<<<< HEAD
                                            Icons.close_rounded,
=======
                                            Icons.close,
>>>>>>> worktree-fix-flutter-analyze-errors
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
<<<<<<< HEAD
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
=======
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
>>>>>>> worktree-fix-flutter-analyze-errors
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.add_photo_alternate_rounded,
<<<<<<< HEAD
                                      size: 40,
                                      color: Color(0xFF94A3B8),
=======
                                      color: AppColors.primary,
                                      size: 30,
>>>>>>> worktree-fix-flutter-analyze-errors
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
<<<<<<< HEAD
                                    'Toca para seleccionar imagen',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF64748B),
=======
                                    'Tocar para seleccionar comprobante',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
>>>>>>> worktree-fix-flutter-analyze-errors
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
<<<<<<< HEAD
                                    'PNG, JPG o JPEG',
=======
                                    'Captura de pantalla o foto del voucher',
>>>>>>> worktree-fix-flutter-analyze-errors
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
<<<<<<< HEAD
                    const SizedBox(height: 24),

                    // Reference number field
                    Text(
                      'Número de referencia (opcional)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
=======
                    const SizedBox(height: 20),

                    // Account type selection
                    Text(
                      'Banco destino',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAccountTypeChip(
                            'Guayaquil',
                            PaymentAccountType.GUAYAQUIL,
                            const Color(0xFF1A3A5C),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAccountTypeChip(
                            'Pichincha',
                            PaymentAccountType.PICHINCHA,
                            const Color(0xFFD32F2F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Reference number
                    Text(
                      'Número de referencia',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
>>>>>>> worktree-fix-flutter-analyze-errors
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _referenceController,
<<<<<<< HEAD
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Ej: 1234567890',
                        hintStyle: GoogleFonts.inter(
                            fontSize: 14, color: const Color(0xFF94A3B8)),
=======
                      decoration: InputDecoration(
                        hintText: 'Ej: 1234567890',
                        hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
>>>>>>> worktree-fix-flutter-analyze-errors
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      style: GoogleFonts.inter(
                          fontSize: 14, color: const Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 20),

                    // Observations field
                    Text(
                      'Observaciones (opcional)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _observationsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Algún detalle adicional...',
                        hintStyle: GoogleFonts.inter(
                            fontSize: 14, color: const Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      style: GoogleFonts.inter(
                          fontSize: 14, color: const Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 16),

                    // Amount confirmation
                    Container(
                      padding: const EdgeInsets.all(12),
=======
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.pin_rounded, color: Color(0xFF94A3B8)),
                      ),
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Amount display
                    Container(
                      padding: const EdgeInsets.all(16),
>>>>>>> worktree-fix-flutter-analyze-errors
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Color(0xFF16A34A), size: 20),
<<<<<<< HEAD
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Confirmas que realizaste la transferencia '
                              'por \$${widget.amount.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF166534),
                              ),
=======
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Monto a pagar',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF166534),
                                  ),
                                ),
                                Text(
                                  '\$${widget.amount.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF166534),
                                  ),
                                ),
                              ],
>>>>>>> worktree-fix-flutter-analyze-errors
                            ),
                          ),
                        ],
                      ),
                    ),
<<<<<<< HEAD
=======
                    const SizedBox(height: 20),

                    // Terms agreement
                    CheckboxListTile(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                      title: Text(
                        'Confirmo que he realizado la transferencia por el monto exacto y acepto que el servicio será procesado una vez verificado el pago.',
                        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569)),
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
>>>>>>> worktree-fix-flutter-analyze-errors
                  ],
                ),
              ),
            ),

<<<<<<< HEAD
            // Submit button
=======
            // Bottom button
>>>>>>> worktree-fix-flutter-analyze-errors
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
<<<<<<< HEAD
                  onPressed: _canSubmit ? _submitProof : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
=======
                  onPressed: _isUploading ? null : _submitProof,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
>>>>>>> worktree-fix-flutter-analyze-errors
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Enviar comprobante',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  Widget _buildAccountTypeChip(String label, PaymentAccountType type, Color color) {
    final isSelected = _selectedAccount == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedAccount = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance,
              color: isSelected ? color : const Color(0xFF94A3B8),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
>>>>>>> worktree-fix-flutter-analyze-errors
}
