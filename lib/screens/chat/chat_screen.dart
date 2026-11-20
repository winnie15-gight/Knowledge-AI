import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/chat_message.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../auth/login_screen.dart';
import '../feedback/feedback_screen.dart';
import '../premium/premium_screen.dart';
import '../settings/settings_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _loading = false;
  bool _initialLoad = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final list = await ChatService.getMessages();
      setState(() {
        _messages.clear();
        _messages.addAll(list);
        _initialLoad = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _initialLoad = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _send([String? customPrompt]) async {
    final text = (customPrompt ?? _inputCtrl.text).trim();
    if (text.isEmpty || _loading) return;

    _inputCtrl.clear();
    final userMsg = ChatMessage(role: 'user', content: text, createdAt: DateTime.now());
    final pendingMsg = ChatMessage(role: 'assistant', content: 'Thinking…', createdAt: DateTime.now(), isPending: true);

    setState(() {
      _messages.add(userMsg);
      _messages.add(pendingMsg);
      _loading = true;
      _errorMessage = null;
    });
    _scrollToBottom();

    try {
      final reply = await ChatService.sendMessage(text);
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(role: 'assistant', content: reply, createdAt: DateTime.now()));
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent + 80, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('KNOWLEDGE AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1.2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFF3A242B),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 12))),
                    IconButton(icon: const Icon(Icons.close, size: 16, color: AppColors.danger), onPressed: () => setState(() => _errorMessage = null)),
                  ],
                ),
              ),

            Expanded(
              child: _initialLoad
                  ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                  : _messages.isEmpty
                      ? _buildWelcomeCard()
                      : ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          itemCount: _messages.length,
                          itemBuilder: (ctx, i) => _buildMessageBubble(_messages[i]),
                        ),
            ),

            if (_messages.isEmpty && !_initialLoad) _buildPromptChips(),

            _buildComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.panel,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('✦', style: TextStyle(fontSize: 32, color: AppColors.accent)),
              SizedBox(height: 12),
              Text("Let's make learning click.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
              SizedBox(height: 8),
              Text('Ask questions, explore ideas, or select a sample topic below.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptChips() {
    final chips = [
      '🔬 Explain a science topic',
      '📐 Practise mathematics',
      '💻 Learn programming',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: chips.map((c) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => _send(c),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(color: AppColors.panel, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.line)),
                child: Text(c, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.text)),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: const Color(0xFF1B3944), borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Text('K', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: msg.isUser ? const Color(0xFF19283C) : AppColors.panel,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: msg.isUser ? const Color(0xFF263B55) : AppColors.line),
              ),
              child: Text(
                msg.content,
                style: TextStyle(color: msg.isPending ? AppColors.muted : AppColors.text, height: 1.5, fontSize: 14),
              ),
            ),
          ),
          if (msg.isUser) ...[
            const SizedBox(width: 10),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: const Color(0xFF25334A), borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Text('Y', style: TextStyle(color: Color(0xFFDCE8F8), fontWeight: FontWeight.bold))),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.panel,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              maxLines: 4,
              minLines: 1,
              style: const TextStyle(color: AppColors.text, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Ask KNOWLEDGE AI anything...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _loading ? null : () => _send(),
            icon: _loading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2))
                : const Icon(Icons.arrow_upward, color: AppColors.accent),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF101A2A),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('KNOWLEDGE AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.text)),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: AppColors.accent),
              title: const Text('AI Tutor', style: TextStyle(color: AppColors.text)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined, color: AppColors.accent),
              title: const Text('Membership / Premium', style: TextStyle(color: AppColors.text)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined, color: AppColors.accent),
              title: const Text('Send Feedback', style: TextStyle(color: AppColors.text)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: AppColors.accent),
              title: const Text('Settings', style: TextStyle(color: AppColors.text)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            const Spacer(),
            const Divider(color: AppColors.line),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.danger),
              title: const Text('Log out', style: TextStyle(color: AppColors.danger)),
              onTap: () async {
                await AuthService.logout();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
