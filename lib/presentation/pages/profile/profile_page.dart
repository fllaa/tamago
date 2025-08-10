import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/app/app.dart';
import 'package:flutter_boilerplate/app/routes/app_routes.dart';
import 'package:flutter_boilerplate/core/localization/app_localizations.dart';
import 'package:flutter_boilerplate/domain/entities/user.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/profile/profile_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Update the theme mode when system theme changes
    _loadThemeMode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update the theme mode when app theme changes
    _loadThemeMode();
  }

  void _loadThemeMode() {
    if (!mounted) return;
    final appState = App.of(context);
    setState(() {
      _isDarkMode = appState.themeMode == ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('profile')),
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
                    child:
                        Text(AppLocalizations.of(context).translate('retry')),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoaded) {
            final user = state.user;
            if (user == null) {
              return Center(
                  child: Text(
                      AppLocalizations.of(context).translate('genericError')));
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
                            label: Text(AppLocalizations.of(context)
                                .translate('editProfile')),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Account section
                  _buildSection(
                    context,
                    title: AppLocalizations.of(context).translate('account'),
                    items: [
                      _buildMenuItem(
                        context,
                        icon: Icons.person_outline,
                        title: AppLocalizations.of(context)
                            .translate('personalInformation'),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.local_shipping_outlined,
                        title:
                            AppLocalizations.of(context).translate('myOrders'),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.location_on_outlined,
                        title: AppLocalizations.of(context)
                            .translate('myAddresses'),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.favorite_border,
                        title:
                            AppLocalizations.of(context).translate('wishlist'),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Settings section
                  _buildSection(
                    context,
                    title: AppLocalizations.of(context).translate('settings'),
                    items: [
                      _buildSwitchMenuItem(
                        context,
                        icon: Icons.dark_mode_outlined,
                        title:
                            AppLocalizations.of(context).translate('darkMode'),
                        value: _isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });

                          // Update the app theme
                          final appState = App.of(context);
                          appState.updateThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                      _buildSwitchMenuItem(
                        context,
                        icon: Icons.notifications_outlined,
                        title: AppLocalizations.of(context)
                            .translate('notifications'),
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
                        title:
                            AppLocalizations.of(context).translate('language'),
                        trailing: _buildLanguageTrailing(context),
                        onTap: () => _showLanguageDialog(context),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.lock_outline,
                        title: AppLocalizations.of(context)
                            .translate('privacyAndSecurity'),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Support section
                  _buildSection(
                    context,
                    title: AppLocalizations.of(context).translate('support'),
                    items: [
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline,
                        title: AppLocalizations.of(context)
                            .translate('helpAndSupport'),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.info_outline,
                        title:
                            AppLocalizations.of(context).translate('aboutUs'),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.description_outlined,
                        title: AppLocalizations.of(context)
                            .translate('termsAndConditions'),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.policy_outlined,
                        title: AppLocalizations.of(context)
                            .translate('privacyPolicy'),
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
                          final profileContext =
                              context; // Capture the context with access to the provider
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text(AppLocalizations.of(dialogContext)
                                  .translate('logout')),
                              content: Text(AppLocalizations.of(dialogContext)
                                  .translate('logoutConfirmation')),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: Text(AppLocalizations.of(dialogContext)
                                      .translate('cancel')),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    profileContext
                                        .read<ProfileViewModel>()
                                        .logout()
                                        .then((_) {
                                      Navigator.pushReplacementNamed(
                                          profileContext, AppRoutes.login);
                                    });
                                  },
                                  child: Text(AppLocalizations.of(dialogContext)
                                      .translate('logout')),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: Text(
                            AppLocalizations.of(context).translate('logout')),
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
          return const Center(child: Text(''));
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

  Widget _buildLanguageTrailing(BuildContext context) {
    final locale = Localizations.localeOf(context);
    String languageName = AppLocalizations.of(context).translate('english');

    if (locale.languageCode == 'id') {
      languageName = AppLocalizations.of(context).translate('bahasaIndonesia');
    }

    return Text(languageName);
  }

  void _showLanguageDialog(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context).translate('english')),
                trailing: currentLocale.languageCode == 'en'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  App.updateLanguage(context, 'en');
                },
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('bahasaIndonesia')),
                trailing: currentLocale.languageCode == 'id'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  App.updateLanguage(context, 'id');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
