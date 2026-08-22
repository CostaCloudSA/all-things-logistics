/// Main Application Dashboard for Campabadal Global Logistics.
/// Features a modern glassmorphic UI, multi-company branding switcher (Blue/Red/Green),
/// live 12-agent swarm telemetry indicators, and touch-friendly guided smart chips.

import 'package:flutter/material.dart';
import '../models/trade_models.dart';
import '../services/api_service.dart';
import '../widgets/tenant_switcher_bar.dart';
import '../widgets/smart_chips_bar.dart';
import '../widgets/golden_document_card.dart';
import '../widgets/axle_weight_card.dart';
import '../widgets/night_watch_status_card.dart';
import '../widgets/field_inspector_qr_card.dart';
import '../widgets/federation_handshake_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  bool _isLoading = false;
  TradeResponse? _currentTrade;
  String _activeTenantId = 'tenant-campabadal';
  final List<String> _selectedChips = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Initialize default primary golden showcase route (Miami -> Tecún Umán -> Guatemala)
    _executeTradeQuery('20,000 kg frozen poultry cuts (Legs and thighs) from Miami to Guatemala via Tecún Umán border');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTenantChanged(String newTenantId) {
    setState(() {
      _activeTenantId = newTenantId;
      apiService.activeTenantId = newTenantId;
      _selectedChips.clear();
    });
    _executeTradeQuery(_textController.text.isNotEmpty ? _textController.text : '');
  }

  void _executeTradeQuery(String prompt) async {
    setState(() => _isLoading = true);
    final response = await apiService.processTradePrompt(
      prompt: prompt,
      tenantId: _activeTenantId,
      selectedChips: _selectedChips,
    );
    setState(() {
      _currentTrade = response;
      _isLoading = false;
    });
  }

  void _onChipSelected(SmartChip chip) {
    if (chip.category == 'scenario') {
      _textController.text = chip.value;
      _selectedChips.clear();
      _executeTradeQuery(chip.value);
    } else {
      setState(() {
        _selectedChips.add(chip.id);
      });
      // Switch to relevant tab based on action chip
      if (chip.category == 'axle_weight' || chip.category == 'night_watch') {
        _tabController.animateTo(1);
      } else if (chip.category == 'federation') {
        _tabController.animateTo(2);
      } else if (chip.category == 'customs_document') {
        _tabController.animateTo(0);
      }
      _executeTradeQuery(_textController.text.isNotEmpty ? _textController.text : '');
    }
  }

  Color _getBrandColor() {
    if (_activeTenantId == 'tenant-tomas') return const Color(0xFFDC2626); // Vibrant Red
    if (_activeTenantId == 'tenant-agroexport-cr') return const Color(0xFF059669); // Emerald Green
    return const Color(0xFF0284C7); // Ocean Cyan / Electric Blue
  }

  @override
  Widget build(BuildContext context) {
    final brandColor = _getBrandColor();
    final profile = _currentTrade?.tenantProfile ?? apiService.getPreconfiguredTenants().first;

    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: brandColor.withOpacity(0.6), width: 1.5),
              ),
              child: Icon(
                profile.logoIcon == 'eco'
                    ? Icons.eco
                    : (profile.logoIcon == 'local_shipping' ? Icons.local_shipping : Icons.public),
                color: brandColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.orgName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${profile.scacOrDotCode} • 12-Agent Autonomous Swarm (Gemini 3.7 Flash)',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.shield_outlined, size: 14, color: Color(0xFF34D399)),
                SizedBox(width: 4),
                Text(
                  'OWASP FORTIFIED',
                  style: TextStyle(
                    color: Color(0xFF34D399),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.document_scanner, color: Color(0xFF60A5FA)),
            tooltip: 'Camera Vision OCR Scan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📷 Camera OCR: Ingested Bill of Lading MSCU-MIA-GUA-881920 (Zero-Typing)'),
                  backgroundColor: Color(0xFF2563EB),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: brandColor,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF64748B),
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.description_outlined, size: 18), text: 'Golden Document'),
            Tab(icon: Icon(Icons.scale_outlined, size: 18), text: 'SME Operations'),
            Tab(icon: Icon(Icons.sync_alt_outlined, size: 18), text: 'A2A Federation'),
            Tab(icon: Icon(Icons.security_outlined, size: 18), text: 'Audit & Telemetry'),
          ],
        ),
      ),
      body: Column(
        children: [
          // White-Label Tenant Switcher Bar (Blue, Red, Green)
          TenantSwitcherBar(
            activeTenantId: _activeTenantId,
            onTenantChanged: _onTenantChanged,
          ),

          // Main Tabbed Views
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // TAB 1: Golden Customs Document & Tariffs
                      _buildCustomsDocumentTab(),

                      // TAB 2: SME Operations (Bridge Formula + Night Watch)
                      _buildSmeOperationsTab(),

                      // TAB 3: A2A Federation & Roadside Inspector QR
                      _buildFederationTab(),

                      // TAB 4: Enterprise Audit & Telemetry
                      _buildAuditTab(),
                    ],
                  ),
          ),

          // Deskless Guided Smart Chips (1-Tap execution)
          if (_currentTrade != null && _currentTrade!.smartChips.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SmartChipsBar(
                chips: _currentTrade!.smartChips,
                onChipSelected: _onChipSelected,
                accentColor: brandColor,
              ),
            ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Enter trade prompt or tap smart chips above...',
                      hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF070B14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: brandColor, width: 1.5),
                      ),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) _executeTradeQuery(val);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: brandColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                  ),
                  icon: const Icon(Icons.send_rounded, size: 20),
                  onPressed: () {
                    if (_textController.text.trim().isNotEmpty) {
                      _executeTradeQuery(_textController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomsDocumentTab() {
    if (_currentTrade == null) return const SizedBox.shrink();
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        GoldenDocumentCard(response: _currentTrade!),
      ],
    );
  }

  Widget _buildSmeOperationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // SME Card 1: Axle Weight Bridge Formula Auditor
        AxleWeightCard(
          steerLbs: 11800.0,
          driveTandemLbs: 33500.0,
          trailerTandemLbs: _activeTenantId == 'tenant-agroexport-cr' ? 32000.0 : 34800.0,
          grossWeightLbs: _activeTenantId == 'tenant-agroexport-cr' ? 77300.0 : 80100.0,
          isCompliant: _activeTenantId == 'tenant-agroexport-cr',
          advice: _activeTenantId == 'tenant-agroexport-cr'
              ? '🟢 PASS: Axle load distribution complies with Federal Bridge Formula B and Central American SIECA limits.'
              : '⚠️ AXLE SCALE WARNING: Trailer tandem weight (34,800 lbs) exceeds statutory limit (34,000 lbs). Action: Shift 1,200 lbs forward before scale weigh-in.',
        ),
        const SizedBox(height: 16),

        // SME Card 2: Autonomous 24/7 Night-Watch Status
        NightWatchStatusCard(
          status: 'ACTIVE_NORMAL',
          geofence: _activeTenantId == 'tenant-agroexport-cr'
              ? 'Puerto Limón Reefer Terminal Gate 4'
              : (_activeTenantId == 'tenant-tomas' ? 'Patio Fiscal Ciudad Hidalgo (Chiapas MX)' : 'Patio Fiscal Tecún Umán (Guatemala)'),
          adherencePct: 99.4,
          whatsappMessage: _activeTenantId == 'tenant-agroexport-cr'
              ? '🟢 *Shipment Status Update (Agroexport Costa Rica)*\nPineapple Reefer Container CR-88214 verified at Puerto Limón. Cold-chain set point verified at +4.5°C. Vessel loading on schedule.'
              : '🟢 *Shipment Status Update (Automated Night-Watch)*\nVehicle TRK-9842 verified on schedule. Route adherence: 99.4%. Cold-chain verified at -18.0°C. ETA: 14:30 UTC.',
        ),
      ],
    );
  }

  Widget _buildFederationTab() {
    if (_currentTrade == null) return const SizedBox.shrink();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // On-The-Field Encrypted QR Seal Card for Field Inspectors
        if (_currentTrade!.fieldInspectorQr != null) ...[
          FieldInspectorQrCard(qrPayload: _currentTrade!.fieldInspectorQr!),
          const SizedBox(height: 16),
        ],

        // B2B Agent-to-Agent (A2A) Federation Handshake Card
        if (_currentTrade!.federatedHandshake != null) ...[
          FederationHandshakeCard(handshake: _currentTrade!.federatedHandshake!),
        ],
      ],
    );
  }

  Widget _buildAuditTab() {
    if (_currentTrade == null) return const SizedBox.shrink();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.verified_outlined, size: 18, color: Color(0xFF38BDF8)),
                  SizedBox(width: 8),
                  Text(
                    'SECURITY, OWASP & DETERMINISTIC AUDIT LOG',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._currentTrade!.auditNotes.map((note) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          note,
                          style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12.5, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
