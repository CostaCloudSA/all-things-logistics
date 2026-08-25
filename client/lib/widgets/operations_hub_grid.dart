/// Operations Hub 2x4 Tactile Macro-Grid Widget.
/// Dynamically adapts to the active Logistics Buyer Persona:
/// - Campabadal Global (3PL Freight Forwarder & Customs Broker)
/// - Transportes Tomas (Regional Motor Carrier & Heavy Drayage)
/// - Agroexport Costa Rica (Enterprise Produce Shipper & Agro-Exporter)
/// - Naviera Don Jorge (Ocean Carrier & Marine Terminal Operator)

import 'package:flutter/material.dart';

class OperationsHubGrid extends StatelessWidget {
  final String tenantId;
  final Function(String actionId, String title)? onTileTapped;

  const OperationsHubGrid({
    Key? key,
    required this.tenantId,
    this.onTileTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiles = _getTilesForTenant(tenantId);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),
          itemCount: tiles.length,
          itemBuilder: (context, index) {
            final tile = tiles[index];
            return _buildMacroTile(context, tile);
          },
        );
      },
    );
  }

  Widget _buildMacroTile(BuildContext context, _TileConfig tile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTileTapped?.call(tile.actionId, tile.title);
        },
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Ink(
          decoration: BoxDecoration(
            color: tile.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: tile.color.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Translucent Icon Container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      tile.icon,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),

                // Bottom: Bold 2-Line Text Label
                Text(
                  tile.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_TileConfig> _getTilesForTenant(String tenantId) {
    switch (tenantId) {
      case 'tenant-tomas':
        return const [
          _TileConfig('audit_axle_load', 'Audit Axle\nLoad (23 CFR)', Color(0xFFDC2626), Icons.balance_rounded),
          _TileConfig('cabotage_relay', 'Cabotage\nRelay Match', Color(0xFFEA580C), Icons.swap_horiz_rounded),
          _TileConfig('gate_pre_pass', 'Weigh Scale\nGate Pre-Pass', Color(0xFF0D9488), Icons.badge_rounded),
          _TileConfig('cargo_manifest', 'DUCA-T\nTransit Manifest', Color(0xFF16A34A), Icons.article_rounded),
          _TileConfig('track_shipments', 'Live Fleet\nGPS & Geofence', Color(0xFF7C3AED), Icons.gps_fixed_rounded),
          _TileConfig('driver_whatsapp', 'Driver WhatsApp\nAutonomous Push', Color(0xFF0EA5E9), Icons.chat_bubble_outline_rounded),
          _TileConfig('dot_safety', 'DOT Safety\nPre-Trip Log', Color(0xFFEAB308), Icons.verified_user_rounded),
          _TileConfig('scan_qr', 'Roadside Police\nOffline QR Seal', Color(0xFF2563EB), Icons.qr_code_scanner_rounded),
        ];

      case 'tenant-agroexport-cr':
        return const [
          _TileConfig('tax_shield', '20% Tax Shield\n(Save \$4,250)', Color(0xFF059669), Icons.savings_rounded),
          _TileConfig('phyto_permit', 'Phytosanitary\nUSDA/MAG Permit', Color(0xFF16A34A), Icons.eco_rounded),
          _TileConfig('cold_chain', 'Cold-Chain Telematics\n(+4.5°C Reefer)', Color(0xFF0EA5E9), Icons.ac_unit_rounded),
          _TileConfig('cargo_manifest', 'Export DUCA-T\n& Clean B/L', Color(0xFF2563EB), Icons.description_rounded),
          _TileConfig('gate_release', 'Moín Terminal\nReefer Gate Pass', Color(0xFFEAB308), Icons.door_sliding_rounded),
          _TileConfig('customs_clearance', 'CAFTA-DR 0%\nTariff Schedule', Color(0xFF7C3AED), Icons.percent_rounded),
          _TileConfig('scan_qr', 'Phyto Health\nEd25519 Stamp', Color(0xFF0D9488), Icons.qr_code_2_rounded),
          _TileConfig('traceability', 'Farm-to-Port\nTraceability Pass', Color(0xFFEA580C), Icons.history_rounded),
        ];

      case 'tenant-naviera-don-jorge':
        return const [
          _TileConfig('vessel_stability', '3D Ballast\n& IMO Stability', Color(0xFF1E3A8A), Icons.directions_boat_rounded),
          _TileConfig('demurrage_alert', '48h Demurrage\nEarly Warning', Color(0xFFF59E0B), Icons.timer_outlined),
          _TileConfig('ebl_release', 'e-B/L Master\nCustoms Release', Color(0xFF16A34A), Icons.task_alt_rounded),
          _TileConfig('gate_pass', 'PortMiami Gate\nAppointment Pass', Color(0xFF0EA5E9), Icons.confirmation_number_rounded),
          _TileConfig('imo_hazmat', 'IMO Dangerous\nGoods Hazmat', Color(0xFFEF4444), Icons.warning_amber_rounded),
          _TileConfig('berth_schedule', 'Berth 4 Docking\nAuto-Scheduler', Color(0xFF7C3AED), Icons.anchor_rounded),
          _TileConfig('track_shipments', 'AIS Marine\nLive Telematics', Color(0xFF0D9488), Icons.radar_rounded),
          _TileConfig('scan_qr', 'Port Police\nManifest QR', Color(0xFF2563EB), Icons.qr_code_scanner_rounded),
        ];

      case 'tenant-campabadal':
      default:
        return const [
          _TileConfig('scan_qr', 'Scan QR\nCode', Color(0xFF2563EB), Icons.qr_code_scanner_rounded),
          _TileConfig('cargo_manifest', 'Cargo\nManifest', Color(0xFF16A34A), Icons.description_rounded),
          _TileConfig('track_shipments', 'Track\nShipments', Color(0xFFEA580C), Icons.local_shipping_rounded),
          _TileConfig('inventory_lookup', 'Inventory\nLookup', Color(0xFF0D9488), Icons.inventory_2_rounded),
          _TileConfig('create_bol', 'Create\nBOL', Color(0xFFEF4444), Icons.edit_document),
          _TileConfig('customs_clearance', 'Customs\nClearance', Color(0xFF7C3AED), Icons.flag_rounded),
          _TileConfig('schedule_pickup', 'Schedule\nPickup', Color(0xFFEAB308), Icons.airport_shuttle_rounded),
          _TileConfig('warehouse_entry', 'Warehouse\nEntry', Color(0xFF0EA5E9), Icons.warehouse_rounded),
        ];
    }
  }
}

class _TileConfig {
  final String actionId;
  final String title;
  final Color color;
  final IconData icon;

  const _TileConfig(this.actionId, this.title, this.color, this.icon);
}
