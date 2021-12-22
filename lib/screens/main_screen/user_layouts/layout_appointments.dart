import 'package:firebase_auth_practice/helpers/styles.dart';
import 'package:firebase_auth_practice/item_layouts/item_appointment_slot.dart';
import 'package:firebase_auth_practice/models/slot.dart';
import 'package:firebase_auth_practice/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class LayoutAppointments extends StatefulWidget {
  double amount;

  @override
  _LayoutAppointmentsState createState() => _LayoutAppointmentsState();
  List<Slot> slots;
  String service_id, barber_id;

  LayoutAppointments({
    required this.amount,
    required this.slots,
    required this.service_id,
    required this.barber_id,
  });
}

class _LayoutAppointmentsState extends State<LayoutAppointments> {
  Map<DateTime, List<NeatCleanCalendarEvent>> calenderMap = Map();

  var gridController = ScrollController();

  var expanded = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 12),
            child: Text(
              "Choose a slot",
              style: red_h2Style_bold,
            ),
          ),
          Expanded(
            child: Calendar(
              hideBottomBar: true,
              startOnMonday: true,
              weekDays: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
              events: getEventsFromSlots(widget.slots),
              eventDoneColor: Colors.green,
              selectedColor: Colors.red,
              isExpanded: true,
              onRangeSelected: (data) {},
              todayColor: Colors.redAccent,
              // dayBuilder: (BuildContext context, DateTime day) {
              //   return new Text("!");
              // },
              hideTodayIcon: true,
              eventListBuilder: (BuildContext context,
                  List<NeatCleanCalendarEvent> _selectedEvents) {
                return Expanded(
                    child: _selectedEvents.length > 0
                        ? new GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                            addAutomaticKeepAlives: true,
                            itemBuilder: (context, index) {
                              return ItemEventSlot(
                                amount: widget.amount,
                                slot_id: _selectedEvents[index].summary,
                                isAvailable: _selectedEvents[index].isDone,
                                dateTime: _selectedEvents[index].startTime,
                                barber_id: widget.barber_id,
                                service_id: widget.service_id,
                              );
                            },
                            controller: gridController,
                            itemCount: _selectedEvents.length,
                          )
                        : NotFound(
                            message: "No Slots Available",
                            color: Colors.red,
                          ));
              },
              eventColor: Colors.grey,
              locale: 'en_PK',
              todayButtonText: 'Today',
              expandableDateFormat: 'EEEE, dd. MMMM yyyy',
              dayOfWeekStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // void updatedSlots(Map<DateTime, List<Slot>> slotsMap) {
  //   // TODO: implement updatedSlots
  //
  //   calenderMap = Map();
  //
  //   for (var mapEntry in slotsMap.entries) {
  //     List<NeatCleanCalendarEvent> events = [];
  //     for (var slot in mapEntry.value) {
  //       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(slot.timestamp);
  //       events.add(NeatCleanCalendarEvent(
  //         slot.slot_id,
  //         startTime: dateTime,
  //         endTime: dateTime,
  //         isDone: slot.available,
  //       ));
  //     }
  //
  //     MapEntry<DateTime, List<NeatCleanCalendarEvent>> calenderEntry =
  //         MapEntry(mapEntry.key, events);
  //
  //     setState(() {
  //       calenderMap.addAll({calenderEntry.key: calenderEntry.value});
  //       expanded = !expanded;
  //     });
  //
  //   }
  // }

  // final Map<DateTime, List<NeatCleanCalendarEvent>> _events = {
  //   DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
  //     NeatCleanCalendarEvent('Event A',
  //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day, 10, 0),
  //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day, 12, 0),
  //         description: 'A special event',
  //         color: Colors.blue[700]),
  //   ],
  //   DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2):
  //       [
  //     NeatCleanCalendarEvent('Event B',
  //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day + 2, 10, 0),
  //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day + 2, 12, 0),
  //         color: Colors.orange),
  //     NeatCleanCalendarEvent('Event C',
  //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day + 2, 14, 30),
  //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
  //             DateTime.now().day + 2, 17, 0),
  //         color: Colors.pink),
  //   ],
  // };

  // Map<DateTime, List<NeatCleanCalendarEvent>> temp = {
  //   DateTime.now(): [
  //     NeatCleanCalendarEvent("summary",
  //         startTime: DateTime.now(), endTime: DateTime.now()),
  //     NeatCleanCalendarEvent("summary",
  //         startTime: DateTime.now(), endTime: DateTime.now()),
  //     NeatCleanCalendarEvent("summary",
  //         startTime: DateTime.now(), endTime: DateTime.now()),
  //   ],
  //   DateTime.now(): [
  //     NeatCleanCalendarEvent("summary",
  //         startTime: DateTime.now(), endTime: DateTime.now()),
  //     NeatCleanCalendarEvent("summary",
  //         startTime: DateTime.now(), endTime: DateTime.now()),
  //     NeatCleanCalendarEvent("summary",
  //         startTime: DateTime.now(), endTime: DateTime.now()),
  //   ],
  // };

  Map<DateTime, List<NeatCleanCalendarEvent>> getEventsFromSlots(
      List<Slot> slots) {
    Map<DateTime, List<NeatCleanCalendarEvent>> eventsMap = Map();

    for (Slot slot in slots) {
      int timestamp = slot.timestamp;
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp);

      DateTime x = DateTime(date.year, date.month, date.day);
      NeatCleanCalendarEvent event = NeatCleanCalendarEvent(slot.slot_id,
          startTime: date,
          endTime: date,
          isDone: (slot.available &&
              slot.timestamp > DateTime.now().millisecondsSinceEpoch));

      if (!eventsMap.containsKey(x)) {
        eventsMap.addAll({x: []});
      }
      eventsMap.update(x, (value) {
        value.add(event);

        return value;
      });
    }

    print(eventsMap);

    return eventsMap;
  }

// List<Slot> getRandomSlots() {
//   List<Slot> slots = [];
//
//   for (int i = 0; i < 20; i++) {
//     DateTime now = DateTime.now();
//     DateTime dateTime1 = DateTime(now.year, now.month, now.day, 5 + i, 10, 0);
//     DateTime dateTime2 = DateTime(now.year, now.month, now.day + i, 5, 10, 0);
//
//     slots.add(Slot(
//         slot_id: "slot_id",
//         barber_id: "barber_id",
//         user_id: "user_id",
//         service_id: "service_id",
//         timestamp: dateTime1.millisecondsSinceEpoch,
//         available: (i % 2 == 0)));
//
//     slots.add(Slot(
//         slot_id: "slot_id",
//         barber_id: "barber_id",
//         user_id: "user_id",
//         service_id: "service_id",
//         timestamp: dateTime2.millisecondsSinceEpoch,
//         available: (i % 2 == 0)));
//   }
//
//   return slots;
// }
}
