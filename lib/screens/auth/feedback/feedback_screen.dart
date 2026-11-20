import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/secure_storage.dart';
import '../../services/chat_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _msgCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _category = 'Suggestion';
  int _rating = 5;
  bool _submitting = false;

  final _categories = ['Suggestion', 'Bug report', 'Complaint', 'General feedback'];

  @override
  void initState() {
    super.initState();
    _fillUserData();
  }

  Future<void> _fillUserData() async {
    _nameCtrl.text = await SecureStorage.getUsername() ?? '';
    _emailCtrl.text = await SecureStorage.getEmail() ?? '';
  }

  Future<void> _submit() async {
    final msg = _msgCtrl.text.trim();
    if (msg.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message must be at least 5 characters.')));
      return;
    }

    setState(() => _submitting = true);
    try {
      await ChatService.submitFeedback(
        category: _category,
        rating: _rating,
        message: msg,
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you! Your feedback has been received.')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('HELP US IMPROVE', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Share your experience', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.text)),
            const SizedBox(height: 20),

            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(labelText: 'Your name (optional)'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(labelText: 'Email address (optional)'),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _category,
              dropdownColor: AppColors.panel,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 20),

            const Text('Rating', style: TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                return IconButton(
                  icon: Icon(star <= _rating ? Icons.star : Icons.star_border, color: AppColors.accent, size: 30),
                  onPressed: () => setState(() => _rating = star),
                );
              }),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _msgCtrl,
              maxLines: 5,
              maxLength: 3000,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(labelText: 'Your message', hintText: 'Tell us what happened or what you would like to see...'),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.bg, strokeWidth: 2))
                    : const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
