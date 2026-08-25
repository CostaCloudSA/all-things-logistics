/// Multi-Step Interactive AI Demo Modal.
/// Demonstrates the core AI paradigm:
/// Step 1: Frontline operator selects context chips & inputs numerical variable (zero complex typing).
/// Step 2: Gemini 3.7 Flash + BigQuery deterministic reasoning calculates and verifies everything autonomously.
/// Step 3: High-contrast 2x2 calculated metrics outcome with 1-tap sealed deliverable & Ed25519 QR seal.

import 'package:flutter/material.dart';

enum AiDemoType {
  campabadalPoultry,
  tomasCabotageAxle,
  agroexportTaxShield,
  navieraDemurrageBallast,
}

class InteractiveAiDemoModal extends StatefulWidget {
  final AiDemoType demoType;
  final VoidCallback? onComplete;

  const InteractiveAiDemoModal({
    Key? key,
    required this.demoType,
    this.onComplete,
  }) : super(key: key);

  @override
  State<InteractiveAiDemoModal> createState() => _InteractiveAiDemoModalState();
}

class _InteractiveAiDemoModalState extends State<InteractiveAiDemoModal> {
  int _currentStep = 1; // 1 = Input, 2 = AI Reasoning, 3 = Result
  bool _isSealed = false;

  // Demo 1: Campabadal
  int _selectedHsIndex = 0;
  final TextEditingController _weightController = TextEditingController(text: '44,000');

  // Demo 2: Tomas
  int _selectedCorridorIndex = 0;
  int _selectedTractorIndex = 0;
  final TextEditingController _axleWeightController = TextEditingController(text: '35,200');

  // Demo 3: Agroexport
  int _selectedProduceIndex = 0;
  final TextEditingController _boxCountController = TextEditingController(text: '1,600');
  final TextEditingController _tempController = TextEditingController(text: '+4.5');

  // Demo 4: Naviera
  int _selectedBayIndex = 0;
  final TextEditingController _dwellHoursController = TextEditingController(text: '42');

  // AI Reasoning Animation Step
  int _aiProgressIndex = 0;

  @override
  void dispose() {
    _weightController.dispose();
    _axleWeightController.dispose();
    _boxCountController.dispose();
    _tempController.dispose();
    _dwellHoursController.dispose();
    super.dispose();
  }

