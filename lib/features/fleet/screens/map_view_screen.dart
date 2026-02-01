import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background (Placeholder)
          Container(
            color: const Color(0xFFF1F3F5), 
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Interactive Map Module',
                    style: TextStyle(color: Colors.grey[400], fontSize: 18),
                  ),
                ),
                // Simulated pulsing dots (markers)
                const Positioned(
                  top: 300,
                  left: 150,
                  child: PulsingMarker(color: AppColors.premiumOrange),
                ),
                 const Positioned(
                  top: 450,
                  right: 100,
                  child: PulsingMarker(color: AppColors.accent),
                ),
              ],
            ),
          ),
          
          // Top Filter Bar - Glassmorphism Style
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ],
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  _buildFilterChip('All', _selectedFilter == 'All'),
                  _buildFilterChip('Online', _selectedFilter == 'Online'),
                  _buildFilterChip('Offline', _selectedFilter == 'Offline'),
                  const Spacer(),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSubtle,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                       padding: EdgeInsets.zero,
                       icon: const Icon(Icons.layers_outlined, size: 20), 
                       onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Sheet (Simulated Selection)
           Positioned(
            left: 20,
            right: 20,
            bottom: 30, // Floating card style
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                 boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vehicle 59B1-123.45',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          ),
                           const SizedBox(height: 4),
                           Text(
                             'Driver: Nguyen Van A',
                             style: const TextStyle(color: AppColors.textSecondary),
                           ),
                        ],
                      ),
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt, size: 16, color: AppColors.success),
                            SizedBox(width: 4),
                             Text(
                              'Active',
                              style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                   ),
                   const SizedBox(height: 24),
                   Row(
                     children: [
                       Expanded(
                         child: OutlinedButton(
                           onPressed: () {},
                           style: OutlinedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(vertical: 16),
                             side: const BorderSide(color: AppColors.border),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                           ),
                           child: const Text('Details', style: TextStyle(color: AppColors.textPrimary)),
                         ),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         flex: 2,
                         child: Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(16),
                             gradient: AppColors.orangeGradient, // Orange with effects
                             boxShadow: [
                               BoxShadow(
                                 color: AppColors.premiumOrange.withOpacity(0.4),
                                 blurRadius: 10,
                                 offset: const Offset(0, 4),
                               )
                             ],
                           ),
                           child: ElevatedButton(
                             onPressed: () {},
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.transparent,
                               shadowColor: Colors.transparent,
                               padding: const EdgeInsets.symmetric(vertical: 16),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(16),
                               ),
                             ),
                             child: const Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.videocam_rounded, color: Colors.white),
                                 SizedBox(width: 8),
                                 Text('Live View', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                               ],
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                ],
              ),
            ),
          ),
          
          // Add Upload FAB for Map
          Positioned(
            right: 20,
            bottom: 240,
            child: FloatingActionButton(
              onPressed: () {
                // Upload logic
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.cloud_upload_outlined, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class PulsingMarker extends StatelessWidget {
  final Color color;
  const PulsingMarker({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
              )
            ],
          ),
        ),
      ],
    );
  }
}
