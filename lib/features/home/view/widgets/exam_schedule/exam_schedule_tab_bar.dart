import 'package:flutter/material.dart';

class ExamScheduleTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController tabController;

  const ExamScheduleTabBar({
    super.key,
    required this.tabController,
  });

  Widget _buildTab(String label) {
    return Container(
      height: 40,
      width: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Tab(
        child: Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: Theme.of(context).colorScheme.surface,
      labelPadding: const EdgeInsets.all(0),
      splashBorderRadius: BorderRadius.circular(14),
      labelStyle: const TextStyle(fontSize: 18),
      unselectedLabelColor: Theme.of(context).colorScheme.onSecondaryContainer,
      labelColor: Theme.of(context).colorScheme.onSecondaryContainer,
      controller: tabController,
      indicator: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      splashFactory: InkRipple.splashFactory,
      overlayColor: WidgetStateColor.resolveWith(
        (states) => Theme.of(context).colorScheme.secondaryContainer,
      ),
      tabs: [
        _buildTab("CAT - 1"),
        _buildTab("CAT - 2"),
        _buildTab("FAT"),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
