import 'package:flutter/material.dart';
import '../models/trade_models.dart';
import '../services/api_service.dart';
import '../widgets/smart_chips_bar.dart';
import '../widgets/golden_document_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  TradeResponse? _currentTrade;
  final List<String> _selectedChips = [];

  @override
  void initState() {
    super.initState();
    // Initialize default high-fidelity demo route
    _executeTradeQuery('600 lbs frozen chicken from Colombia to Miami Port 5201');
  }

  void _executeTradeQuery(String prompt) async {
    setState(() => _isLoading = true);
    final response = await apiService.processTradePrompt(
      prompt: prompt,
      selectedChips: _selectedChips,
    );
    setState(() {
      _currentTrade = response;
      _isLoading = false;
    });
  }

  void _onChipSelected(SmartChip chip) {
    setState(() {
      _selectedChips.add(chip.id);
    });
    _executeTradeQuery(_textController.text.isNotEmpty ? _textController.text : '600 lbs frozen chicken from Colombia to Miami');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_shipping, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'ALL THINGS LOGISTICS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'Fortified Multi-Agent Fleet',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner, color: Color(0xFF60A5FA)),
            tooltip: 'Camera Vision OCR Scan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📷 Camera OCR: Ingested Bill of Lading BOL-CO-MIA-2026'),
                  backgroundColor: Color(0xFF2563EB),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.purpleAccent),
            tooltip: 'Voice-to-Trade Audio',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎙️ Voice Capture: Transcribing audio to Gemini 3.7 Flash...'),
                  backgroundColor: Colors.purple,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Scenario Presets (Zero-Typing)
          Container(
            height: 48,
            color: const Color(0xFF131D31),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildPresetChip('🍗 Colombia -> Miami (Chicken)', '600 lbs frozen chicken from Colombia to Miami Port 5201'),
                _buildPresetChip('☕ Colombia -> USA (Coffee)', '1000 kg green arabica coffee from Bogota to Houston'),
                _buildPresetChip('🥑 Mexico -> USA (Avocados)', '500 boxes fresh Hass avocados from Michoacan to Laredo'),
              ],
            ),
          ),

          // Main Interactive Body
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                // Agent Status Header
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
                    ),
                  )
                else if (_currentTrade != null) ...[
                  // Dynamic Contextual Smart Chips for Refinement
                  if (_currentTrade!.smartChips.isNotEmpty) ...[
                    SmartChipsBar(
                      chips: _currentTrade!.smartChips,
                      onChipSelected: _onChipSelected,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Golden Document Card
                  GoldenDocumentCard(response: _currentTrade!),
                  const SizedBox(height: 16),

                  // Audit & Model Armor Notes
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131D31),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.gavel_rounded, size: 16, color: Color(0xFF38BDF8)),
                            SizedBox(width: 8),
                            Text(
                              'ENTERPRISE COMPLIANCE & MODEL ARMOR AUDIT',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ..._currentTrade!.auditNotes.map((note) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    note,
                                    style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
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
              ],
            ),
          ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              border: Border(top: BorderSide(color: Color(0xFF334155))),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
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
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.send_rounded, size: 18),
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

  Widget _buildPresetChip(String label, String prompt) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        backgroundColor: const Color(0xFF1E293B),
        side: const BorderSide(color: Color(0xFF334155)),
        label: Text(label, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11, fontWeight: FontWeight.w600)),
        onPressed: () {
          _textController.text = prompt;
          _selectedChips.clear();
          _executeTradeQuery(prompt);
        },
      ),
    );
  }
}
