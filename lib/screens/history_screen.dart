import 'package:flutter/material.dart';
import '../models/history.dart';
import '../services/storage_service.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import 'recipe_detail_screen.dart';

/// 历史记录界面 — Figma Harvest Warm 设计稿
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _storage = StorageService.getInstance();
  List<HistoryRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final records = _storage.getHistoryRecords();
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  Future<void> _deleteRecord(String id) async {
    await _storage.deleteHistoryRecord(id);
    await _loadHistory();
    if (mounted) {
      final S = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_deleteSuccessText(S)),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      );
    }
  }

  Future<void> _clearAll() async {
    final S = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Text(
          _clearAllTitle(S),
          style: const TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700),
        ),
        content: Text(
          _clearAllMessage(S),
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.cancel, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              _clearText(S),
              style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storage.clearHistoryRecords();
      await _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildNavBar(context, S),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CULINARY JOURNAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppTheme.secondary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _historyTitle(S),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    fontFamily: 'Manrope',
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _historySubtitle(S),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    fontFamily: 'Inter',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : _records.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadHistory,
                        color: AppTheme.primary,
                        child: _buildGroupedList(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, AppLocalizations S) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.outline.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                const Spacer(),
                const Text(
                  'EATWHAT',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    fontFamily: 'Manrope',
                  ),
                ),
                const Spacer(),
                if (_records.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppTheme.primary, size: 22),
                    onPressed: _clearAll,
                    tooltip: _clearAllTitle(S),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedList() {
    final grouped = _groupByDate(_records);
    final dates = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final items = grouped[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 16),
            _buildDateHeader(date),
            const SizedBox(height: 8),
            ...items.map((record) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildHistoryCard(record),
                )),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.textHint,
          letterSpacing: 1.5,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildHistoryCard(HistoryRecord record) {
    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.errorContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: const Icon(Icons.delete, color: AppTheme.error),
      ),
      onDismissed: (_) => _deleteRecord(record.id),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          onTap: () {
            if (record.recipes.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: record.recipes.first),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B1C1A).withOpacity(0.04),
                  blurRadius: 32,
                ),
              ],
            ),
            child: Row(
              children: [
                // 缩略图
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    color: AppTheme.surfaceContainer,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    child: record.recipes.isNotEmpty &&
                            record.recipes.first.imageUrl.isNotEmpty
                        ? Image.network(
                            record.recipes.first.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildSourceIcon(record.source),
                          )
                        : _buildSourceIcon(record.source),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildSourceTag(record),
                          const SizedBox(width: 8),
                          Text(
                            '${record.recipeCount} ${_recipesText()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (record.recipes.isNotEmpty)
                        Text(
                          record.recipes.first.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            fontFamily: 'Manrope',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(record.timestamp),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textHint,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.textHint, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceIcon(HistorySource source) {
    final (icon, color) = _getSourceIconAndColor(source);
    return Center(
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildSourceTag(HistoryRecord record) {
    final (icon, color) = _getSourceIconAndColor(record.source);
    final localeName = AppLocalizations.of(context)!.localeName;
    final label = localeName.startsWith('zh')
        ? record.sourceName
        : record.sourceNameEn;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color) _getSourceIconAndColor(HistorySource source) {
    switch (source) {
      case HistorySource.arScan:
        return (Icons.qr_code_scanner, AppTheme.primary);
      case HistorySource.photoScan:
        return (Icons.photo_library_outlined, AppTheme.primaryContainer);
      case HistorySource.pantryCook:
        return (Icons.kitchen_outlined, AppTheme.secondary);
      case HistorySource.manualInput:
        return (Icons.edit_outlined, AppTheme.tertiary);
    }
  }

  Widget _buildEmptyState() {
    final S = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: AppTheme.outline.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            _emptyTitle(S),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _emptySubtitle(S),
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<HistoryRecord>> _groupByDate(List<HistoryRecord> records) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final result = <String, List<HistoryRecord>>{};

    for (final record in records) {
      final recordDate = DateTime(
        record.timestamp.year,
        record.timestamp.month,
        record.timestamp.day,
      );
      String key;
      if (recordDate == today) {
        key = _todayText();
      } else if (recordDate == yesterday) {
        key = _yesterdayText();
      } else {
        key = '${record.timestamp.month}月${record.timestamp.day}日';
      }
      result.putIfAbsent(key, () => []).add(record);
    }
    return result;
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // ── Localized strings ──────────────────────────────────────────
  String _historyTitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) return '历史记录';
    return 'Your History';
  }

  String _historySubtitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '记录你的每一次美食探索，方便随时回顾。';
    }
    return 'A personal journal of your culinary discoveries.';
  }

  String _emptyTitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) return '还没有记录';
    return 'No history yet';
  }

  String _emptySubtitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '开始扫描食材或生成食谱吧';
    }
    return 'Start scanning or generating recipes';
  }

  String _deleteSuccessText(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) return '已删除';
    return 'Deleted';
  }

  String _clearAllTitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) return '清空历史';
    return 'Clear History';
  }

  String _clearAllMessage(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '确定要清空所有历史记录吗？此操作不可撤销。';
    }
    return 'Are you sure you want to clear all history? This cannot be undone.';
  }

  String _clearText(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) return '清空';
    return 'Clear';
  }

  String _todayText() {
    return '今天';
  }

  String _yesterdayText() {
    return '昨天';
  }

  String _recipesText() {
    final S = AppLocalizations.of(context);
    if (S == null || S.localeName.startsWith('zh')) return '道菜';
    return 'recipes';
  }
}
