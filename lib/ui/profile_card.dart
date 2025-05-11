// widgets/profile_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xff5d3f3e)
      ),
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (!authSnapshot.hasData) {
            return _buildGuestProfile();
          }

          final user = authSnapshot.data!;
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('profiles')
                .doc(user.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return _buildLoadingProfile(user);
              }

              final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
              return _buildUserProfile(user, userData ?? {});
            },
          );
        },
      )
    );
  }

  Widget _buildLoadingProfile(User user) {
    return ListTile(
      leading: const CircleAvatar(
        child: CircularProgressIndicator(),
      ),
      title: Text(user.email ?? 'No email'),
      subtitle: const Text('Loading...'),
    );
  }

  Widget _buildUserProfile(User user, Map<String, dynamic> userData) {
    final String? avatar = userData['profilePictureURL'];
    final String? name = userData['fullName']?.toString();
    final String? email = user.email;

    return ListTile(
      leading: _buildProfileAvatar(avatar, name, email),
      title: Text(
        userData['name']?.toString() ?? user.email ?? 'Anonymous',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(user.email ?? 'No email'),
    );
  }

  String _getInitials(String? name, String? email) {
    if (name != null && name.isNotEmpty) {
      final nameParts = name.trim().split(' ');
      if (nameParts.length > 1) {
        return '${nameParts[0][0]}${nameParts.last[0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return '';
  }

  Widget _buildProfileAvatar(String? imageUrl, String? name, String? email) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: CachedNetworkImageProvider(imageUrl),
        onBackgroundImageError: (exception, stackTrace) =>
            _buildFallbackAvatar(name, email),
      );
    }
    return _buildFallbackAvatar(name, email);
  }

  Widget _buildFallbackAvatar(String? name, String? email) {
    final String initials = _getInitials(name, email);
    return CircleAvatar(
      backgroundColor: Colors.blue.shade800,
      child: initials.isNotEmpty
          ? Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      )
          : const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildGuestProfile() {
    return const ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text('Guest'),
      subtitle: Text('Please sign in'),
    );
  }
}