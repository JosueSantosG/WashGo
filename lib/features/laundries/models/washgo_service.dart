import 'package:washgo/dataconnect-generated/example.dart';

class WashGoService {
  final String id;
  final String nombre;
  final String? descripcion;
  final double precioPequeno;
  final double precioMediano;
  final double precioGrande;
  final double precioMoto;
  final double precioOwnerPequeno;
  final double precioOwnerMediano;
  final double precioOwnerGrande;
  final double precioOwnerMoto;
  final bool precioPendiente;
  final double costo;
  final int duracionMinutos;
  final ServiceType tipo;
  final bool activo;

  const WashGoService({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precioPequeno,
    required this.precioMediano,
    required this.precioGrande,
    required this.precioMoto,
    required this.precioOwnerPequeno,
    required this.precioOwnerMediano,
    required this.precioOwnerGrande,
    required this.precioOwnerMoto,
    required this.precioPendiente,
    this.costo = 0.0,
    required this.duracionMinutos,
    required this.tipo,
    required this.activo,
  });

  double getPriceForCategory(String category) {
    switch (category.trim()) {
      case 'Pequeño':
        return precioPequeno;
      case 'Mediano':
        return precioMediano;
      case 'Grande':
        return precioGrande;
      case 'Moto':
        return precioMoto;
      default:
        return precioPequeno;
    }
  }

  double getProposedPriceForCategory(String category) {
    switch (category.trim()) {
      case 'Pequeño':
        return precioOwnerPequeno;
      case 'Mediano':
        return precioOwnerMediano;
      case 'Grande':
        return precioOwnerGrande;
      case 'Moto':
        return precioOwnerMoto;
      default:
        return precioOwnerPequeno;
    }
  }
}
