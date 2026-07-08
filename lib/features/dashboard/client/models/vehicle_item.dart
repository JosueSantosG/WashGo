import 'package:flutter/material.dart';

class VehicleItem {
  final String id;
  final String plate;
  final String brandModel;
  final String type; // Sedan, SUV, Hatchback, Moto
  final IconData icon;
  final String? modelId;
  final String? brandId;

  const VehicleItem({
    required this.id,
    required this.plate,
    required this.brandModel,
    required this.type,
    required this.icon,
    this.modelId,
    this.brandId,
  });

  String get categoryDisplayName {
    final t = type.toLowerCase().trim();
    if (t == 'moto') return '🏍 Moto';
    if (t == 'pequeño' || t == 'pequeno' || t == 'hatchback') return '🚗 Pequeño';
    if (t == 'mediano' || t == 'sedan') return '🚙 Mediano';
    if (t == 'grande' || t == 'suv') return '🚐 Grande';
    return '🚗 $type';
  }
}

