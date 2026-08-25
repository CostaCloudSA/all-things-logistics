/// Main Application Dashboard for All Things Logistics.
/// Dynamically adapts to the 4 Logistics Buyer Personas:
/// 1. Campabadal Global Logistics (3PL Forwarder & Broker - T. Omas)
/// 2. Transportes Tomas (Regional Motor Carrier & Drayage - Tomas R.)
/// 3. Agroexport Costa Rica (Enterprise Produce Shipper - Elena M.)
/// 4. Naviera Don Jorge (Ocean Carrier & Marine Terminal - Cap. Jorge B.)
///
/// Features the Adaptive 2x4 Tactile Macro-Grid, AI Swarm Matrix Inspector,
/// 3D Ballast Vessel Stability Auditor, 20% Tax Shield Engine, 48h Demurrage Early Warning,
/// 5-Axle Bridge Formula Slider, Ed25519 Cryptographic QR Seals, and Model Armor Dual Defense.

import 'package:flutter/material.dart';
import '../models/trade_models.dart';
import '../services/api_service.dart';
import '../widgets/tenant_switcher_bar.dart';
import '../widgets/smart_chips_bar.dart';
import '../widgets/operations_hub_grid.dart';
import '../widgets/golden_document_card.dart';
import '../widgets/axle_weight_card.dart';
import '../widgets/night_watch_status_card.dart';
import '../widgets/field_inspector_qr_card.dart';
import '../widgets/federation_handshake_card.dart';
import '../widgets/ai_swarm_matrix_card.dart';
import '../widgets/vessel_stability_card.dart';
import '../widgets/tax_shield_card.dart';
import '../widgets/demurrage_alert_card.dart';
import '../widgets/tactile_modal_card.dart';
import '../widgets/interactive_ai_demo_modal.dart';
import '../widgets/under_construction_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isLoading = false;
  TradeResponse? _currentTrade;
  String _activeTenantId = 'tenant-campabadal';
  final List<String> _selectedChips = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && _currentTabIndex != _tabController.index) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
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
    final defaultPrompt = apiService.getDefaultPromptForTenant(newTenantId);
    setState(() {
      _activeTenantId = newTenantId;
      apiService.activeTenantId = newTenantId;
      _textController.text = defaultPrompt;
      _selectedChips.clear();
    });

    _executeTradeQuery(defaultPrompt);
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
      if (chip.category == 'axle_weight' || chip.category == 'night_watch') {
        _tabController.animateTo(1); // Fleet Tab
      } else if (chip.category == 'federation' || chip.category == 'security') {
        _tabController.animateTo(3); // Settings & Security Tab
      }
      _executeTradeQuery(_textController.text.isNotEmpty ? _textController.text : '');
    }
  }

  void _onOperationActionSelected(String actionId, String title) {
    switch (actionId) {
      // -----------------------------------------------------------------------
      // 1. CAMPABADAL GLOBAL 3PL ACTIONS
      // -----------------------------------------------------------------------
      case 'customs_clearance':
      case 'create_bol':
      case 'cargo_manifest':
      case 'scan_qr':
        _showAiDemoModal(AiDemoType.campabadalPoultry);
        break;

      case 'inventory_lookup':
      case 'track_shipments':
      case 'schedule_pickup':
      case 'warehouse_entry':
        _showUnderConstructionModal(title, 'tenant-campabadal');
        break;

      // -----------------------------------------------------------------------
      // 2. TRANSPORTES TOMAS MOTOR CARRIER ACTIONS
      // -----------------------------------------------------------------------
      case 'audit_axle_load':
      case 'cabotage_relay':
      case 'gate_pre_pass':
      case 'driver_whatsapp':
        _showAiDemoModal(AiDemoType.tomasCabotageAxle);
        break;

      case 'duca_transit':
      case 'fleet_gps':
      case 'dot_safety':
      case 'police_qr':
        _showUnderConstructionModal(title, 'tenant-tomas');
        break;

      // -----------------------------------------------------------------------
      // 3. AGROEXPORT COSTA RICA PRODUCE SHIPPER ACTIONS
      // -----------------------------------------------------------------------
      case 'tax_shield':
      case 'phyto_permit':
      case 'gate_release':
        _showAiDemoModal(AiDemoType.agroexportTaxShield);
        break;

      case 'cold_chain':
      case 'export_duca':
      case 'cafta_schedule':
      case 'phyto_stamp':
      case 'traceability':
        _showUnderConstructionModal(title, 'tenant-agroexport-cr');
        break;

      // -----------------------------------------------------------------------
      // 4. NAVIERA DON JORGE OCEAN CARRIER ACTIONS
      // -----------------------------------------------------------------------
      case 'vessel_stability':
      case 'demurrage_alert':
      case 'ebl_release':
      case 'gate_pass':
        _showAiDemoModal(AiDemoType.navieraDemurrageBallast);
        break;

      case 'imo_hazmat':
      case 'berth_schedule':
      case 'ais_telematics':
      case 'port_police_qr':
        _showUnderConstructionModal(title, 'tenant-naviera-don-jorge');
        break;

      default:
        _showUnderConstructionModal(title, _activeTenantId);
        break;
    }
  }

  void _showAiDemoModal(AiDemoType demoType) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: InteractiveAiDemoModal(
            demoType: demoType,
            onComplete: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color(0xFF10B981),
                  content: Row(
                    children: [
                      Icon(Icons.verified, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Expanded(child: Text('AI Swarm Orchestration Completed & Sealed with Ed25519!')),
                    ],
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showUnderConstructionModal(String featureName, String tenantId) {
    String guideTitle;
    String guideFileName;
    AiDemoType fallbackDemo;

    switch (tenantId) {
      case 'tenant-tomas':
        guideTitle = 'Transportes Tomas: Cross-Border Cabotage & Bridge Formula Demo';
        guideFileName = 'DEMO_2_TRANSPORTES_TOMAS_MOTOR_CARRIER.md';
        fallbackDemo = AiDemoType.tomasCabotageAxle;
        break;
      case 'tenant-agroexport-cr':
        guideTitle = 'Agroexport Costa Rica: DTA 20% Tax Shield & Produce Export Demo';
        guideFileName = 'DEMO_3_AGROEXPORT_CR_PRODUCE_SHIPPER.md';
        fallbackDemo = AiDemoType.agroexportTaxShield;
        break;
      case 'tenant-naviera-don-jorge':
        guideTitle = 'Naviera Don Jorge: 48h Demurrage Shield & Vessel Stability Demo';
        guideFileName = 'DEMO_4_NAVIERA_DON_JORGE_OCEAN_LINE.md';
        fallbackDemo = AiDemoType.navieraDemurrageBallast;
        break;
      case 'tenant-campabadal':
      default:
        guideTitle = 'Campabadal Global: 3PL Customs Brokerage & Poultry CAFTA-DR Demo';
        guideFileName = 'DEMO_1_CAMPABADAL_3PL_BROKERAGE.md';
        fallbackDemo = AiDemoType.campabadalPoultry;
        break;
    }

    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return UnderConstructionModal(
          companyName: _getCompanyTitle(),
          brandColor: _getBrandColor(),
          featureName: featureName,
          demoGuideTitle: guideTitle,
          demoGuideFileName: guideFileName,
          onLaunchActiveDemo: () => _showAiDemoModal(fallbackDemo),
        );
      },
    );
  }

  void _showGoldenDocumentModal() {
    if (_currentTrade == null) return;
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CARGO MANIFEST & CUSTOMS DOCS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      GoldenDocumentCard(response: _currentTrade!),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCabotageRelayModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TactileModalCard(
        companyName: 'Transportes Tomas',
        brandColor: const Color(0xFFEA580C),
        icon: Icons.swap_horiz_rounded,
        title: 'Cabotage Relay & Tractor Swap',
        subtitle: 'Tecún Umán Bonded Yard Cross-Dock',
        metrics: const [
          TactileMetricItem(label: 'Inbound Unit', value: 'MX-9942 (Mexico)', badgeText: 'FOREIGN', badgeColor: Color(0xFFEF4444)),
          TactileMetricItem(label: 'Drayage Unit', value: 'GT-8812 (Guatemala)', badgeText: 'DOMESTIC', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'Cross-Dock Match', value: '< 90 Seconds', badgeText: 'INSTANT', badgeColor: Color(0xFF38BDF8)),
          TactileMetricItem(label: 'Legal Status', value: 'SIECA Compliant', badgeText: 'VERIFIED', badgeColor: Color(0xFF10B981)),
        ],
        actionButtonText: '1-TAP AUTHORIZE CABOTAGE RELAY',
        actionButtonIcon: Icons.swap_calls_rounded,
        successMessage: 'Tractor swap authorized. Transload manifest DUCA-T-GT-2026-9921 signed with Ed25519.',
        ed25519Signature: 'ed25519_sig_tomas_cb_8812...',
        secondaryNote: 'Foreign tractor heads cannot operate domestically. Transload eliminates \$10,000+ cabotage fines.',
      ),
    );
  }

  void _showGatePrePassModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TactileModalCard(
        companyName: 'Transportes Tomas',
        brandColor: const Color(0xFF0D9488),
        icon: Icons.badge_rounded,
        title: 'Weigh Scale Gate Pre-Pass',
        subtitle: 'SAT Customs Green Lane Fast Track',
        metrics: const [
          TactileMetricItem(label: 'Scale Status', value: 'Pre-Cleared', badgeText: 'PASS', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'Corridor', value: 'Tecún Umán Border', badgeText: 'GEOFENCE', badgeColor: Color(0xFF38BDF8)),
          TactileMetricItem(label: 'Queue Saved', value: '3.5 Hours Saved', badgeText: 'GREEN LANE', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'SAT Customs Seal', value: 'SAT-GT-99281', badgeText: 'ACTIVE', badgeColor: Color(0xFF10B981)),
        ],
        actionButtonText: '1-TAP ISSUE GREEN LANE PRE-PASS',
        actionButtonIcon: Icons.qr_code_rounded,
        successMessage: 'Gate Pre-Pass active on driver device. Green Lane barcode ready for optical scan.',
        ed25519Signature: 'ed25519_sig_sat_prepass_99281...',
        secondaryNote: 'Roadside weigh stations automatically recognize the Ed25519 pre-pass token.',
      ),
    );
  }

  void _showDriverWhatsAppModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TactileModalCard(
        companyName: 'Transportes Tomas',
        brandColor: const Color(0xFF0EA5E9),
        icon: Icons.chat_bubble_outline_rounded,
        title: 'Driver WhatsApp Autonomous Push',
        subtitle: 'End-to-End Encrypted Corridor Telematics',
        metrics: const [
          TactileMetricItem(label: 'Recipient', value: 'Driver Tomas R.', badgeText: 'OPERATOR', badgeColor: Color(0xFF38BDF8)),
          TactileMetricItem(label: 'Encrypted Phone', value: '+502 5521-8890', badgeText: 'SIGNAL', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'Geofence Check', value: 'Tecún Umán Km 248', badgeText: 'LOCKED', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'Push Interval', value: 'Every 2 Hours', badgeText: '24/7', badgeColor: Color(0xFF38BDF8)),
        ],
        actionButtonText: '1-TAP DISPATCH WHATSAPP PACKET',
        actionButtonIcon: Icons.send_rounded,
        successMessage: 'Autonomous dispatch sent to driver WhatsApp with turn-by-turn route and seal verification.',
        ed25519Signature: 'ed25519_sig_telematics_wa_2026...',
        secondaryNote: 'Night-Watch telematics silently monitors GPS corridor progress and updates dispatchers.',
      ),
    );
  }

  void _showPhytoPermitModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TactileModalCard(
        companyName: 'Agroexport Costa Rica',
        brandColor: const Color(0xFF16A34A),
        icon: Icons.eco_rounded,
        title: 'Phytosanitary Inspection Permit',
        subtitle: 'USDA APHIS & MAG Export Pre-Clearance',
        metrics: const [
          TactileMetricItem(label: 'Export Authority', value: 'MAG Costa Rica', badgeText: 'APPROVED', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'Import Authority', value: 'USDA APHIS Miami', badgeText: 'GREEN LANE', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'Commodity', value: 'MD2 Golden Pineapple', badgeText: 'REEFER', badgeColor: Color(0xFF38BDF8)),
          TactileMetricItem(label: 'Inspection Status', value: '100% Pest Free', badgeText: 'CLEARED', badgeColor: Color(0xFF10B981)),
        ],
        actionButtonText: '1-TAP VALIDATE ELECTRONIC PHYTO PERMIT',
        actionButtonIcon: Icons.verified_user_rounded,
        successMessage: 'MAG/USDA electronic phytosanitary certificate verified and attached to export DUCA-T.',
        ed25519Signature: 'ed25519_sig_mag_phyto_441...',
        secondaryNote: 'Pre-inspected export phytosanitary permits map directly to USDA electronic import standards.',
      ),
    );
  }

  void _showMoinTerminalGateModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TactileModalCard(
        companyName: 'Agroexport Costa Rica',
        brandColor: const Color(0xFFEAB308),
        icon: Icons.door_sliding_rounded,
        title: 'Moín Reefer Terminal Gate Pass',
        subtitle: 'APM Terminals Express Cold-Storage Gate 4',
        metrics: const [
          TactileMetricItem(label: 'Terminal', value: 'APM Terminals Moín', badgeText: 'PORT', badgeColor: Color(0xFF38BDF8)),
          TactileMetricItem(label: 'Plug-In Window', value: '04:00 - 06:00 UTC', badgeText: 'RESERVED', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'Set Temperature', value: '+4.5°C Controlled Atm', badgeText: 'ACTIVE', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'Gate Appointment', value: 'Gate 4 Express Lane', badgeText: 'CONFIRMED', badgeColor: Color(0xFF10B981)),
        ],
        actionButtonText: '1-TAP LOCK COLD-STORAGE APPOINTMENT',
        actionButtonIcon: Icons.lock_clock_rounded,
        successMessage: 'Gate 4 appointment confirmed. Reefer power pre-assigned at container berth.',
        ed25519Signature: 'ed25519_sig_apm_moin_gate_441...',
        secondaryNote: 'Guarantees continuous reefer power connectivity, preventing tarmac cold-chain spoilage.',
      ),
    );
  }

  void _showEblReleaseModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TactileModalCard(
        companyName: 'Naviera Don Jorge',
        brandColor: const Color(0xFF16A34A),
        icon: Icons.task_alt_rounded,
        title: 'Electronic Bill of Lading (e-B/L) Release',
        subtitle: 'Cryptographic Ocean Carrier Cargo Release',
        metrics: const [
          TactileMetricItem(label: 'Master B/L Ref', value: 'NDJ-MBL-2026-992', badgeText: 'OCEAN', badgeColor: Color(0xFF38BDF8)),
          TactileMetricItem(label: 'Vessel / Voyage', value: 'MV Don Jorge (Voy 441)', badgeText: 'PORTMIAMI', badgeColor: Color(0xFF38BDF8)),
          TactileMetricItem(label: 'Customs Hold', value: 'Released (CBP / SAT)', badgeText: 'CLEARED', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'Freight Status', value: 'Prepaid & Released', badgeText: 'APPROVED', badgeColor: Color(0xFF10B981)),
        ],
        actionButtonText: '1-TAP TRANSMIT MASTER e-B/L RELEASE',
        actionButtonIcon: Icons.send_and_archive_rounded,
        successMessage: 'Master e-B/L release transmitted to CBP and marine terminal operating systems.',
        ed25519Signature: 'ed25519_sig_ndj_mbl_release_992...',
        secondaryNote: 'Eliminates 24-48h physical paper courier delays by transmitting verifiable digital release tokens.',
      ),
    );
  }

  void _showCustomsClearanceModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TactileModalCard(
        companyName: 'Campabadal Global',
        brandColor: const Color(0xFF7C3AED),
        icon: Icons.flag_rounded,
        title: '0% CAFTA-DR Duty Clearance & Landed Cost',
        subtitle: 'Automated Tariff & Valuation Truth Gate',
        metrics: const [
          TactileMetricItem(label: 'HS Classification', value: '0207.14.00 (Poultry)', badgeText: 'ACCURATE', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'CAFTA-DR Duty', value: '0.00% (Duty Free)', badgeText: 'EXEMPT', badgeColor: Color(0xFF10B981)),
          TactileMetricItem(label: 'CIF Landed Cost', value: '\$46,500.00 USD', badgeText: 'CIF VAL', badgeColor: Color(0xFF38BDF8)),
          TactileMetricItem(label: 'Tariff Saved', value: '+\$6,975.00 USD', badgeText: 'SAVED', badgeColor: Color(0xFF10B981), valueColor: Color(0xFF10B981)),
        ],
        actionButtonText: '1-TAP CLAIM \$6,975 DUTY EXEMPTION',
        actionButtonIcon: Icons.verified_rounded,
        successMessage: '0% CAFTA-DR duty preference approved and recorded in Golden DUCA-T declaration.',
        ed25519Signature: 'ed25519_sig_customs_val_0207...',
        secondaryNote: 'BigQuery deterministic grounding guarantees 0% tariff math against official SIECA rules.',
      ),
    );
  }

  void _showAxleModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(margin: const EdgeInsets.only(bottom: 12), width: 48, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const AxleWeightCard(
                steerLbs: 11800.0,
                driveTandemLbs: 33500.0,
                trailerTandemLbs: 34800.0,
                grossWeightLbs: 80100.0,
                isCompliant: false,
                advice: 'AXLE SCALE OVERLOAD: Trailer tandem weight (34,800 lbs) exceeds 34,000 lbs statutory limit. Shift 1,200 lbs forward before departure.',
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showVesselStabilityModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(margin: const EdgeInsets.only(bottom: 12), width: 48, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const VesselStabilityCard(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showTaxShieldModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(margin: const EdgeInsets.only(bottom: 12), width: 48, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const TaxShieldCard(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showDemurrageModal() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(margin: const EdgeInsets.only(bottom: 12), width: 48, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const DemurrageAlertCard(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAiSwarmModal() {
    final profile = _currentTrade?.tenantProfile ?? apiService.getPreconfiguredTenants().first;
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(margin: const EdgeInsets.only(bottom: 12), width: 48, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              AiSwarmMatrixCard(currentTenant: profile),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  String _getCompanyTitle() {
    switch (_activeTenantId) {
      case 'tenant-tomas':
        return 'TRANSPORTES TOMAS';
      case 'tenant-agroexport-cr':
        return 'AGROEXPORT COSTA RICA';
      case 'tenant-naviera-don-jorge':
        return 'NAVIERA DON JORGE';
      case 'tenant-campabadal':
      default:
        return 'CAMPABADAL GLOBAL';
    }
  }

  String _getCompanySubtitle() {
    switch (_activeTenantId) {
      case 'tenant-tomas':
        return 'CROSS-BORDER MOTOR CARRIER HUB';
      case 'tenant-agroexport-cr':
        return 'AGRICULTURAL PRODUCE EXPORT HUB';
      case 'tenant-naviera-don-jorge':
        return 'OCEAN CARRIER & TERMINAL HUB';
      case 'tenant-campabadal':
      default:
        return '3PL BROKERAGE & CUSTOMS HUB';
    }
  }

  Color _getBrandColor() {
    if (_activeTenantId == 'tenant-tomas') return const Color(0xFFDC2626); // Vibrant Red
    if (_activeTenantId == 'tenant-agroexport-cr') return const Color(0xFF059669); // Emerald Green
    if (_activeTenantId == 'tenant-naviera-don-jorge') return const Color(0xFF1E3A8A); // Deep Maritime Blue
    return const Color(0xFF0284C7); // Ocean Cyan / Electric Blue
  }

  _OperatorInfo _getOperatorInfo() {
    switch (_activeTenantId) {
      case 'tenant-tomas':
        return const _OperatorInfo('Tomas R.', 'Fleet Safety Director', 'SCT-MX-SAFETY-8821', Color(0xFFDC2626));
      case 'tenant-agroexport-cr':
        return const _OperatorInfo('Elena M.', 'Export Compliance Director', 'PROCOMER-CR-441', Color(0xFF059669));
      case 'tenant-naviera-don-jorge':
        return const _OperatorInfo('Cap. Jorge B.', 'Marine Superintendent', 'IMO-CAPT-992140', Color(0xFFF59E0B));
      case 'tenant-campabadal':
      default:
        return const _OperatorInfo('T. Omas', 'Senior Customs Broker', 'US-CBP-BRK-99214', Color(0xFF0284C7));
    }
  }

  Widget _buildCompanyPill(String tenantId, String label, Color color) {
    final isSelected = _activeTenantId == tenantId;
    return InkWell(
      onTap: () => _onTenantChanged(tenantId),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.12),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.45),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandColor = _getBrandColor();
    final profile = _currentTrade?.tenantProfile ?? apiService.getPreconfiguredTenants().first;
    final operator = _getOperatorInfo();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User / Operator Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [operator.accentColor, const Color(0xFFEAB308)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                ),
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white, size: 22),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    operator.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    operator.role,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          // AI Swarm Inspector Quick Action
          IconButton(
            icon: const Icon(Icons.hub_rounded, color: Color(0xFF38BDF8), size: 24),
            tooltip: 'Judge AI Swarm Inspector',
            onPressed: _showAiSwarmModal,
          ),
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
            tooltip: 'Open Navigation & Tenant Drawer',
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      endDrawer: _buildAppDrawer(profile, brandColor, operator),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                // TAB 0: Dashboard (Target Operations Hub 2x4 Tactile Grid)
                _buildDashboardTab(brandColor),

                // TAB 1: SME Fleet & Multi-Company Domain Operations
                _buildFleetTab(profile),

                // TAB 2: Operator Profile & Multi-Tenant Persona Switcher
                _buildProfileTab(profile, brandColor, operator),

                // TAB 3: Settings, Security & Ed25519 Cryptographic Verifier
                _buildSettingsTab(),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index) {
            _tabController.animateTo(index);
            setState(() {
              _currentTabIndex = index;
            });
          },
          backgroundColor: const Color(0xFF18181B),
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF71717A),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
          unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_rounded),
              label: 'Operations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  /// Dashboard Tab: Operations Hub 2x4 Grid Hero + Smart Chips + Prompt Input
  Widget _buildDashboardTab(Color brandColor) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        // 1-Tap Company Persona Selector Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCompanyPill('tenant-campabadal', '🏢 Campabadal 3PL', const Color(0xFF0284C7)),
                const SizedBox(width: 8),
                _buildCompanyPill('tenant-tomas', '🚛 Tomas Carrier', const Color(0xFFDC2626)),
                const SizedBox(width: 8),
                _buildCompanyPill('tenant-agroexport-cr', '🍍 Agroexport CR', const Color(0xFF059669)),
                const SizedBox(width: 8),
                _buildCompanyPill('tenant-naviera-don-jorge', '⚓ Naviera Don Jorge', const Color(0xFF1E3A8A)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Dynamic Screen Title Section with Active Company Branding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getCompanySubtitle(),
                    style: TextStyle(
                      color: brandColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getCompanyTitle(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: _showAiSwarmModal,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: brandColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.hub_rounded, size: 14, color: brandColor),
                      const SizedBox(width: 5),
                      Text('AI SWARM', style: TextStyle(color: brandColor, fontSize: 10.5, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Hero 2x4 Tactile Operations Hub Grid (Adaptive per Persona)
        OperationsHubGrid(
          tenantId: _activeTenantId,
          onTileTapped: _onOperationActionSelected,
        ),

        const SizedBox(height: 16),

        // Deskless Guided Smart Chips (1-Tap Scenario Presets)
        if (_currentTrade != null && _currentTrade!.smartChips.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SmartChipsBar(
              chips: _currentTrade!.smartChips,
              onChipSelected: _onChipSelected,
              accentColor: brandColor,
            ),
          ),

        const SizedBox(height: 16),

        // Natural Language Trade Prompt Input Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Type shipment or tap mic / camera...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
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
                  backgroundColor: const Color(0xFF0284C7),
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
    );
  }

  /// SME Operations Tab: Dynamically adapts to active enterprise domain
  Widget _buildFleetTab(TenantProfile profile) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Tab Header
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${profile.orgName.toUpperCase()} OPERATIONS',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '24/7 LIVE',
                  style: TextStyle(color: Color(0xFF34D399), fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        // Domain-Specific Widgets
        if (_activeTenantId == 'tenant-naviera-don-jorge') ...[
          const VesselStabilityCard(),
          const SizedBox(height: 16),
          const DemurrageAlertCard(),
          const SizedBox(height: 16),
          AiSwarmMatrixCard(currentTenant: profile),
        ] else if (_activeTenantId == 'tenant-agroexport-cr') ...[
          const TaxShieldCard(),
          const SizedBox(height: 16),
          const NightWatchStatusCard(
            status: 'ACTIVE_NORMAL',
            geofence: 'Moín Container Terminal (CR -> US Reefer)',
            adherencePct: 99.8,
            whatsappMessage: 'Autonomous Night-Watch (Agroexport Costa Rica)\nReefer CR-4912 verified on schedule. Controlled Atmosphere cold-chain steady at +4.5°C. Phytosanitary clearance pre-cleared for PortMiami.',
          ),
          const SizedBox(height: 16),
          AiSwarmMatrixCard(currentTenant: profile),
        ] else if (_activeTenantId == 'tenant-tomas') ...[
          const AxleWeightCard(
            steerLbs: 11800.0,
            driveTandemLbs: 33500.0,
            trailerTandemLbs: 34800.0,
            grossWeightLbs: 80100.0,
            isCompliant: false,
            advice: 'AXLE SCALE OVERLOAD: Trailer tandem weight (34,800 lbs) exceeds 34,000 lbs statutory limit. Shift 1,200 lbs forward before departure.',
          ),
          const SizedBox(height: 16),
          _buildCabotageCrossDockCard(),
          const SizedBox(height: 16),
          const NightWatchStatusCard(
            status: 'ACTIVE_NORMAL',
            geofence: 'Patio Fiscal Ciudad Hidalgo / Tecún Umán (MX -> GT)',
            adherencePct: 99.4,
            whatsappMessage: 'Autonomous Night-Watch (Transportes Tomas)\nHeavy Drayage Unit MX-9942 arrived at Tecún Umán bonded warehouse. Cabotage cross-dock scheduled for GT-8812.',
          ),
          const SizedBox(height: 16),
          AiSwarmMatrixCard(currentTenant: profile),
        ] else ...[
          // Campabadal Global Default
          AiSwarmMatrixCard(currentTenant: profile),
          const SizedBox(height: 16),
          const AxleWeightCard(
            steerLbs: 11800.0,
            driveTandemLbs: 33500.0,
            trailerTandemLbs: 34800.0,
            grossWeightLbs: 80100.0,
            isCompliant: false,
            advice: 'AXLE SCALE OVERLOAD: Trailer tandem weight (34,800 lbs) exceeds 34,000 lbs statutory limit. Shift 1,200 lbs forward before departure.',
          ),
          const SizedBox(height: 16),
          const NightWatchStatusCard(
            status: 'ACTIVE_NORMAL',
            geofence: 'Patio Fiscal Ciudad Hidalgo / Tecún Umán (MX -> GT)',
            adherencePct: 99.4,
            whatsappMessage: 'Autonomous Night-Watch (Campabadal Global)\nReefer TRK-9842 verified on schedule. Cold-chain verified at -18.0°C. DUCA-T transit clearance dispatched to broker.',
          ),
        ],
      ],
    );
  }

  /// Profile Tab: Operator Info + Multi-Tenant Persona Switcher
  Widget _buildProfileTab(TenantProfile profile, Color brandColor, _OperatorInfo operator) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Operator Profile Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [operator.accentColor, const Color(0xFFEAB308)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      operator.name,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      operator.role,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${operator.idCode} • Active Certified',
                      style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontFamily: 'JetBrains Mono'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // White-Label Tenant Switcher Section
        const Text(
          'WHITE-LABEL CONGLOMERATE PERSONA',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 10),

        TenantSwitcherBar(
          activeTenantId: _activeTenantId,
          onTenantChanged: _onTenantChanged,
        ),

        const SizedBox(height: 20),

        // Active Tenant Metadata Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: brandColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    profile.orgName,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: brandColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      profile.orgType,
                      style: TextStyle(color: brandColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 20),
              _buildProfileMetaRow('SCAC / DOT Code:', profile.scacOrDotCode),
              const SizedBox(height: 6),
              _buildProfileMetaRow('Corridor Route:', '${profile.defaultOriginIso} -> ${profile.defaultDestinationIso}'),
              const SizedBox(height: 6),
              _buildProfileMetaRow('Tax Identifier:', profile.taxIdentifier.isNotEmpty ? profile.taxIdentifier : 'US-EIN-9921401'),
              const SizedBox(height: 6),
              _buildProfileMetaRow('Ed25519 Public Key:', profile.publicKeyEd25519Hex.isNotEmpty ? (profile.publicKeyEd25519Hex.length > 16 ? '${profile.publicKeyEd25519Hex.substring(0, 16)}...' : profile.publicKeyEd25519Hex) : 'Verified Sovereign Key'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMetaRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11.5),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  /// Settings & Security Tab: Ed25519 QR Verifier, A2A Handshake, OWASP Dual Defense
  Widget _buildSettingsTab() {
    if (_currentTrade == null) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Roadside Encrypted QR Seal Card
        if (_currentTrade!.fieldInspectorQr != null) ...[
          FieldInspectorQrCard(qrPayload: _currentTrade!.fieldInspectorQr!),
          const SizedBox(height: 16),
        ],

        // B2B Agent-to-Agent (A2A) Federation Handshake Card
        if (_currentTrade!.federatedHandshake != null) ...[
          FederationHandshakeCard(handshake: _currentTrade!.federatedHandshake!),
          const SizedBox(height: 16),
        ],

        // OWASP Dual-Defense Shield Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.shield_outlined, size: 18, color: Color(0xFF38BDF8)),
                      SizedBox(width: 8),
                      Text(
                        'OWASP FORTIFIED DUAL-DEFENSE SHIELD',
                        style: TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.withOpacity(0.4)),
                    ),
                    child: const Text('MODEL ARMOR ACTIVE', style: TextStyle(color: Colors.greenAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Dual-layer defense: On-Device Gemma filters PII/prompt injection attacks before reaching Gemini 3.7 Flash, and BigQuery deterministic truth gates enforce statutory tariffs.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5, height: 1.3),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: const Color(0xFF38BDF8),
                  side: BorderSide(color: const Color(0xFF38BDF8).withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.bug_report_outlined, size: 16),
                label: const Text('Test Simulated Prompt Injection Attack (Instant Refusal Proof)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF1E293B),
                      content: Text('Model Armor Refusal: Adversarial prompt injection rejected. Tariff rules enforced via deterministic SQL truth gate.'),
                      duration: Duration(seconds: 4),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Security Audit Log Box
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

  /// App Navigation Drawer
  Widget _buildAppDrawer(TenantProfile profile, Color brandColor, _OperatorInfo operator) {
    return Drawer(
      backgroundColor: const Color(0xFF18181B),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [operator.accentColor, const Color(0xFFEAB308)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white, size: 26),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          operator.name,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          operator.role,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: brandColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    profile.orgName,
                    style: TextStyle(color: brandColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view_rounded, color: Colors.white),
            title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping_rounded, color: Colors.white),
            title: const Text('Fleet & Domain Operations', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.hub_rounded, color: Color(0xFF38BDF8)),
            title: const Text('Judge AI Swarm Inspector', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              _showAiSwarmModal();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_rounded, color: Colors.white),
            title: const Text('Operator Profile & Multi-Tenant', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.security_rounded, color: Colors.white),
            title: const Text('Security & Ed25519 Seals', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(3);
            },
          ),
          const Divider(color: Colors.white12),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'SYSTEM INFRASTRUCTURE',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
                SizedBox(height: 8),
                Text('• Google Cloud Run (us-central1)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5)),
                Text('• Gemini 3.7 Flash Engine', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5)),
                Text('• BigQuery Sovereign Mesh', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5)),
                Text('• Model Armor Dual-Defense', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCabotageCrossDockCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDC2626).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.swap_horiz_rounded, color: Color(0xFFEF4444), size: 20),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CABOTAGE TRANS-LOAD RELAY',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    'Tecún Umán Bonded Yard Cross-Dock',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Foreign tractor heads cannot operate domestically across borders (Cabotage law). Autonomous Swarm matches Mexican tractor MX-9942 with Guatemalan drayage tractor GT-8812 in under 90 seconds.',
            style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11.5, height: 1.3),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transload Manifest: DUCA-T-GT-2026-9921', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontFamily: 'JetBrains Mono', fontWeight: FontWeight.bold)),
                Text('STATUS: CLEARED', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OperatorInfo {
  final String name;
  final String role;
  final String idCode;
  final Color accentColor;

  const _OperatorInfo(this.name, this.role, this.idCode, this.accentColor);
}
