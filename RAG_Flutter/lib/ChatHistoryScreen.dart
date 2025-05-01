import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // تأكد من إضافة هذه المكتبة للتعامل مع التواريخ
import 'chat.dart';

// تعريف نموذج بيانات ChatHistoryItem هنا بدلاً من استيراده
class ChatHistoryItem {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final String avatarUrl; // رابط الصورة الرمزية (اختياري)

  ChatHistoryItem({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.avatarUrl = '',
  });
}

// تعريف خدمة المحادثات هنا بدلاً من استيرادها
class ChatService {
  // محاكاة لقاعدة بيانات المحادثات
  static final List<ChatHistoryItem> _mockChatHistory = [
    ChatHistoryItem(
      id: '1',
      title: 'المساعد الذكي',
      lastMessage: 'مرحباً، كيف يمكنني مساعدتك اليوم؟',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    ChatHistoryItem(
      id: '2',
      title: 'محادثة حول الذكاء الاصطناعي',
      lastMessage: 'هذه بعض المعلومات المفيدة عن تطبيقات الذكاء الاصطناعي...',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
    ),
    ChatHistoryItem(
      id: '3',
      title: 'مساعدة في البرمجة',
      lastMessage: 'يمكنك حل هذه المشكلة باستخدام...',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
    ),
    ChatHistoryItem(
      id: '4',
      title: 'ترجمة نصوص',
      lastMessage: 'تمت الترجمة بنجاح!',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 0,
    ),
    ChatHistoryItem(
      id: '5',
      title: 'تحليل بيانات',
      lastMessage: 'إليك نتائج التحليل التي طلبتها...',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      unreadCount: 1,
    ),
  ];

  // الحصول على سجل المحادثات
  static Future<List<ChatHistoryItem>> getChatHistory() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(seconds: 1));
    return [..._mockChatHistory];
  }

  // حذف محادثة
  static Future<bool> deleteChat(String chatId) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 500));
    final int index = _mockChatHistory.indexWhere((chat) => chat.id == chatId);
    
    if (index != -1) {
      _mockChatHistory.removeAt(index);
      return true;
    }
    return false;
  }

  // تعيين جميع المحادثات كمقروءة
  static Future<bool> markAllChatsAsRead() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 500));
    
    for (int i = 0; i < _mockChatHistory.length; i++) {
      final chat = _mockChatHistory[i];
      if (chat.unreadCount > 0) {
        _mockChatHistory[i] = ChatHistoryItem(
          id: chat.id,
          title: chat.title,
          lastMessage: chat.lastMessage,
          timestamp: chat.timestamp,
          unreadCount: 0,
          avatarUrl: chat.avatarUrl,
        );
      }
    }
    
    return true;
  }

  // حذف جميع المحادثات
  static Future<bool> deleteAllChats() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 800));
    
    _mockChatHistory.clear();
    return true;
  }
}

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<ChatHistoryItem> _chatHistory = [];
  List<ChatHistoryItem> _filteredChatHistory = [];
  bool _isLoading = true;
  
  // تصنيف المحادثات
  String _currentFilter = 'all'; // all, today
  
  // تحريك للأسفل للتحديث
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  
  // تحريك للتصنيف
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // تغيير عدد التبويبات إلى 2 بدلاً من 3
    _tabController.addListener(_handleTabSelection);
    _loadChatHistory();
  }
  
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _currentFilter = 'all';
            break;
          case 1:
            _currentFilter = 'today';
            break;
        }
        _filterChats(_searchController.text);
      });
    }
  }

  Future<void> _loadChatHistory() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final history = await ChatService.getChatHistory();
      setState(() {
        _chatHistory = history;
        _filterChats(_searchController.text);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل سجل المحادثات')),
      );
    }
  }

  void _filterChats(String query) {
    setState(() {
      // تطبيق البحث أولاً
      var filtered = _chatHistory;
      if (query.isNotEmpty) {
        filtered = filtered
            .where((chat) =>
                chat.title.toLowerCase().contains(query.toLowerCase()) ||
                chat.lastMessage.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      
      // تطبيق التصنيف
      switch (_currentFilter) {
        case 'today':
          final now = DateTime.now();
          filtered = filtered.where((chat) => 
            chat.timestamp.day == now.day && 
            chat.timestamp.month == now.month && 
            chat.timestamp.year == now.year
          ).toList();
          break;
      }
      
      _filteredChatHistory = filtered;
    });
  }

  Future<void> _refreshChatHistory() {
    return _loadChatHistory();
  }

  String _getTimeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 7) {
      // استخدام التنسيق العربي للتاريخ
      final DateFormat formatter = DateFormat('dd/MM/yyyy', 'ar');
      return formatter.format(dateTime);
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  void _showDeleteConfirmation(ChatHistoryItem chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المحادثة'),
        content: Text('هل أنت متأكد من رغبتك في حذف هذه المحادثة؟\n"${chat.title}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ChatService.deleteChat(chat.id);
              _loadChatHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المحادثة بنجاح')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _navigateToChatScreen(ChatHistoryItem chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatServ(chatId: chat.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _filterChats('');
                  });
                },
              )
            : const BackButton(color: Colors.black),
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                // textDirection: TextDirection.LTR,
                decoration: const InputDecoration(
                  hintText: '...البحث في المحادثات',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: _filterChats,
                autofocus: true,
              )
            : const Text(
                'سجل المحادثات',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.delete_sweep, color: Colors.red),
                        title: const Text('حذف جميع المحادثات'),
                        onTap: () async {
                          Navigator.pop(context);
                          await ChatService.deleteAllChats();
                          _loadChatHistory();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حذف جميع المحادثات')),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.mark_chat_read, color: Colors.green),
                        title: const Text('تعيين الكل كمقروء'),
                        onTap: () async {
                          Navigator.pop(context);
                          await ChatService.markAllChatsAsRead();
                          _loadChatHistory();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم تعيين جميع المحادثات كمقروءة')),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.archive, color: Colors.blue),
                        title: const Text('أرشفة المحادثات القديمة'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('ميزة الأرشفة غير متاحة حالياً')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'اليوم'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshChatHistory,
              child: _filteredChatHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isNotEmpty
                                ? 'لا توجد نتائج لبحثك'
                                : _currentFilter == 'today'
                                    ? 'لا توجد محادثات اليوم'
                                    : 'لا توجد محادثات',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredChatHistory.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final chat = _filteredChatHistory[index];
                        return ListTile(
                          onTap: () {
                            // الانتقال إلى شاشة المحادثة باستخدام الصفحة الموجودة بالفعل
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatServ(chatId: chat.id),
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              chat.title.substring(0, 1),
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                          title: Text(
                            chat.title,
                            style: TextStyle(
                              fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            chat.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _getTimeAgo(chat.timestamp),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              if (chat.unreadCount > 0)
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    chat.unreadCount.toString(),
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          onLongPress: () {
                            _showDeleteConfirmation(chat);
                          },
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // إنشاء محادثة جديدة
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatServ(chatId: 'new'),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// تستخدم صفحة المحادثة الموجودة بالفعل في ملف chat.dart