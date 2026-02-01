import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Vehicles'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by plate, driver...',
                prefixIcon: const Icon(Icons.search),
                fillColor: AppColors.backgroundSubtle,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        separatorBuilder: (c, i) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return const VehicleCard(
            plateNumber: '59B1-123.45',
            driverName: 'Nguyen Van A',
            location: 'Cau Giay, Hanoi',
            status: 'Moving',
            lastActive: 'Just now',
          );
        },
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String plateNumber;
  final String driverName;
  final String location;
  final String status;
  final String lastActive;

  const VehicleCard({
    super.key,
    required this.plateNumber,
    required this.driverName,
    required this.location,
    required this.status,
    required this.lastActive,
  });

  @override
  Widget build(BuildContext context) {
    bool isMoving = status == 'Moving';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.backgroundSubtle),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plateNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    driverName,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                 decoration: BoxDecoration(
                   color: isMoving 
                       ? AppColors.success.withOpacity(0.1) 
                       : Colors.grey.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(20),
                 ),
                 child: Text(
                   status,
                   style: TextStyle(
                     color: isMoving ? AppColors.success : Colors.grey,
                     fontWeight: FontWeight.bold,
                     fontSize: 12,
                   ),
                 ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                lastActive,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
