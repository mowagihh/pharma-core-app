/// Community models mirroring the original types.ts.
enum UserLevel { bronze, silver, gold, diamond }

class CommunityUser {
  final String id;
  final String name;
  final bool isVerified;
  final UserLevel level;
  final int points;
  final String role; // pharmacist | student | doctor | admin
  final String? title;
  final String? location;

  const CommunityUser({
    required this.id,
    required this.name,
    this.isVerified = false,
    this.level = UserLevel.bronze,
    this.points = 0,
    this.role = 'pharmacist',
    this.title,
    this.location,
  });
}

class CommunityPost {
  final String id;
  final CommunityUser author;
  final String content;
  final List<String> mentionedDrugs;
  final int likes;
  final int commentsCount;
  final DateTime createdAt;

  const CommunityPost({
    required this.id,
    required this.author,
    required this.content,
    this.mentionedDrugs = const [],
    this.likes = 0,
    this.commentsCount = 0,
    required this.createdAt,
  });
}
