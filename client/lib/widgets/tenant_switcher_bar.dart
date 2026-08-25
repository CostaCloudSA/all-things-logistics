/// White-Label Enterprise Tenant Switcher Bar.
/// Allows instant switching between Campabadal Global (Blue), Transportes Tomas (Red),
/// Agroexport Costa Rica (Green), and Naviera Don Jorge (Gold/Navy).
/// Operates as both 1-tap horizontal pills and interactive dropdown menus.

import 'package:flutter/material.dart';

class TenantData {
  final String id;
  final String name;
  final String type;
  final String scac;
  final String corridor;
  final Color color;
  final IconData icon;

  const TenantData({
    required this.id,
    required this.name,
    required this.type,
    required this.scac,
    required this.corridor,
    required this.color,
    required this.icon,
  });
}

class TenantSwitcherBar extends StatelessWidget {
  final String activeTenantId;
  final Function(String) onTenantChanged;

  static const List<TenantData> tenants = [
    TenantData(
      id: 'tenant-campabadal',
      name: 'Campabadal Global',
      type: '3PL Forwarder',
      scac: 'SCAC: CPBD • EIN-82-9918231',
      corridor: 'Miami, US -> Tecún Umán, GT',
      color: Color(0xFF0284C7),
      icon: Icons.public,
    ),
    TenantData(
      id: 'tenant-tomas',
      name: 'Transportes Tomas',
      type: 'Motor Carrier MX-GT',
      scac: 'USDOT: 3921104 • SCT-MX-99421',
      corridor: 'Cd. Hidalgo, MX -> Tecún Umán, GT',
      color: Color(0xFFDC2626),
      icon: Icons.local_shipping,
    ),
    TenantData(
      id: 'tenant-agroexport-cr',
      name: 'Agroexport Costa Rica',
      type: 'Produce Shipper',
      scac: 'MAG-CR-88214 • PROCOMER',
      corridor: 'San José, CR -> PortMiami, US',
      color: Color(0xFF059669),
      icon: Icons.eco,
    ),
    TenantData(
      id: 'tenant-naviera-don-jorge',
      name: 'Naviera Don Jorge',
      type: 'Ocean Carrier / Terminal',
      scac: 'SCAC: NDJ-992140 • IMO-9921408',
      corridor: 'Moín Container Terminal -> Gulf Ports',
      color: Color(0xFF3B82F6),
      icon: Icons.directions_boat,
    ),
  ];

  const TenantSwitcherBar({
    Key? key,
    required this.activeTenantId,
    required this.onTenantChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeTenant = tenants.firstWhere(
      (t) => t.id == activeTenantId,
      orElse: () => tenants.first,
    );

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
          // Enterprise Logo Icon & Title
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.corporate_fare, size: 16, color: activeTenant.color),
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
          const SizedBox(width: 10),

          // Dropdown Switcher Button (Useful for Mobile/Tablets or Quick Menu Selection)
          _buildDropdownMenuButton(context, activeTenant),

          const SizedBox(width: 8),

          // Horizontal 1-Tap Pill Row
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: tenants.map((tenant) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildTenantPill(context, tenant),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownMenuButton(BuildContext context, TenantData activeTenant) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: const Color(0xFF0F172A),
      ),
      child: PopupMenuButton<String>(
        tooltip: 'Switch Enterprise Persona via Dropdown',
        onSelected: onTenantChanged,
        color: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
        offset: const Offset(0, 36),
        itemBuilder: (context) {
          return tenants.map((t) {
            final isCurrent = t.id == activeTenantId;
            return PopupMenuItem<String>(
              value: t.id,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: t.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: t.color.withOpacity(0.4)),
                      ),
                      child: Icon(t.icon, size: 18, color: t.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                t.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent ? Colors.white : const Color(0xFFE2E8F0),
                                ),
                              ),
                              if (isCurrent) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: t.color.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'ACTIVE',
                                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${t.type} • ${t.scac}',
                            style: TextStyle(fontSize: 10, color: t.color.withOpacity(0.9), fontWeight: FontWeight.w600),
                          ),
                          Text(
                            t.corridor,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: activeTenant.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: activeTenant.color.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.unfold_more_rounded, size: 14, color: activeTenant.color),
              const SizedBox(width: 4),
              const Text(
                'Menu ▾',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTenantPill(BuildContext context, TenantData tenant) {
    final isSelected = activeTenantId == tenant.id;
    return InkWell(
      onTap: () => onTenantChanged(tenant.id),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? tenant.color.withOpacity(0.2) : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? tenant.color : Colors.white.withOpacity(0.12),
            width: isSelected ? 1.6 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: tenant.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tenant.icon, size: 14, color: isSelected ? tenant.color : const Color(0xFF94A3B8)),
            const SizedBox(width: 6),
            Text(
              tenant.name,
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
                color: isSelected ? tenant.color.withOpacity(0.4) : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tenant.type,
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

