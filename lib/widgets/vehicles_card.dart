import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttolls/api/response/st_vehicles_response.dart';
import 'package:smarttolls/providers/providers.dart';
import 'package:smarttolls/style/app_style.dart';

class VehiclesCard extends StatelessWidget {
  const VehiclesCard({
    super.key,
    required this.vehicle
  });
  final StVehicleResponse vehicle;

  @override
  Widget build(BuildContext context) {
    final VehiclesProvider vehiclesProvider = Provider.of<VehiclesProvider>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppStyle.white, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppStyle.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1
          ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset('assets/car.jpg', height: 120, width: 120),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('${vehicle.vehiclesModels.brand.brandName} - ${vehicle.vehiclesModels.modelName}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                  Text(vehicle.licensePlate ?? '', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                  Text(vehicle.vehiclesType.vehiclesTypes ?? '', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                  Text(vehicle.fuelTypes.fuelTypeFuel ?? '', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                  Text(vehicle.vehiclesColors.colorName ?? '', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                  Text(vehicle.manufacturingYear ?? '', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => vehiclesProvider.goToVehicleAdmin(context),
                    child: const Icon(Icons.remove_red_eye_sharp, color: AppStyle.primary)
                  ),
                  GestureDetector(
                    onTap: () => vehiclesProvider.goToEditVehicleAdmin(context),
                    child: const Icon(Icons.edit, color: AppStyle.primary)
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.delete, color: AppStyle.primary)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}