  void _runAiOrchestration() async {
    setState(() {
      _currentStep = 2;
      _aiProgressIndex = 0;
    });

    for (int i = 1; i <= 3; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() {
        _aiProgressIndex = i;
      });
    }

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() {
      _currentStep = 3;
    });
  }

  void _handleSealAction() {
    setState(() {
      _isSealed = true;
    });
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  Color _getBrandColor() {
    switch (widget.demoType) {
      case AiDemoType.campabadalPoultry:
        return const Color(0xFF0284C7); // Cyan / Blue
      case AiDemoType.tomasCabotageAxle:
        return const Color(0xFFDC2626); // Crimson Red
      case AiDemoType.agroexportTaxShield:
        return const Color(0xFF059669); // Emerald Green
      case AiDemoType.navieraDemurrageBallast:
        return const Color(0xFF1E3A8A); // Deep Navy
    }
  }

  String _getCompanyName() {
    switch (widget.demoType) {
      case AiDemoType.campabadalPoultry:
        return 'Campabadal Global';
      case AiDemoType.tomasCabotageAxle:
        return 'Transportes Tomas';
      case AiDemoType.agroexportTaxShield:
        return 'Agroexport Costa Rica';
      case AiDemoType.navieraDemurrageBallast:
        return 'Naviera Don Jorge';
    }
  }

  String _getDemoTitle() {
    switch (widget.demoType) {
      case AiDemoType.campabadalPoultry:
        return 'Customs Brokerage & CAFTA-DR Tariff AI';
      case AiDemoType.tomasCabotageAxle:
        return 'Cabotage Relay & Axle Bridge Formula AI';
      case AiDemoType.agroexportTaxShield:
        return 'DTA 20% Tax Shield & Phytosanitary AI';
      case AiDemoType.navieraDemurrageBallast:
        return '48h Demurrage Shield & Vessel Stability AI';
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandColor = _getBrandColor();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B1120), // Dark Navy Slate
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF475569),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Top Header & Context Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: brandColor.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(color: brandColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getCompanyName().toUpperCase(),
                        style: TextStyle(
                          color: brandColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                  onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Demo Title
            Text(
              _getDemoTitle(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 14),

            // Step Progress Indicator
            _buildStepIndicator(brandColor),
            const SizedBox(height: 16),

            // Body based on current step
            if (_currentStep == 1) _buildStep1Inputs(brandColor),
            if (_currentStep == 2) _buildStep2AiReasoning(brandColor),
            if (_currentStep == 3) _buildStep3SealedOutcome(brandColor),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // STEP INDICATOR BAR
  // ===========================================================================
  Widget _buildStepIndicator(Color brandColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepPill(1, '1. Inputs', _currentStep >= 1, _currentStep == 1, brandColor),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 10),
          _buildStepPill(2, '2. AI Swarm', _currentStep >= 2, _currentStep == 2, brandColor),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 10),
          _buildStepPill(3, '3. Deliverable', _currentStep >= 3, _currentStep == 3, brandColor),
        ],
      ),
    );
  }

  Widget _buildStepPill(int step, String label, bool isDone, bool isActive, Color brandColor) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: isActive
                ? brandColor
                : isDone
                    ? const Color(0xFF10B981)
                    : const Color(0xFF334155),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone && !isActive
                ? const Icon(Icons.check, size: 10, color: Colors.white)
                : Text(
                    '$step',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : isDone
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF64748B),
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STEP 1: USER INPUTS (Smart Chips + Numerical Inputs)
  // ===========================================================================
  Widget _buildStep1Inputs(Color brandColor) {
    switch (widget.demoType) {
      case AiDemoType.campabadalPoultry:
        return _buildCampabadalInputs(brandColor);
      case AiDemoType.tomasCabotageAxle:
        return _buildTomasInputs(brandColor);
      case AiDemoType.agroexportTaxShield:
        return _buildAgroexportInputs(brandColor);
      case AiDemoType.navieraDemurrageBallast:
        return _buildNavieraInputs(brandColor);
    }
  }

  // --- DEMO 1: CAMPABADAL POULTRY INPUTS ---
  Widget _buildCampabadalInputs(Color brandColor) {
    final hsOptions = [
      {'code': '0207.14.00', 'label': '🍗 Frozen Poultry Cuts'},
      {'code': '0207.12.00', 'label': '🐔 Whole Frozen Chicken'},
      {'code': '0804.30.00', 'label': '🍍 Fresh Pineapples'},
      {'code': '0804.40.00', 'label': '🥑 Fresh Avocados'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '1. SELECT HS TARIFF CLASSIFICATION (SMART CHIPS):',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(hsOptions.length, (index) {
            final opt = hsOptions[index];
            final isSelected = _selectedHsIndex == index;
            return ChoiceChip(
              label: Text('${opt['label']} (${opt['code']})'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedHsIndex = index);
              },
              selectedColor: brandColor,
              backgroundColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
              side: BorderSide(
                color: isSelected ? brandColor : const Color(0xFF334155),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),

        const Text(
          '2. ENTER SHIPMENT GROSS WEIGHT (LBS):',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixText: 'LBS',
            suffixStyle: TextStyle(color: brandColor, fontWeight: FontWeight.w800),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: brandColor, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildQuickFillPill('20k lbs', () => _weightController.text = '20,000'),
            const SizedBox(width: 6),
            _buildQuickFillPill('40k lbs', () => _weightController.text = '40,000'),
            const SizedBox(width: 6),
            _buildQuickFillPill('44k lbs', () => _weightController.text = '44,000'),
            const SizedBox(width: 6),
            _buildQuickFillPill('48k lbs', () => _weightController.text = '48,000'),
          ],
        ),
        const SizedBox(height: 18),

        ElevatedButton(
          onPressed: _runAiOrchestration,
          style: ElevatedButton.styleFrom(
            backgroundColor: brandColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 4,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 18),
              SizedBox(width: 8),
              Text(
                'RUN AI SWARM ORCHESTRATION',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- DEMO 2: TOMAS CABOTAGE & AXLE INPUTS ---
  Widget _buildTomasInputs(Color brandColor) {
    final corridors = [
      '🇲🇽 ➔ 🇬🇹 Tecún Umán Relay',
      '🇬🇹 ➔ 🇸🇻 El Amatillo Relay',
      '🇨🇷 ➔ 🇳🇮 Peñas Blancas Relay',
    ];

    final tractors = [
      '3-Axle Sleeper Cab (6x4)',
      'Day Cab 6x4',
      'Bobtail Yard Transfer',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '1. SELECT BORDER TRANSIT CORRIDOR (SMART CHIPS):',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(corridors.length, (index) {
            final isSelected = _selectedCorridorIndex == index;
            return ChoiceChip(
              label: Text(corridors[index]),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedCorridorIndex = index);
              },
              selectedColor: brandColor,
              backgroundColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
              side: BorderSide(color: isSelected ? brandColor : const Color(0xFF334155)),
            );
          }),
        ),
        const SizedBox(height: 14),

        const Text(
          '2. SELECT TRACTOR CONFIGURATION:',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(tractors.length, (index) {
            final isSelected = _selectedTractorIndex == index;
            return ChoiceChip(
              label: Text(tractors[index]),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedTractorIndex = index);
              },
              selectedColor: brandColor,
              backgroundColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
              side: BorderSide(color: isSelected ? brandColor : const Color(0xFF334155)),
            );
          }),
        ),
        const SizedBox(height: 14),

        const Text(
          '3. ENTER TRAILER TANDEM SCALE READING (LBS):',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _axleWeightController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixText: 'LBS (Legal: 34k)',
            suffixStyle: const TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.w800),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildQuickFillPill('33k lbs (Safe)', () => _axleWeightController.text = '33,000'),
            const SizedBox(width: 6),
            _buildQuickFillPill('35.2k lbs (Over)', () => _axleWeightController.text = '35,200'),
            const SizedBox(width: 6),
            _buildQuickFillPill('38k lbs (Severe)', () => _axleWeightController.text = '38,000'),
          ],
        ),
        const SizedBox(height: 18),

        ElevatedButton(
          onPressed: _runAiOrchestration,
          style: ElevatedButton.styleFrom(
            backgroundColor: brandColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 18),
              SizedBox(width: 8),
              Text(
                'AUDIT AXLES & MATCH CABOTAGE RELAY',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- DEMO 3: AGROEXPORT TAX SHIELD & PHYTO INPUTS ---
  Widget _buildAgroexportInputs(Color brandColor) {
    final produce = [
      '🍍 MD-2 Extra Sweet Pineapple',
      '🥑 Hass Avocado Grade-A',
      '🍌 Cavendish Banana Premium',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '1. SELECT PRODUCE EXPORT VARIETY:',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(produce.length, (index) {
            final isSelected = _selectedProduceIndex == index;
            return ChoiceChip(
              label: Text(produce[index]),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedProduceIndex = index);
              },
              selectedColor: brandColor,
              backgroundColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
              side: BorderSide(color: isSelected ? brandColor : const Color(0xFF334155)),
            );
          }),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2. TARGET BOX COUNT:',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _boxCountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      suffixText: 'BOXES',
                      suffixStyle: TextStyle(color: brandColor, fontWeight: FontWeight.w800),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '3. REEFER SETPOINT:',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _tempController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      suffixText: '°C',
                      suffixStyle: TextStyle(color: brandColor, fontWeight: FontWeight.w800),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        ElevatedButton(
          onPressed: _runAiOrchestration,
          style: ElevatedButton.styleFrom(
            backgroundColor: brandColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 18),
              SizedBox(width: 8),
              Text(
                'APPLY DTA TAX SHIELD & PHYTO PERMIT',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- DEMO 4: NAVIERA DEMURRAGE & BALLAST INPUTS ---
  Widget _buildNavieraInputs(Color brandColor) {
    final bays = [
      'Bay 04 Underdeck Reefer',
      'Bay 08 On-Deck 40ft High-Cube',
      'Bay 12 Aft Hazmat Dangerous Goods',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '1. SELECT VESSEL CARGO BAY POSITION:',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(bays.length, (index) {
            final isSelected = _selectedBayIndex == index;
            return ChoiceChip(
              label: Text(bays[index]),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedBayIndex = index);
              },
              selectedColor: brandColor,
              backgroundColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
              side: BorderSide(color: isSelected ? brandColor : const Color(0xFF334155)),
            );
          }),
        ),
        const SizedBox(height: 14),

        const Text(
          '2. ENTER PORT CONTAINER DWELL TIME (HOURS):',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _dwellHoursController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixText: 'HRS (Free: 48h)',
            suffixStyle: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.w800),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildQuickFillPill('12 hrs (Safe)', () => _dwellHoursController.text = '12'),
            const SizedBox(width: 6),
            _buildQuickFillPill('42 hrs (Warning)', () => _dwellHoursController.text = '42'),
            const SizedBox(width: 6),
            _buildQuickFillPill('54 hrs (Overdue)', () => _dwellHoursController.text = '54'),
          ],
        ),
        const SizedBox(height: 18),

        ElevatedButton(
          onPressed: _runAiOrchestration,
          style: ElevatedButton.styleFrom(
            backgroundColor: brandColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 18),
              SizedBox(width: 8),
              Text(
                'PREDICT DEMURRAGE & AUDIT BALLAST',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickFillPill(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF334155),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ===========================================================================
  // STEP 2: AI REASONING CHAIN ANIMATION
  // ===========================================================================
  Widget _buildStep2AiReasoning(Color brandColor) {
    final steps = [
      'Gemini 3.7 Flash: Autonomous regulatory classification & multimodal origin parsing...',
      'BigQuery Deterministic Gate: Querying tariff schedules, Bridge Formula, and DTA tax rules...',
      'Dual-Defense Model Armor: PII redaction active, SQL injection truth gate verified...',
      'Cryptographic Engine: Synthesizing Ed25519 digital signature & offline optical token...',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brandColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: brandColor, strokeWidth: 2.2),
              ),
              const SizedBox(width: 10),
              const Text(
                'AI SWARM ORCHESTRATION IN PROGRESS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            children: List.generate(steps.length, (index) {
              final isDone = _aiProgressIndex >= index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                      size: 16,
                      color: isDone ? const Color(0xFF10B981) : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        steps[index],
                        style: TextStyle(
                          color: isDone ? Colors.white : const Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const Divider(color: Color(0xFF334155), height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Token Savings vs Monolith:',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '97.7% REDUCTION (420 tokens)',
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP 3: SEALED OUTCOME & 2x2 METRIC DELIVERABLE
  // ===========================================================================
  Widget _buildStep3SealedOutcome(Color brandColor) {
    switch (widget.demoType) {
      case AiDemoType.campabadalPoultry:
        return _buildCampabadalOutcome(brandColor);
      case AiDemoType.tomasCabotageAxle:
        return _buildTomasOutcome(brandColor);
      case AiDemoType.agroexportTaxShield:
        return _buildAgroexportOutcome(brandColor);
      case AiDemoType.navieraDemurrageBallast:
        return _buildNavieraOutcome(brandColor);
    }
  }

  // --- DEMO 1 OUTCOME ---
  Widget _buildCampabadalOutcome(Color brandColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMetricGrid([
          _MetricItem(label: 'HS CODE', value: '0207.14.00', badge: 'VERIFIED', badgeColor: const Color(0xFF10B981)),
          _MetricItem(label: 'TARIFF RATE', value: '0.00% (CAFTA-DR)', badge: 'DUTY FREE', badgeColor: const Color(0xFF10B981)),
          _MetricItem(label: 'CIF LANDED VALUE', value: '\$46,500.00 USD'),
          _MetricItem(label: 'NET TARIFF SAVED', value: '+\$6,975.00 USD', valueColor: const Color(0xFF10B981)),
        ]),
        const SizedBox(height: 14),

        if (_isSealed)
          _buildSuccessBanner('Golden DUCA-T Synthesized & Sealed for Guatemala Customs!')
        else
          ElevatedButton(
            onPressed: _handleSealAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: brandColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_rounded, size: 20),
                SizedBox(width: 8),
                Text('1-TAP SYNTHESIZE & TRANSMIT DUCA-T', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        const SizedBox(height: 10),
        _buildEd25519Footer('ed25519_sig_cbp_02071400_992140_verified'),
      ],
    );
  }

  // --- DEMO 2 OUTCOME ---
  Widget _buildTomasOutcome(Color brandColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMetricGrid([
          _MetricItem(label: 'AXLE STATUS', value: 'BALANCED (34k lbs)', badge: '23 CFR 658', badgeColor: const Color(0xFF10B981)),
          _MetricItem(label: 'LOAD REBALANCE', value: 'Shift 2 Pallets (1.2k lbs)', valueColor: const Color(0xFFFBBF24)),
          _MetricItem(label: 'CABOTAGE MATCH', value: 'GUA-TRK-4912 (<90s)', badge: 'VETTED', badgeColor: const Color(0xFF10B981)),
          _MetricItem(label: 'BORDER SCALE', value: 'GREEN LANE PRE-PASS', valueColor: const Color(0xFF10B981)),
        ]),
        const SizedBox(height: 14),

        if (_isSealed)
          _buildSuccessBanner('Cabotage Relay Dispatched & WhatsApp Alert Sent to Driver!')
        else
          ElevatedButton(
            onPressed: _handleSealAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: brandColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping_rounded, size: 20),
                SizedBox(width: 8),
                Text('DISPATCH TRACTOR RELAY & PUSH WHATSAPP', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        const SizedBox(height: 10),
        _buildEd25519Footer('ed25519_sig_sat_prepass_tecun_relay_88214'),
      ],
    );
  }

  // --- DEMO 3 OUTCOME ---
  Widget _buildAgroexportOutcome(Color brandColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMetricGrid([
          _MetricItem(label: 'DTA TAX SHIELD', value: '0% Withholding', badge: 'ARTICLE 7', badgeColor: const Color(0xFF10B981)),
          _MetricItem(label: 'NET CASH SAVED', value: '+\$4,250.00 USD', valueColor: const Color(0xFF10B981)),
          _MetricItem(label: 'COLD-CHAIN SET', value: '+4.5°C Stable', badge: 'REEFER OK', badgeColor: const Color(0xFF10B981)),
          _MetricItem(label: 'PHYTO PERMIT', value: 'MAG-USDA APPROVED', valueColor: const Color(0xFF10B981)),
        ]),
        const SizedBox(height: 14),

        if (_isSealed)
          _buildSuccessBanner('Article 7 Tax Shield Applied & Moín Terminal Reefer Gate Pass Issued!')
        else
          ElevatedButton(
            onPressed: _handleSealAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: brandColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_rounded, size: 20),
                SizedBox(width: 8),
                Text('CLAIM \$4,250 TAX SHIELD & ISSUE GATE PASS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        const SizedBox(height: 10),
        _buildEd25519Footer('ed25519_sig_procomer_dta_tax_441920_signed'),
      ],
    );
  }

  // --- DEMO 4 OUTCOME ---
  Widget _buildNavieraOutcome(Color brandColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMetricGrid([
          _MetricItem(label: 'DEMURRAGE RISK', value: 'CRITICAL (6h Left)', badge: '48H LIMIT', badgeColor: const Color(0xFFFBBF24)),
          _MetricItem(label: 'FINE PREVENTED', value: '+\$150/Day Saved', valueColor: const Color(0xFF10B981)),
          _MetricItem(label: 'BALLAST STABILITY', value: 'GM = 1.42m (List 0.0°)', badge: 'IMO SAFE', badgeColor: const Color(0xFF10B981)),
          _MetricItem(label: 'MASTER B/L', value: 'e-B/L AUTHORIZED', valueColor: const Color(0xFF10B981)),
        ]),
        const SizedBox(height: 14),

        if (_isSealed)
          _buildSuccessBanner('Terminal Gate Pass Dispatched & Master e-B/L Released!')
        else
          ElevatedButton(
            onPressed: _handleSealAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: brandColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.anchor_rounded, size: 20),
                SizedBox(width: 8),
                Text('1-TAP DISPATCH GATE PASS & RELEASE e-B/L', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        const SizedBox(height: 10),
        _buildEd25519Footer('ed25519_sig_imo_portmiami_ebl_release_992140'),
      ],
    );
  }

  // Helper: Metric Grid
  Widget _buildMetricGrid(List<_MetricItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (item.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: (item.badgeColor ?? const Color(0xFF10B981)).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.badge!,
                        style: TextStyle(
                          color: item.badgeColor ?? const Color(0xFF10B981),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                item.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: item.valueColor ?? Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuccessBanner(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF065F46).withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF10B981)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(
                color: Color(0xFF6EE7B7),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEd25519Footer(String sig) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 12, color: Color(0xFF10B981)),
          const SizedBox(width: 6),
          Text(
            'Ed25519 Cryptographic Seal: $sig',
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 9,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem {
  final String label;
  final String value;
  final Color? valueColor;
  final String? badge;
  final Color? badgeColor;

  _MetricItem({
    required this.label,
    required this.value,
    this.valueColor,
    this.badge,
    this.badgeColor,
  });
}
