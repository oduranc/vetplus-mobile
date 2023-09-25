import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class ClinicMapInfo extends StatelessWidget {
  const ClinicMapInfo({
    super.key,
    required this.isTablet,
    required this.mapsUrl,
  });

  final bool isTablet;
  final String? mapsUrl;

  @override
  Widget build(BuildContext context) {
    final RegExp regex = RegExp(r'@([0-9.-]+),([0-9.-]+)');
    final match = regex.firstMatch(mapsUrl!);

    final double latitude = double.parse(match!.group(1)!);
    final double longitude = double.parse(match.group(2)!);

    return Wrap(
      runSpacing: isTablet ? 29 : 22.sp,
      children: [
        SizedBox(
          height: isTablet ? 300 : 210.sp,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(latitude, longitude),
              zoom: 17,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://www.google.com/maps/vt?hl=en&x={x}&y={y}&z={z}',
                subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                userAgentPackageName: 'com.example.vetplus',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(latitude, longitude),
                    builder: (context) => const Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
