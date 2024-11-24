import 'package:flutter/material.dart';

class TimeSlotScreen extends StatefulWidget {
  final int auditoriumNumber; // Accept auditorium number
  final DateTime selectedDate; // Accept selected date

  TimeSlotScreen({
    required this.auditoriumNumber,
    required this.selectedDate,
  });

  @override
  _TimeSlotScreenState createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  // List of time slots with ranges
  List<String> timeSlots = [
    '9:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 1:00 PM',
    '1:00 PM - 2:00 PM',
    '2:00 PM - 3:00 PM',
    '3:00 PM - 4:00 PM',
    '4:00 PM - 5:00 PM',
  ];

  // Initialize isSlotBooked with the same length as timeSlots and set them to false
  List<bool> isSlotBooked = List.filled(8, false); // Initialize as not booked

  @override
  void initState() {
    super.initState();
    // Load any booked slots (can be saved locally or fetched from a DB)
    _loadBookedSlots();
  }

  _loadBookedSlots() async {
    // Load booked slots from SharedPreferences or local storage
    // Assuming you've stored the booked slots in SharedPreferences
    // You can update `isSlotBooked` list based on data from storage if needed
  }

  _saveBookedSlots() async {
    // Save booked slots to SharedPreferences or local storage
    // Example: You can store the `isSlotBooked` list to SharedPreferences
  }

  _bookSlot(int index) {
    if (isSlotBooked[index]) return; // Slot is already booked

    setState(() {
      isSlotBooked[index] = true; // Mark slot as booked
    });

    _saveBookedSlots();

    // Show a booking confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Slot Booked'),
          content: Text('You have successfully booked the ${timeSlots[index]} slot.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Slots for Auditorium ${widget.auditoriumNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Selected Date: ${widget.selectedDate.toLocal()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display available time slots
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: timeSlots.length, // Ensure this matches the length of timeSlots
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _bookSlot(index),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSlotBooked[index] ? Colors.grey : Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      timeSlots[index],
                      style: TextStyle(
                        color: isSlotBooked[index] ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
