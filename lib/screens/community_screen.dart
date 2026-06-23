import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/community.dart';
import '../theme/app_theme.dart';

/// Community feed — mirrors CommunityView.tsx (posts by verified pharmacists).
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  List<CommunityPost> get _posts {
    final now = DateTime.now();
    final users = const [
      CommunityUser(
          id: '1',
          name: 'د. أحمد منصور',
          isVerified: true,
          level: UserLevel.diamond,
          points: 4200,
          role: 'pharmacist',
          title: 'صيدلي إكلينيكي'),
      CommunityUser(
          id: '2',
          name: 'صيدلانية مريم',
          isVerified: true,
          level: UserLevel.gold,
          points: 1850,
          role: 'pharmacist',
          title: 'مديرة صيدلية'),
      CommunityUser(
          id: '3',
          name: 'محمد السيد',
          level: UserLevel.silver,
          points: 640,
          role: 'student',
          title: 'طالب صيدلة'),
    ];
    return [
      CommunityPost(
        id: 'p1',
        author: users[0],
        content:
            'تنبيه: تم تحديث أسعار مجموعة المضادات الحيوية اليوم. تأكدوا من مراجعة قائمة الأدوية المحدثة قبل الصرف.',
        mentionedDrugs: const ['Augmentin 1g', 'Klacid 500'],
        likes: 128,
        commentsCount: 24,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      CommunityPost(
        id: 'p2',
        author: users[1],
        content:
            'سؤال للزملاء: ما البديل المتوفر حالياً لـ Concor 5mg في حالة النقص؟ شكراً مقدماً 🙏',
        mentionedDrugs: const ['Concor 5mg'],
        likes: 54,
        commentsCount: 41,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      CommunityPost(
        id: 'p3',
        author: users[2],
        content:
            'مقالة مفيدة عن التداخلات الدوائية لمرضى الضغط والسكري. أنصح بقراءتها!',
        likes: 32,
        commentsCount: 9,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final posts = _posts;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 140),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.groups_rounded,
                  color: AppColors.primary, size: 28),
              const SizedBox(width: 10),
              Text('المجتمع',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: context.textColor)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('آخر النقاشات بين الصيادلة',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: context.muted)),
        ),
        const SizedBox(height: 20),
        ...posts.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _PostCard(post: e.value)
                  .animate()
                  .fadeIn(delay: (e.key * 80).ms)
                  .slideY(begin: 0.1, end: 0),
            )),
      ],
    );
  }
}

class _PostCard extends StatefulWidget {
  final CommunityPost post;
  const _PostCard({required this.post});
  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late int likes = widget.post.likes;
  bool liked = false;

  List<Color> _levelColors(UserLevel l) {
    switch (l) {
      case UserLevel.diamond:
        return [const Color(0xFF22D3EE), const Color(0xFF2563EB)];
      case UserLevel.gold:
        return [const Color(0xFFFACC15), const Color(0xFFD97706)];
      case UserLevel.silver:
        return [const Color(0xFFCBD5E1), const Color(0xFF64748B)];
      case UserLevel.bronze:
        return [const Color(0xFFFB923C), const Color(0xFFEA580C)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: _levelColors(p.author.level)),
                ),
                child: CircleAvatar(
                  backgroundColor: context.bg,
                  child: Text(p.author.name.characters.first,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: context.textColor)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(p.author.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: context.textColor)),
                        ),
                        if (p.author.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded,
                              size: 16, color: AppColors.primary),
                        ],
                      ],
                    ),
                    Text('${p.author.title ?? p.author.role} · ${_ago(p.createdAt)}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: context.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(p.content,
              style: TextStyle(
                  fontSize: 15, height: 1.6, color: context.textColor)),
          if (p.mentionedDrugs.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: p.mentionedDrugs
                  .map((d) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('💊 $d',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary)),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              _action(
                liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                '$likes',
                color: liked ? AppColors.increase : context.muted,
                onTap: () => setState(() {
                  liked = !liked;
                  likes += liked ? 1 : -1;
                }),
              ),
              const SizedBox(width: 20),
              _action(Icons.mode_comment_outlined, '${p.commentsCount}',
                  color: context.muted, onTap: () {}),
              const Spacer(),
              _action(Icons.share_outlined, '', color: context.muted, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String label,
      {required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(fontWeight: FontWeight.w800, color: color)),
          ],
        ],
      ),
    );
  }

  String _ago(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
    return DateFormat('d MMM', 'ar').format(d);
  }
}
