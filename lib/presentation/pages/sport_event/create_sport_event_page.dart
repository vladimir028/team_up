import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/data/account/sport_selection/sport_selection.dart';
import 'package:team_up/models/enum/court_type.dart';
import 'package:team_up/provider/sport_form_provider.dart';
import 'package:toastification/toastification.dart';

import '../../../global/toast.dart';
import '../../../models/sport_event.dart';
import '../../../styles/my_colors.dart';
import '../../widgets/dropdownlist.dart';
import '../../widgets/navigation_bottom.dart';
import '../../widgets/navigation_routes.dart';
import '../../widgets/player_counter.dart';
import '../../widgets/styled_button.dart';

class SportForm extends StatefulWidget {
  const SportForm({super.key});

  @override
  State<StatefulWidget> createState() => _SportFormState();
}

class _SportFormState extends State<SportForm> {
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SportFormProvider>(context, listen: true);

    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(title: const Text("Sport Form")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: MyDropdownButton<Sport>(
                        value: provider.selectedSport,
                        items: SportSelection.sports,
                        onChanged: (Sport? newValue) {
                          provider.updateSelectedSport(newValue!);
                        },
                        itemLabel: (sport) => sport.name,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MyDropdownButton<CourtType>(
                        value: provider.selectedCourtType,
                        items: CourtType.values,
                        onChanged: (CourtType? newValue) {
                          provider.updateSelectedCourtType(newValue!);
                        },
                        itemLabel: (courtType) =>
                            courtType.toString().split('.').last,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FormField<DateTime>(
                  builder: (FormFieldState<DateTime> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledButton(
                          onPressed: () => provider.selectDate(context),
                          label: provider.selectedDate == null
                              ? "Select Date"
                              : "${provider.selectedDate!.toLocal()}"
                                  .split(' ')[0],
                        ),
                        if (state.hasError)
                          Text(
                            state.errorText ?? '',
                            style: TextStyle(color: MyColors.support.formError),
                          ),
                      ],
                    );
                  },
                  validator: (value) {
                    DateTime now = DateTime.now();
                    if (provider.selectedDate == null) {
                      return 'Please select a date';
                    }
                    if (provider.selectedDate!.day < now.day) {
                      return 'The date must be today or in the future';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: provider.scheduledTimeStartController,
                        decoration:
                            const InputDecoration(hintText: "Start time"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter start time';
                          }
                          TimeOfDay time = TimeOfDay(
                              hour: int.parse(value.split(":")[0]),
                              minute: int.parse(value.split(":")[1]));
                          if (provider.selectedDate!
                                  .isAtSameMomentAs(DateTime.now()) &&
                              !provider.isAfter(time, TimeOfDay.now())) {
                            return 'Time must be in the future';
                          }
                          return null;
                        },
                        onTap: () => provider.pickTime(context, true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: provider.scheduledTimeEndController,
                        decoration: const InputDecoration(hintText: "End time"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter end time';
                          }
                          TimeOfDay time = TimeOfDay(
                              hour: int.parse(value.split(":")[0]),
                              minute: int.parse(value.split(":")[1]));
                          if (!provider.isAfter(
                              time, provider.scheduledTimeStart!)) {
                            return 'End time must be after start time';
                          }
                          return null;
                        },
                        onTap: () => provider.pickTime(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: provider.pricePerHourController,
                  decoration: const InputDecoration(hintText: "Price Per Hour"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price per hour';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Price must be a number';
                    }
                    if (int.tryParse(value)!.isNegative) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onChanged: (value) => provider.updatePricePerHour(value),
                ),
                const SizedBox(height: 16),
                StyledButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/map_picker'),
                    label: 'Choose Location'),
                // InputField(
                //   controller: latController,
                //   hintText: "Latitude",
                //   keyboardType: TextInputType.number,
                // ),
                // const SizedBox(height: 16),
                // InputField(
                //   controller: lngController,
                //   hintText: "Longitude",
                //   keyboardType: TextInputType.number,
                // ),
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(
                    child: PlayerCounterWidget(
                      labelText: "Total Players As Of Now",
                      controller: provider.totalPlayersController,
                      onIncrement: () => provider.increaseTotalPlayers(),
                      onDecrement: () => provider.decreaseTotalPlayers(),
                    ),
                  ),
                  Expanded(
                    child: PlayerCounterWidget(
                      labelText: "Missing Players",
                      controller: provider.missingPlayersController,
                      onIncrement: () => provider.increaseMissingPlayers(),
                      onDecrement: () => provider.decreaseMissingPlayers(),
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
                    onTap: () async {
                      if (!mounted) return;
                      if (!_key.currentState!.validate()) return;
                      provider.addSportEvent();
                      _key.currentState!.reset();
                      Navigator.pushNamed(context, "/home");
                    }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavigationBarBottom(currentPage: 3),
      ),
    );
  }
}
