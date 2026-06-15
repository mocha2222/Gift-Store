import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_footer_nav.dart';
import '../../widgets/app_header.dart';

class ArtisanChatPage extends StatefulWidget {
  const ArtisanChatPage({super.key});

  @override
  State<ArtisanChatPage> createState() => _ArtisanChatPageState();
}

class _ArtisanChatPageState extends State<ArtisanChatPage> {
  static const Color _backgroundColor = Color(0xFFF7F0E4);
  static const Color _surfaceColor = Color(0xFFFBF5EA);
  static const Color _primaryColor = Color(0xFF8C6500);
  static const Color _textDarkColor = Color(0xFF2C261E);
  static const Color _textMutedColor = Color(0xFF5F564C);

  final TextEditingController _searchController = TextEditingController();

  final List<Conversation> _conversations = [
    const Conversation(
      name: 'Sokha',
      product: 'Rattan wall decor',
      time: '2m',
      unreadCount: 2,
      lastMessage: 'Hello, is the wall decor still available?',
      initials: 'SK',
      accentColor: Color(0xFF2D7A4E),
      messages: [
        ChatMessage(
          text: 'Hello, is the wall decor still available?',
          isMe: false,
          time: '9:12',
        ),
        ChatMessage(
          text: 'Yes, I have one piece ready for shipping.',
          isMe: true,
          time: '9:14',
        ),
        ChatMessage(
          text: 'Perfect. Can you pack it carefully?',
          isMe: false,
          time: '9:15',
        ),
      ],
    ),
    const Conversation(
      name: 'Lin Wei',
      product: 'Ceramic tea set',
      time: '18m',
      unreadCount: 0,
      lastMessage: 'The tea set arrived safely. Thank you!',
      initials: 'LW',
      accentColor: Color(0xFFB8770D),
      messages: [
        ChatMessage(
          text: 'The tea set arrived safely. Thank you!',
          isMe: false,
          time: '8:46',
        ),
        ChatMessage(
          text: 'So glad to hear that, enjoy it!',
          isMe: true,
          time: '8:48',
        ),
      ],
    ),
    const Conversation(
      name: 'Amara',
      product: 'Silk scarf',
      time: '1h',
      unreadCount: 1,
      lastMessage: 'Could you send a few more photos?',
      initials: 'AM',
      accentColor: Color(0xFF534AB7),
      messages: [
        ChatMessage(
          text: 'Could you send a few more photos?',
          isMe: false,
          time: '8:02',
        ),
        ChatMessage(
          text: 'Of course, I will upload them shortly.',
          isMe: true,
          time: '8:05',
        ),
      ],
    ),
    const Conversation(
      name: 'Dara',
      product: 'Wooden bowl',
      time: 'Yesterday',
      unreadCount: 0,
      lastMessage: 'I would like to order 4 pieces for my store.',
      initials: 'DR',
      accentColor: Color(0xFFC0392B),
      messages: [
        ChatMessage(
          text: 'I would like to order 4 pieces for my store.',
          isMe: false,
          time: 'Yesterday',
        ),
        ChatMessage(
          text: 'Absolutely, I can prepare the order today.',
          isMe: true,
          time: 'Yesterday',
        ),
      ],
    ),
  ];

  String? _userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('user_role');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredConversations = _conversations.where((conversation) {
      if (query.isEmpty) return true;
      return conversation.name.toLowerCase().contains(query) ||
          conversation.product.toLowerCase().contains(query) ||
          conversation.lastMessage.toLowerCase().contains(query);
    }).toList();

    final mainScroll = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _primaryColor.withValues(alpha: 0.14),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: _primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search conversations',
                        hintStyle: GoogleFonts.inter(
                          color: _textMutedColor,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.inter(
                        color: _textDarkColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: _textMutedColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Inbox',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: _textDarkColor,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = filteredConversations[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == filteredConversations.length - 1 ? 0 : 12,
                ),
                child: _ConversationTile(
                  conversation: item,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ArtisanConversationPage(conversation: item),
                      ),
                    );
                  },
                ),
              );
            }, childCount: filteredConversations.length),
          ),
        ),
      ],
    );

    final isCustomer =
        _userRole == 'customer' ||
        _userRole == null ||
        _userRole.toString().isEmpty;

    if (isCustomer) {
      return Scaffold(
        drawer: const AppDrawer(),
        backgroundColor: _backgroundColor,
        body: Column(
          children: [
            const AppHeader(showCart: true),
            Expanded(child: mainScroll),
            const SafeArea(top: false, child: AppFooterNav(currentIndex: 2)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAD5A8)),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF231408),
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          'Messages',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_note_rounded),
            color: _primaryColor,
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: _backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF231408),
      ),
      body: SafeArea(child: mainScroll),
    );
  }
}

