import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/screens/sign_in_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _speedLimitOffset = 5.0;
  bool _fcwEnabled = true;
  bool _ldwEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.backgroundSubtle),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.backgroundSubtle,
                    child: Icon(Icons.person, size: 30, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin User',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'admin@fleetmanager.com',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'ADAS Configuration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.backgroundSubtle),
              ),
              child: Column(
                children: [
                   _buildToggleItem(
                     'Forward Collision Warning', 
                     'Alert when approaching vehicle too fast',
                     _fcwEnabled,
                     (val) => setState(() => _fcwEnabled = val),
                   ),
                   const Divider(height: 32),
                   _buildToggleItem(
                     'Lane Departure Warning', 
                     'Alert when crossing lane markers',
                     _ldwEnabled,
                     (val) => setState(() => _ldwEnabled = val),
                   ),
                   const Divider(height: 32),
                   
                   // Slider
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           const Text(
                             'Speed Limit Alert Offset',
                             style: TextStyle(
                               color: AppColors.textPrimary,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                           Text(
                             '+${_speedLimitOffset.round()} km/h',
                             style: const TextStyle(
                               fontWeight: FontWeight.bold,
                               color: AppColors.primary,
                             ),
                           ),
                         ],
                       ),
                       Slider(
                         value: _speedLimitOffset,
                         min: 0,
                         max: 20,
                         divisions: 4,
                         activeColor: AppColors.primary,
                         onChanged: (val) {
                           setState(() {
                             _speedLimitOffset = val;
                           });
                         },
                       ),
                     ],
                   ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => const SignInScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
