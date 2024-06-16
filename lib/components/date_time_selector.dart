import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeSelector extends StatefulWidget
{
  final ValueChanged<DateTime> onChange;
  final bool allDay;
  final DateTime defaultTime;
  const DateTimeSelector({super.key, required this.onChange, required this.defaultTime, this.allDay = false});

  @override
  State<StatefulWidget> createState() => _DateTimeSelector();
}

class _DateTimeSelector extends State<DateTimeSelector>
{
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  DateTime minSelectableRange = DateTime.now();
  DateTime maxSelectableRange = DateTime.now().add( const Duration(days: 365));

  @override
  void initState() 
  {
    selectedDate = DateTime
    (
      widget.defaultTime.year,
      widget.defaultTime.month,
      widget.defaultTime.day
    );

    selectedTime = TimeOfDay.fromDateTime(widget.defaultTime);

    super.initState();
  }

  void notifyValueChanged()
  {
    DateTime date = DateTime
    (
      selectedDate.year,
      selectedDate.month,
      selectedDate.day
    );
    if(!widget.allDay)
    {
      date.add(Duration(hours: selectedTime.hour, minutes: selectedTime.minute));
    }

    widget.onChange(date);
  }

  @override
  Widget build(BuildContext context) {
    return Row
    (
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: 
      [
        TextButton
        (
          onPressed: () async
          {
            DateTime? selectedStartTime = await showDatePicker
            (
              context: context, 
              firstDate: minSelectableRange, 
              lastDate: maxSelectableRange, 
              initialDate: selectedDate
            );
            if(selectedStartTime != null)
            {
              setState(() 
              {
                selectedDate = selectedStartTime;
              });
              notifyValueChanged();
            }
          }, 
          child: Text(DateFormat("EEE, MMM d, yyyy").format(selectedDate))
        ),
        Visibility
        (
          visible: !widget.allDay,
          child: TextButton
          (
            onPressed: () async
            {
              TimeOfDay? selectedStartTime = await showTimePicker(context: context, initialTime: selectedTime);
              if(selectedStartTime != null)
              {
                setState(() 
                {
                  selectedTime = selectedStartTime;
                });
                notifyValueChanged();
              }
            }, 
            child: Text(selectedTime.format(context))
          )
        ),
      ],
    );
  }
}