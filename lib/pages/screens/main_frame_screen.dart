import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/pages/screens/inbound_product_transaction.dart';
import 'package:untitled/pages/screens/outbound_product_transaction.dart';
import 'package:untitled/pages/screens/product_list_screen.dart';
import 'package:untitled/utils/app_route_annotation.dart';

@AutoRoute()
class MainFrameScreen extends StatefulWidget {
  const MainFrameScreen({super.key});

  @override
  State<MainFrameScreen> createState() => _MainFrameScreenState();
}

class _MainFrameScreenState extends State<MainFrameScreen> {
  int _currentIndex = 0;

  static const _pages = [
    ProductListScreen(),
    InboundProductTransaction(),
    OutboundProductTransaction(),
  ];

  static const _items = [
    _NavItem(
      label: 'List Barang',
      icon: PhosphorIconsRegular.house,
      activeIcon: PhosphorIconsFill.house,
    ),
    _NavItem(
      label: 'Transaksi Barang Masuk',
      icon: PhosphorIconsRegular.archive,
      activeIcon: PhosphorIconsFill.archive,
    ),
    _NavItem(
      label: 'Transaksi Barang Keluar',
      icon: PhosphorIconsRegular.user,
      activeIcon: PhosphorIconsFill.user,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _CustomNavBar(
        currentIndex: _currentIndex,
        items: _items,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class _CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _CustomNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (i) {
          final isSelected = i == currentIndex;
          final item = items[i];

          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: 40,
              padding: isSelected
                  ? EdgeInsets.only(left: 14, right: 16, top: 8, bottom: 8)
                  : EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF3F55C6) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? item.activeIcon : item.icon,
                    size: 16,
                    color: isSelected ? Color(0xFFFAFAFA) : Color(0xFF71747D),
                  ),
                  AnimatedSize(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: isSelected
                        ? Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Text(
                              item.label,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFAFAFA),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
