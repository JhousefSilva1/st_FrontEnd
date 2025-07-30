import 'package:flutter/material.dart';
import 'package:smarttolls/api/response/admin/st_vehicles_response.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

class VehiclesCard extends StatelessWidget {
  final StVehicleResponse vehicle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VehiclesCard({
    super.key,
    required this.vehicle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section with avatar and basic info
          _buildHeaderSection(context),
          
          // Divider
          const Divider(height: 1, thickness: 1),
          
          // Detailed information section
          _buildInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar/Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppStyle.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.car_repair,
              color: AppStyle.primary,
              size: 28,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.vehiclesModels.modelName}'.trim(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle.vehiclesType.vehiclesTypesName ?? 'N/A',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Action buttons

        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _buildInfoRow(Icons.car_crash, S.of(context).licensePlate, vehicle.licensePlate ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.confirmation_number, S.of(context).chassisNumber, vehicle.chassisNumber ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.numbers, S.of(context).engineNumber, vehicle.engineNumber ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.calendar_today, S.of(context).manufacturingYear, vehicle.manufacturingYear ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.monitor_weight, S.of(context).weight, vehicle.weight != null ? '${vehicle.weight} kg' : 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.local_gas_station, S.of(context).fuelType, vehicle.fuelTypes.fuelTypeName ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.color_lens, S.of(context).color, vehicle.vehiclesColors.colorName ?? 'N/A'),
          const SizedBox(height: 8),
          _buildLocationRow(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppStyle.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // children: [
      //   const Icon(Icons.location_on, size: 20, color: AppStyle.primary),
      //   const SizedBox(width: 12),
      //   Expanded(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           S.current.location,
      //           style: TextStyle(
      //             fontSize: 12,
      //             color: Colors.grey[600],
      //           ),
      //         ),
      //         const SizedBox(height: 2),
      //         Text(
      //           '${vehicle.city.cityName ?? 'N/A'}, ${vehicle.country.countryName ?? 'N/A'}',
      //           style: const TextStyle(
      //             fontSize: 14,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ],
    );
  }
}