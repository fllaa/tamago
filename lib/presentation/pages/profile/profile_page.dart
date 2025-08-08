import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/app/routes/app_routes.dart';
import 'package:flutter_boilerplate/core/constants/string_constants.dart';
import 'package:flutter_boilerplate/domain/entities/user.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/profile/profile_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProfileViewModel, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileViewModel>().loadUserProfile();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoaded) {
            final user = state.user;
            if (user == null) {
              return const Center(child: Text('No user data available'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Profile header
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Profile image
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: user.profileImage != null
                                ? NetworkImage(user.profileImage!)
                                : null,
                            child: user.profileImage == null
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // User name
                          Text(
                            user.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),

                          // User email
                          Text(
                            user.email,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Edit profile button
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            label: const Text(StringConstants.editProfile),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Account section
                  _buildSection(
                    context,
                    title: 'Account',
                    items: [
                      _buildMenuItem(
                        context,
                        icon: Icons.person_outline,
                        title: 'Personal Information',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.local_shipping_outlined,
                        title: StringConstants.myOrders,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.location_on_outlined,
                        title: 'My Addresses',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.favorite_border,
                        title: StringConstants.wishlist,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Settings section
                  _buildSection(
                    context,
                    title: StringConstants.settings,
                    items: [
                      _buildSwitchMenuItem(
                        context,
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        value: _isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });
                        },
                      ),
                      _buildSwitchMenuItem(
                        context,
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.language_outlined,
                        title: 'Language',
                        trailing: const Text('English'),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.lock_outline,
                        title: 'Privacy & Security',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Support section
                  _buildSection(
                    context,
                    title: 'Support',
                    items: [
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline,
                        title: StringConstants.helpAndSupport,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.info_outline,
                        title: StringConstants.aboutUs,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.description_outlined,
                        title: StringConstants.termsAndConditions,
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.policy_outlined,
                        title: StringConstants.privacyPolicy,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Logout button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(StringConstants.logout),
                              content: const Text(
                                  StringConstants.logoutConfirmation),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(StringConstants.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacementNamed(
                                        context, AppRoutes.login);
                                  },
                                  child: const Text(StringConstants.logout),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(StringConstants.logout),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          // Default state
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
