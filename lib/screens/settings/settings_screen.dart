import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/preferences.dart';
import '../../services/chat_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TutorPreferences _prefs = TutorPreferences();
  bool _loading = true;
  bool _saving = false;

  final _interestsCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();

  final _personalities = ['Friendly', 'Funny', 'Calm', 'Wise', 'Motivational'];
  final _styles = ['Casual', 'Formal', 'Playful', 'Straight-to-the-point'];
  final _lengths = ['Short', 'Balanced', 'Detailed'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await ChatService.getPreferences();
      setState(() {
        _prefs = p;
        _interestsCtrl.text = p.interests;
        _instructionsCtrl.text = p.instructions;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    _prefs.interests = _interestsCtrl.text.trim();
    _prefs.instructions = _instructionsCtrl.text.trim();

    try {
      await ChatService.updatePreferences(_prefs);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved successfully.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.panel,
        title: const Text('Clear Chat History?', style: TextStyle(color: AppColors.text)),
        content: const Text('This removes saved conversation messages from your account. This action cannot be undone.', style: TextStyle(color: AppColors.muted)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear', style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ChatService.clearHistory();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chat history cleared.')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PERSONALISE YOUR TUTOR', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildDropdown('Personality', _prefs.personality, _personalities, (v) => setState(() => _prefs.personality = v!)),
            const SizedBox(height: 16),
            _buildDropdown('Communication style', _prefs.style, _styles, (v) => setState(() => _prefs.style = v!)),
            const SizedBox(height: 16),
            _buildDropdown('Response length', _prefs.length, _lengths, (v) => setState(() => _prefs.length = v!)),
            const SizedBox(height: 16),

            TextField(
              controller: _interestsCtrl,
              maxLength: 500,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(labelText: 'Interests', hintText: 'e.g. physics, algebra, algorithms'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _instructionsCtrl,
              maxLength: 1000,
              maxLines: 3,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(labelText: 'Custom instructions', hintText: 'Anything else your tutor should know?'),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.bg, strokeWidth: 2))
                    : const Text('Save Settings →'),
              ),
            ),

            const SizedBox(height: 36),
            const Divider(color: AppColors.line),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.panel, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.line)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Clear conversation history', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Deletes all current AI tutor interactions permanently.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: _clearHistory,
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
                    child: const Text('Clear history', style: TextStyle(color: AppColors.danger)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.line)),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: AppColors.panel,
            style: const TextStyle(color: AppColors.text),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
