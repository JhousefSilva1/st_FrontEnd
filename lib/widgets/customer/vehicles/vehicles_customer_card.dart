import 'package:flutter/material.dart';
import 'package:smarttolls/api/response/admin/st_vehicles_response.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

import '../../../views/customer/vehicles/vehicles_customer_view.dart';

class VehiclesCustomerCard extends StatelessWidget {
  final StVehicleResponse vehicle;

  const VehiclesCustomerCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showVehicleDetails(context, vehicle),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppStyle.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ícono de vehículo
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppStyle.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_car, color: AppStyle.primary, size: 32),
            ),
            const SizedBox(width: 16),

            // Información principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.licensePlate ?? 'N/A',
                    style: const TextStyle(
                      color: AppStyle.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${vehicle.vehiclesModels.brand.brandName ?? 'N/A'} - ${vehicle.vehiclesModels.modelName ?? 'N/A'}',
                    style: TextStyle(
                      color: AppStyle.primary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Toca para ver más detalles',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppStyle.primary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),

            // Flechita
            const Icon(Icons.arrow_forward_ios_rounded, color: AppStyle.primary, size: 16),
          ],
        ),
      ),
    );
  }

void _showVehicleDetails(BuildContext context, StVehicleResponse vehicle) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                // Ícono central
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppStyle.primary.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.directions_car, size: 40, color: AppStyle.primary),
                ),
                const SizedBox(height: 16),

                // Matrícula y modelo
                Text(
                  vehicle.licensePlate ?? 'N/A',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '${vehicle.vehiclesModels.brand.brandName ?? ''} - ${vehicle.vehiclesModels.modelName ?? ''}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),

                const SizedBox(height: 24),
                Wrap(
                  runSpacing: 12,
                  spacing: 16,
                  children: [
                    _infoChip(Icons.car_crash, 'Tipo', vehicle.vehiclesType.vehiclesTypesName),
                    _infoChip(Icons.confirmation_number, 'Chasis', vehicle.chassisNumber),
                    _infoChip(Icons.numbers, 'Motor', vehicle.engineNumber),
                    _infoChip(Icons.calendar_today, 'Año', vehicle.manufacturingYear),
                    _infoChip(Icons.monitor_weight, 'Peso', '${vehicle.weight ?? 'N/A'} kg'),
                    _infoChip(Icons.local_gas_station, 'Combustible', vehicle.fuelTypes.fuelTypeName),
                    _infoChip(Icons.color_lens, 'Color', vehicle.vehiclesColors.colorName),
                    _infoChip(Icons.location_city, 'Ciudad', vehicle.city.cityName),
                    _infoChip(Icons.public, 'País', vehicle.country.countryName),
                  ],
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,

                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _infoChip(IconData icon, String label, String? value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    constraints: const BoxConstraints(minWidth: 120),
    decoration: BoxDecoration(
      color: AppStyle.primary.withOpacity(0.06),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppStyle.primary, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value ?? 'N/A',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _infoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppStyle.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value ?? 'N/A',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
