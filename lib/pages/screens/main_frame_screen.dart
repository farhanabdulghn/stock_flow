import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/extensions/extensions.dart';
import 'package:untitled/pages/screens/login_screen.dart';
import 'package:untitled/pages/screens/product_list_screen.dart';
import 'package:untitled/pages/screens/transaction_product_inbound_screen.dart';
import 'package:untitled/pages/screens/transaction_product_outbound_screen.dart';
import 'package:untitled/states/stores/auth/auth_notifier.dart';
import 'package:untitled/utils/app_route_annotation.dart';
import 'package:untitled/utils/enums.dart';
import 'package:untitled/utils/functions.dart';

@AutoRoute()
class MainFrameScreen extends ConsumerStatefulWidget {
  const MainFrameScreen({super.key});

  @override
  ConsumerState<MainFrameScreen> createState() => _MainFrameScreenState();
}

class _MainFrameScreenState extends ConsumerState<MainFrameScreen> {
  int _currentIndex = 0;

  Future<void> _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          icon: Icon(Icons.logout_rounded, color: colorScheme.error, size: 34),
          title: Text('Keluar dari akun?'),
          content: Text(
            'Anda harus masuk kembali untuk mengakses aplikasi.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    await ref.read(authProvider.notifier).logout();

    if (!mounted) return;

    context.pushAndRemoveUntil(
      LoginScreen(),
      (route) => false,
      transition: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider);

    final role =
        Functions.userRoleFromValue(currentUser?.role) ?? UserRole.operator;

    final pages = role.isAdmin
        ? <Widget>[
            ProductListScreen(),
            TransactionProductInboundScreen(),
            TransactionProductOutboundScreen(),
          ]
        : <Widget>[
            TransactionProductInboundScreen(),
            TransactionProductOutboundScreen(),
          ];

    final items = role.isAdmin
        ? <_NavItem>[
            _NavItem(
              label: 'Barang',
              icon: PhosphorIconsRegular.package,
              activeIcon: PhosphorIconsFill.package,
            ),
            _NavItem(
              label: 'Barang Masuk',
              icon: PhosphorIconsRegular.arrowCircleDown,
              activeIcon: PhosphorIconsFill.arrowCircleDown,
            ),
            _NavItem(
              label: 'Barang Keluar',
              icon: PhosphorIconsRegular.arrowCircleUp,
              activeIcon: PhosphorIconsFill.arrowCircleUp,
            ),
          ]
        : <_NavItem>[
            _NavItem(
              label: 'Barang Masuk',
              icon: PhosphorIconsRegular.arrowCircleDown,
              activeIcon: PhosphorIconsFill.arrowCircleDown,
            ),
            _NavItem(
              label: 'Barang Keluar',
              icon: PhosphorIconsRegular.arrowCircleUp,
              activeIcon: PhosphorIconsFill.arrowCircleUp,
            ),
          ];

    final safeIndex = _currentIndex >= pages.length ? 0 : _currentIndex;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: safeIndex, children: pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _CustomNavBar(
        currentIndex: safeIndex,
        items: items,
        role: role,
        onTap: (index) => setState(() => _currentIndex = index),
        onLogout: _showLogoutConfirmation,
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar({
    required this.currentIndex,
    required this.items,
    required this.role,
    required this.onTap,
    required this.onLogout,
  });

  final int currentIndex;
  final List<_NavItem> items;
  final UserRole role;
  final ValueChanged<int> onTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(items.length, (index) {
              final isSelected = index == currentIndex;
              final item = items[index];

              return Semantics(
                button: true,
                selected: isSelected,
                label: item.label,
                child: InkWell(
                  onTap: () {
                    onTap(index);
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    height: 42,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 14 : 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            key: ValueKey(isSelected),
                            size: 18,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          child: isSelected
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.labelMedium?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            Container(
              width: 1,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: colorScheme.outlineVariant,
            ),

            Tooltip(
              message: '${role.label} — Keluar dari akun',
              child: InkWell(
                onTap: onLogout,
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(
                    PhosphorIconsRegular.signOut,
                    size: 19,
                    color: colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
