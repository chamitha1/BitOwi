import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonExpiryCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDate;

  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onMonthChanged;

  const CommonExpiryCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDate,
    required this.onDaySelected,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime(1900),
      lastDay: DateTime(2100),
      focusedDay: focusedDay,

      startingDayOfWeek: StartingDayOfWeek.sunday,

      rowHeight: 38,
      daysOfWeekHeight: 24,

      selectedDayPredicate: (day) =>
          selectedDate != null && isSameDay(selectedDate, day),

      onPageChanged: onMonthChanged,

      onDaySelected: (selectedDay, _) {
        onDaySelected(selectedDay);
      },

      headerStyle: const HeaderStyle(
        titleCentered: false,
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        headerPadding: EdgeInsets.only(top: 8, bottom: 2),
      ),

      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(),
        todayTextStyle: TextStyle(
          color: Color(0xFF1D5DE5),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        selectedDecoration: BoxDecoration(
          color: Color(0xFFE8EFFF),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          color: Color(0xFF1D5DE5),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        defaultTextStyle: TextStyle(
          color: Color(0xFF151E2F),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        weekendTextStyle: TextStyle(
          color: Color(0xFF151E2F),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),

      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          const labels = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
          return Center(
            child: Text(
              labels[day.weekday % 7],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB9C6E2),
              ),
            ),
          );
        },

        headerTitleBuilder: (context, day) {
          const months = [
            'January','February','March','April','May','June',
            'July','August','September','October','November','December',
          ];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: Text(
                  '${months[day.month - 1]} ${day.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF151E2F),
                  ),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      final d = focusedDay;
                      onMonthChanged(DateTime(d.year, d.month - 1, 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SvgPicture.asset(
                        'assets/icons/merchant_details/ic_previous.svg',
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1D5DE5),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      final d = focusedDay;
                      onMonthChanged(DateTime(d.year, d.month + 1, 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SvgPicture.asset(
                        'assets/icons/merchant_details/ic_next.svg',
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1D5DE5),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
