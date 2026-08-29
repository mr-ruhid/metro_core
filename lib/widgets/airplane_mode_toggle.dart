import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metro_core/services/airplane_mode_service.dart';

class AirplaneModeToggle extends StatelessWidget {
  const AirplaneModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final airplane = Provider.of<AirplaneModeService>(context);

    return GestureDetector(
      onTap: () {
        // Quick toggle from status bar
        airplane.toggleAirplaneMode();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: airplane.isAirplaneMode
              ? Colors.orange.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: airplane.isAirplaneMode
              ? Border.all(color: Colors.orange.withOpacity(0.3))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              // ✅ Düzəliş: Icons.flight_on və Icons.flight_off
              airplane.isAirplaneMode ? Icons.flight : Icons.flight_takeoff,
              size: 18,
              color: airplane.isAirplaneMode ? Colors.orange : Colors.grey,
            ),
            if (airplane.isAirplaneMode) ...[
              const SizedBox(width: 4),
              const Text(
                '✈️',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}