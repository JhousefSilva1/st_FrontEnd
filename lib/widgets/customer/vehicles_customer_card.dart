import 'package:flutter/material.dart';
import 'package:smarttolls/api/response/admin/st_vehicles_response.dart';
import 'package:smarttolls/generated/l10n.dart';
import 'package:smarttolls/style/app_style.dart';

import '../../views/customer/vehicles/vehicles_customer_view.dart';

class VehiclesCustomerCard extends StatelessWidget {
  final StVehicleResponse vehicle;


  const VehiclesCustomerCard({
    super.key,
    required this.vehicle,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(context),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildInfoSection(context),
          ),
          _buildLocationSection(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppStyle.primary),
                  onPressed: () => showEditVehicleDialog(context, vehicle),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.values.first,
              borderRadius: BorderRadius.circular(50),
              color: AppStyle.primary.withOpacity(0.1),
              border: Border.all(color: AppStyle.primary, width: 1.5),
            ),
            child: const Icon(
              Icons.car_repair_sharp,
              
              color: AppStyle.primary,
              size: 24,
              
            ),
            
            // see vehicle type
            
          ),
          Text(
            vehicle.licensePlate?? 'N/A',
            style: const TextStyle(
              // encerrado en tag
              color: AppStyle.primary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        _buildInfoItem(Icons.car_crash, S.of(context).brand, vehicle.vehiclesModels.brand.brandName ?? 'N/A'),

                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
        
                ),
                _buildInfoItem(Icons.car_crash, S.of(context).model, vehicle.vehiclesModels.modelName ?? 'N/A'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
        
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      children: [
        _buildInfoItem(Icons.car_crash, S.of(context).vehicleType, vehicle.vehiclesType.vehiclesTypesName ?? 'N/A'),
        const SizedBox(height: 8),
        _buildInfoItem(Icons.confirmation_number, S.of(context).chassisNumber, vehicle.chassisNumber ?? 'N/A'),
        const SizedBox(height: 8),
        _buildInfoItem(Icons.numbers, S.of(context).engineNumber, vehicle.engineNumber ?? 'N/A'),
        const SizedBox(height: 8),
        _buildInfoItem(Icons.calendar_today, S.of(context).manufacturingYear, vehicle.manufacturingYear ?? 'N/A'),
        const SizedBox(height: 8),
        _buildInfoItem(Icons.monitor_weight, S.of(context).weight, vehicle.weight != null ? '${vehicle.weight} kg' : 'N/A'),
        const SizedBox(height: 8),
        _buildInfoItem(Icons.local_gas_station, S.of(context).fuelType, vehicle.fuelTypes.fuelTypeName ?? 'N/A'),
        const SizedBox(height: 8),
        _buildInfoItem(Icons.color_lens, S.of(context).color, vehicle.vehiclesColors.colorName ?? 'N/A'),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
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

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppStyle.primary.withOpacity(0.03),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 18, color: AppStyle.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${vehicle.city.cityName ?? 'N/A'}, ${vehicle.country.countryName ?? 'N/A'}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

