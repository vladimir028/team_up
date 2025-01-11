import 'package:flutter/material.dart';
import 'package:team_up/models/sport_event.dart';

import '../../styles/my_colors.dart';

class SportEventCard extends StatefulWidget {
  final SportEvent sport;
  const SportEventCard({super.key, required this.sport});

  @override
  State<SportEventCard> createState() => _SportEventCardState();
}

class _SportEventCardState extends State<SportEventCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              widget.sport.sportImageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_offer_rounded,
                        color: MyColors.primary.pink900),
                    const SizedBox(width: 8),
                    Text("\$${widget.sport.pricePerHour}/hour",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.group, color: MyColors.primary.pink900),
                    const SizedBox(width: 8),
                    Text("Missing Players: ${widget.sport.missingPlayers}",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, color: MyColors.primary.pink900),
                    const SizedBox(width: 8),
                    Text(
                        "Time: ${widget.sport.startingTime.format(context)} - ${widget.sport.endingTime.format(context)}, ${widget.sport.duration}min",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        color: MyColors.primary.pink900),
                    const SizedBox(width: 8),
                    Text(getFormatedDate(widget.sport),
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary.pink500,
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/sport_detail",
                          arguments: widget.sport,
                        );
                      },
                      child: const Text(
                        "Details",
                        style: TextStyle(color: MyColors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getFormatedDate(SportEvent sport) {
    String dayOfWeek = getDay(sport.selectedDate.weekday);
    return "Date: ${sport.selectedDate.toLocal().toString().split(' ')[0]}, $dayOfWeek";
  }

  String getDay(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "/";
    }
  }
}
