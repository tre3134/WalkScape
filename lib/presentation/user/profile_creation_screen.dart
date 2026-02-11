import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../core/user_database.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  late UserDatabase _userDb;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  String _selectedAvatar = 'avatar_1';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _avatarOptions = [
    {
      'id': 'avatar_1',
      'image': 'https://images.unsplash.com/photo-1705408115513-3ff15ef55a8d',
      'name': 'Adventure Seeker'
    },
    {
      'id': 'avatar_2',
      'image': 'https://images.unsplash.com/photo-1587401095394-725003c9bea1',
      'name': 'Fitness Warrior'
    },
    {
      'id': 'avatar_3',
      'image': 'https://images.unsplash.com/photo-1576921874520-1c3fa53f2674',
      'name': 'Trail Runner'
    },
    {
      'id': 'avatar_4',
      'image': 'https://images.unsplash.com/photo-1680310381169-5ccb4b532517',
      'name': 'Step Master'
    },
    {
      'id': 'avatar_5',
      'image': 'https://images.unsplash.com/photo-1696453685422-34d5c0ddd4c3',
      'name': 'Mountain Walker'
    },
    {
      'id': 'avatar_6',
      'image': 'https://images.unsplash.com/photo-1687699875541-f073e9086676',
      'name': 'Park Explorer'
    },
  ];

  @override
  @override
  void initState() {
    super.initState();
    _userDb = UserDatabase('user_db.json');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();

    // Check for unique username/email
    if (_userDb.usernameOrEmailExists(username, email)) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username or email already in use.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      // Add to user database
      _userDb.addUser(username, email, '');

      await prefs.setString('user_username', username);
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', name);
      await prefs.setString('user_avatar', _selectedAvatar);
      await prefs.setBool('profile_created', true);
      await prefs.setInt('user_level', 1);
      await prefs.setInt('user_xp', 0);
      await prefs.setInt('user_total_steps', 0);

      // Navigate to home dashboard
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home-dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Create Your Profile',
        variant: CustomAppBarVariant.profile,
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),

                // Welcome text
                Text(
                  'Welcome to WalkScape!',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 1.h),

                Text(
                  'Create your adventurer profile to start your fitness journey',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 4.h),

                // Avatar Selection
                Text(
                  'Choose Your Avatar',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 2.h),

                // Avatar Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 2.w,
                  ),
                  itemCount: _avatarOptions.length,
                  itemBuilder: (context, index) {
                    final avatar = _avatarOptions[index];
                    final isSelected = _selectedAvatar == avatar['id'];

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAvatar = avatar['id']);
                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Stack(
                            children: [
                              CustomImageWidget(
                                imageUrl: avatar['image'],
                                width: double.infinity,
                                height: 20.w,
                                fit: BoxFit.cover,
                              ),
                              if (isSelected)
                                Container(
                                  width: double.infinity,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: theme.colorScheme.onPrimary,
                                    size: 6.w,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 4.h),

                // Form Fields
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    hintText: 'Enter your display name',
                    prefixIcon: Icon(Icons.person, color: theme.colorScheme.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your display name';
                    }
                    if (value.trim().length < 2) {
                      return 'Display name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 2.h),

                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Choose a unique username',
                    prefixIcon: Icon(Icons.alternate_email, color: theme.colorScheme.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.trim().length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
                      return 'Username can only contain letters, numbers, and underscores';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 2.h),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email (Optional)',
                    hintText: 'Enter your email address',
                    prefixIcon: Icon(Icons.email, color: theme.colorScheme.primary),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                    }
                    return null;
                  },
                ),

                SizedBox(height: 6.h),

                // Create Profile Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            'Start Your Adventure!',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}