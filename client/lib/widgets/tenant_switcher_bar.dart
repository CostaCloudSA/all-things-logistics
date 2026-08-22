/// White-Label Enterprise Tenant Switcher Bar.
/// Allows instant switching between Campabadal Global (Blue), Transportes Tomas (Red),
/// and Agroexport Costa Rica (Green) with live theme and credential re-binding.

import 'package:flutter/material.dart';

class TenantSwitcherBar extends StatelessWidget {
  final String activeTenantId;
  final Function(String) onTenantChanged;

  const TenantSwitcherBar({
    Key? key,
    required this.activeTenantId,
    required this.onTenantChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1120),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.corporate_fare, size: 16, color: Color(0xFF38BDF8)),
          ),
          const SizedBox(width: 8),
          const Text(
            'ENTERPRISE TENANT:',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildTenantPill(
                    id: 'tenant-campabadal',
                    name: 'Campabadal Global',
                    type: '3PL Forwarder',
                    color: const Color(0xFF0284C7), // Blue
                    icon: Icons.public,
                  ),
                  const SizedBox(width: 8),
                  _buildTenantPill(
                    id: 'tenant-tomas',
                    name: 'Transportes Tomas',
                    type: 'Motor Carrier MX-GT',
                    color: const Color(0xFFDC2626), // Red
                    icon: Icons.local_shipping,
                  ),
                  const SizedBox(width: 8),
                  _buildTenantPill(
                    id: 'tenant-agroexport-cr',
                    name: 'Agroexport Costa Rica',
                    type: 'Produce Shipper',
                    color: const Color(0xFF059669), // Green
                    icon: Icons.eco,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTenantPill({
    required String id,
    required String name,
    required String type,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = activeTenantId == id;
    return InkWell(
      onTap: () => onTenantChanged(id),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.12),
            width: isSelected ? 1.6 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? color : const Color(0xFF94A3B8)),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.4) : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 9,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
