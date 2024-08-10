import 'package:flutter/material.dart';

class WifiPage extends StatefulWidget {
  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to tab changes and rebuild UI
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTab(String label, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 50,
      width: 125,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.orange.shade700
            : Colors.orange.shade300.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wi-Fi'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              height: 60,
              child: TabBar(
                dividerColor: Theme.of(context).colorScheme.background,
                labelPadding: const EdgeInsets.all(0),
                splashBorderRadius: BorderRadius.circular(30),
                labelStyle: const TextStyle(fontSize: 18),
                unselectedLabelColor: Theme.of(context).colorScheme.tertiary,
                labelColor: Theme.of(context).colorScheme.background,
                controller: _tabController,
                indicator: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                ),
                splashFactory: InkRipple.splashFactory,
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.orange.shade300.withOpacity(0.2)),
                tabs: [
                  _buildTab('Hostel Wi-Fi', _tabController.index == 0),
                  _buildTab('University Wi-Fi', _tabController.index == 1),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  HostelWifiTab(),
                  UniversityWifiTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HostelWifiTab extends StatefulWidget {
  @override
  State<HostelWifiTab> createState() => _HostelWifiTabState();
}

class _HostelWifiTabState extends State<HostelWifiTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hostel Wi-Fi'),
    );
  }
}

class UniversityWifiTab extends StatefulWidget {
  @override
  State<UniversityWifiTab> createState() => _UniversityWifiTabState();
}

class _UniversityWifiTabState extends State<UniversityWifiTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('University Wi-Fi'),
    );
  }
}