class ArtisanConversationPage extends StatefulWidget {
  const ArtisanConversationPage({super.key, required this.conversation});

  final Conversation conversation;

  @override
  State<ArtisanConversationPage> createState() =>
      _ArtisanConversationPageState();
}

class _ArtisanConversationPageState extends State<ArtisanConversationPage> {
  static const Color _backgroundColor = Color(0xFFF7F0E4);
  static const Color _surfaceColor = Color(0xFFFBF5EA);
  static const Color _primaryColor = Color(0xFF8C6500);
  static const Color _textDarkColor = Color(0xFF2C261E);
  static const Color _textMutedColor = Color(0xFF5F564C);

  final TextEditingController _composer = TextEditingController();
  late final List<ChatMessage> _messages = List<ChatMessage>.from(
    widget.conversation.messages,
  );

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAD5A8)),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF231408),
                size: 20,
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.conversation.name,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _textDarkColor,
              ),
            ),
            Text(
              widget.conversation.product,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _textMutedColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined),
            color: _primaryColor,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
            color: _primaryColor,
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: _backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF231408),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: _ConversationHeader(conversation: widget.conversation),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: _messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _MessageBubble(message: message);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _primaryColor.withValues(alpha: 0.14),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_rounded, color: _primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _composer,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Write a reply...',
                          hintStyle: GoogleFonts.inter(
                            color: _textMutedColor,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.inter(
                          color: _textDarkColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: _primaryColor,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send_rounded),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _composer.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isMe: true, time: 'now'));
      _composer.clear();
    });
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onComposeTap});

  final VoidCallback onComposeTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7A4E2D).withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.forum_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat inbox',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: onComposeTap,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _ArtisanPalette.primary,
            ),
            child: Text(
              'New',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _ArtisanPalette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _ArtisanPalette.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: _ArtisanPalette.textDark,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _ArtisanPalette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _ArtisanPalette.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: _ArtisanPalette.primary.withValues(alpha: 0.14),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: conversation.accentColor.withValues(
                      alpha: 0.14,
                    ),
                    child: Text(
                      conversation.initials,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: conversation.accentColor,
                      ),
                    ),
                  ),
                  if (conversation.unreadCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC0392B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _ArtisanPalette.textDark,
                            ),
                          ),
                        ),
                        Text(
                          conversation.time,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: _ArtisanPalette.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.product,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _ArtisanPalette.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      conversation.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _ArtisanPalette.textDark,
                        fontWeight: conversation.unreadCount > 0
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (conversation.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: conversation.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${conversation.unreadCount}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: conversation.accentColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationHeader extends StatelessWidget {
  const _ConversationHeader({required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _ArtisanPalette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _ArtisanPalette.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: conversation.accentColor.withValues(alpha: 0.14),
            child: Text(
              conversation.initials,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: conversation.accentColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _ArtisanPalette.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  conversation.product,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _ArtisanPalette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${conversation.unreadCount} unread',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _ArtisanPalette.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe ? _ArtisanPalette.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isMe ? 18 : 4),
            bottomRight: Radius.circular(message.isMe ? 4 : 18),
          ),
          border: Border.all(
            color: message.isMe
                ? _ArtisanPalette.primary
                : _ArtisanPalette.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.45,
                color: message.isMe ? Colors.white : _ArtisanPalette.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: message.isMe
                    ? Colors.white.withValues(alpha: 0.75)
                    : _ArtisanPalette.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Conversation {
  const Conversation({
    required this.name,
    required this.product,
    required this.time,
    required this.unreadCount,
    required this.lastMessage,
    required this.initials,
    required this.accentColor,
    required this.messages,
  });

  final String name;
  final String product;
  final String time;
  final int unreadCount;
  final String lastMessage;
  final String initials;
  final Color accentColor;
  final List<ChatMessage> messages;
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });

  final String text;
  final bool isMe;
  final String time;
}

class _ArtisanPalette {
  static const Color primary = Color(0xFF8C6500);
  static const Color surface = Color(0xFFFBF5EA);
  static const Color textDark = Color(0xFF2C261E);
  static const Color textMuted = Color(0xFF5F564C);
}
