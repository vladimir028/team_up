import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/data/account/sport_selection/sport_selection.dart';
import 'package:team_up/models/enum/court_type.dart';
import 'package:team_up/presentation/widgets/input_field.dart';
import 'package:team_up/service/auth_service.dart';
import 'package:team_up/service/sport_service.dart';
import 'package:toastification/toastification.dart';

import '../../global/toast.dart';
import '../../models/sport_event.dart';
import '../../styles/my_colors.dart';
import '../widgets/dropdownlist.dart';
import '../widgets/navigation_bottom.dart';
import '../widgets/navigation_routes.dart';
import '../widgets/player_counter.dart';
import '../widgets/styled_button.dart';

class SportForm extends StatefulWidget {
  const SportForm({super.key});

  @override
  SportFormState createState() => SportFormState();
}

class SportFormState extends State<SportForm> {
  final TextEditingController _scheduledTimeStartController =
      TextEditingController();
  final TextEditingController _scheduledTimeEndController =
      TextEditingController();
  final TextEditingController _pricePerHourController = TextEditingController();
  final TextEditingController _totalPlayersController = TextEditingController();
  final TextEditingController _missingPlayersController =
      TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay scheduledTimeStart = TimeOfDay.now();
  TimeOfDay scheduledTimeEnd = TimeOfDay.now();
  CourtType selectedCourtType = CourtType.indoor;
  Sport selectedSport = SportSelection.sports[0];

  SportService sportService = SportService();
  AuthService authService = AuthService();

  void _pickTime(TextEditingController controller, TimeOfDay? scheduledTime, Function(TimeOfDay) updateScheduledTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: scheduledTime ?? TimeOfDay.now(),
    );
    if (selectedTime != null && mounted) {
      final formattedTime = selectedTime.format(context);
      setState(() {
        controller.text = formattedTime;
        updateScheduledTime(TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute));
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sport Form")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: MyDropdownButton<Sport>(
                        value: selectedSport,
                        items: SportSelection.sports,
                        onChanged: (Sport? newValue) {
                          setState(() {
                            selectedSport = newValue!;
                          });
                        },
                        itemLabel: (sport) => sport.name,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MyDropdownButton<CourtType>(
                        value: selectedCourtType,
                        items: CourtType.values,
                        onChanged: (CourtType? newValue) {
                          setState(() {
                            selectedCourtType = newValue!;
                          });
                        },
                        itemLabel: (courtType) =>
                            courtType.toString().split('.').last,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                StyledButton(
                  onPressed: () => _selectDate(context),
                  label: selectedDate == null
                      ? "Select Date"
                      : "${selectedDate!.toLocal()}".split(' ')[0],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        controller: _scheduledTimeStartController,
                        hintText: "Starting time",
                        onTap: () => _pickTime(
                          _scheduledTimeStartController,
                          scheduledTimeStart,
                              (newTime) {
                            setState(() {
                              scheduledTimeStart = newTime;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputField(
                        controller: _scheduledTimeEndController,
                        hintText: "Ending time",
                        onTap: () => _pickTime(
                          _scheduledTimeEndController,
                          scheduledTimeEnd,
                              (newTime) {
                            setState(() {
                              scheduledTimeEnd = newTime;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                InputField(
                  controller: _pricePerHourController,
                  hintText: "Price Per Hour",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                InputField(
                  controller: latController,
                  hintText: "Latitude",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                InputField(
                  controller: lngController,
                  hintText: "Longitude",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(
                    child: PlayerCounterWidget(
                      labelText: "Total Players As Of Now",
                      controller: _totalPlayersController,
                      onIncrement: () {
                        setState(() {
                          int currentValue =
                              int.tryParse(_totalPlayersController.text) ?? 0;
                          _totalPlayersController.text =
                              (currentValue + 1).toString();
                        });
                      },
                      onDecrement: () {
                        setState(() {
                          int currentValue =
                              int.tryParse(_totalPlayersController.text) ?? 0;
                          _totalPlayersController.text = (currentValue - 1)
                              .clamp(0, double.infinity)
                              .toString();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: PlayerCounterWidget(
                      labelText: "Missing Players",
                      controller: _missingPlayersController,
                      onIncrement: () {
                        setState(() {
                          int currentValue =
                              int.tryParse(_missingPlayersController.text) ?? 0;
                          _missingPlayersController.text =
                              (currentValue + 1).toString();
                        });
                      },
                      onDecrement: () {
                        setState(() {
                          int currentValue =
                              int.tryParse(_missingPlayersController.text) ?? 0;
                          _missingPlayersController.text = (currentValue - 1)
                              .clamp(0, double.infinity)
                              .toString();
                        });
                      },
                    ),
                  ),
                ]),
                const SizedBox(height: 30),
                // Submit button
                NavigationRoutes(
                  descriptionButton: "Submit",
                  routeButton: "/home",
                  descriptionRegular: "",
                  descriptionBold: "",
                  descriptionRoute: "",
                  onTap: addSportEvent,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavigationBarBottom(currentPage: 3),
    );
  }

  void addSportEvent() async {
    final sport = SportEvent(
      sportName: selectedSport.name,
      sportImageUrl: selectedSport.imgUrl,
      duration:
          calculateMinutesDifference(scheduledTimeEnd, scheduledTimeStart),
      pricePerHour: int.parse(_pricePerHourController.text),
      totalPlayersAsOfNow: int.parse(_totalPlayersController.text),
      missingPlayers: int.parse(_missingPlayersController.text),
      userId: authService.getCurrentUser().uid,
      location: GeoPoint(
          double.parse(latController.text), double.parse(lngController.text)),
      startingTime: scheduledTimeStart,
      endingTime: scheduledTimeEnd,
      selectedDate: selectedDate ?? DateTime.now(),
      courtType: selectedCourtType,
    );

    SportEvent? savedSport = await sportService.addSport(sport, context);
    if (savedSport != null && mounted) {
      Toast toast = Toast(
          ToastificationType.success,
          "Sport event created successfully",
          "You can edit your event in the future",
          Icons.check,
          MyColors.support.success);
      toast.showToast();

      Navigator.pushNamed(context, "/home");
    }
  }

  int calculateMinutesDifference(
      TimeOfDay scheduledTimeEnd, TimeOfDay scheduledTimeStart) {
    int startMinutes = scheduledTimeStart.hour * 60 + scheduledTimeStart.minute;
    int endMinutes = scheduledTimeEnd.hour * 60 + scheduledTimeEnd.minute;

    return (endMinutes - startMinutes).abs();
  }
}
