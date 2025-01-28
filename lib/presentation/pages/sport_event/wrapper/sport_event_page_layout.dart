import 'package:flutter/material.dart';

import '../../../../models/sport_event.dart';
import '../../../../service/auth_service.dart';
import '../../../../styles/my_colors.dart';
import '../../../widgets/navigation_bottom.dart';
import '../../../widgets/sport_event_card.dart';

class SportEventPageLayout extends StatefulWidget {
  final List<SportEvent> sportEvents;
  final int pageNum;
  final Future<void> Function() fetchData;
  final String message;
  final bool isLoading;

  const SportEventPageLayout(
      {super.key,
      required this.sportEvents,
      required this.pageNum,
      required this.fetchData,
      required this.message,
      required this.isLoading});

  @override
  State<SportEventPageLayout> createState() => _SportEventPageLayoutState();
}

class _SportEventPageLayoutState extends State<SportEventPageLayout> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset('lib/data/images/logo.png'),
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.notifications),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  await logoffUser();
                },
                child: const Icon(Icons.logout_outlined),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: refreshData,
            child: Column(
              children: [
                const Divider(
                  color: MyColors.gray,
                  thickness: 2,
                  height: 1,
                ),
                Expanded(
                  child: widget.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : widget.sportEvents.isEmpty
                          ? Center(
                              child: Text(
                                widget.message,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: MyColors.dark,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: widget.sportEvents.length,
                              itemBuilder: (context, index) {
                                final sport = widget.sportEvents[index];
                                return SportEventCard(sport: sport);
                              },
                            ),
                ),
              ],
            )),
        bottomNavigationBar: NavigationBarBottom(
          currentPage: widget.pageNum,
        ));
  }

  Future<void> refreshData() async {
    await widget.fetchData();
  }

  logoffUser() {
    authService.logoff(context);
  }
}
