import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoId;

  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const Text('Event Playback', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Video Player Area
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    color: Colors.black,
                    child: const Icon(Icons.play_arrow, size: 80, color: Colors.white),
                  ),
                ),
                // Overlay Controls
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.replay_10, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.pause, color: Colors.white, size: 40),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.forward_10, color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          // Details Panel
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Drowsiness Detected',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Feb 26, 2026 • 14:30:45',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                     children: [
                       Expanded(
                         child: OutlinedButton.icon(
                           onPressed: () {},
                           icon: const Icon(Icons.download),
                           label: const Text('Download Clip'),
                           style: OutlinedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(vertical: 12),
                           ),
                         ),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: ElevatedButton.icon(
                           onPressed: () {},
                           icon: const Icon(Icons.map),
                           label: const Text('View Location'),
                            style: ElevatedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(vertical: 12),
                           ),
                         ),
                       ),
                     ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Incident Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Driver behavior indicated signs of fatigue. Eye closure duration exceeded 1.5 seconds multiple times within a 1-minute window.',
                    style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
