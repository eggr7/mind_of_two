import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import './edit_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Map<DateTime, List<Task>> _groupTasksByDate(List<Task> tasks) {
    final Map<DateTime, List<Task>> events = {};
    for (var task in tasks) {
      if (task.dueDate != null) {
        final date = DateTime.utc(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        if (events[date] == null) {
          events[date] = [];
        }
        events[date]!.add(task);
      }
    }
    return events;
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red;
      case 'important':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final events = _groupTasksByDate(taskProvider.tasks);

    List<Task> getEventsForDay(DateTime day) {
      final normalizedDay = DateTime.utc(day.year, day.month, day.day);
      return events[normalizedDay] ?? [];
    }

    final tasksForSelectedDay = _selectedDay != null
        ? getEventsForDay(_selectedDay!)
        : [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // You can change this color
      appBar: AppBar(
        title: const Text("Calendar"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDay ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null && picked != _selectedDay) {
                setState(() {
                  _selectedDay = picked;
                  _focusedDay = picked;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1), // You can change this color
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFB2DFDB), // You can change this color
                width: 2,
              ),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: getEventsForDay,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox();
                  final tasks = events.cast<Task>();
                  final allCompleted =
                      tasks.every((task) => task.completed);
                  final color = allCompleted
                      ? Colors.green
                      : _getPriorityColor(tasks
                          .fold<String>('normal', (prev, task) {
                          if (task.priority == 'urgent') return 'urgent';
                          if (task.priority == 'important' &&
                              prev != 'urgent') {
                            return 'important';
                          }
                          return prev;
                        }));
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    width: 12,
                    height: 10,
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFF6C63FF),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
                weekendTextStyle: const TextStyle(
                  color: Color(0xFF00796B), // You can change this color
                ),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D40), // You can change this color
                ),
              ),
              daysOfWeekHeight: 20,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _selectedDay != null
                  ? "Tasks for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}"
                  : "Select a date",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tasksForSelectedDay.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks for this date",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasksForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final task = tasksForSelectedDay[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _getPriorityColor(task.priority),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: Icon(
                            task.completed
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: task.completed ? Colors.green : Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTaskScreen(task: task),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditTaskScreen(
                task: Task(
                  id: Task.generateId(),
                  title: "",
                  description: "",
                  assignedTo: "both",
                  priority: "normal",
                  completed: false,
                  createdAt: DateTime.now(),
                  dueDate: _selectedDay,
                ),
                isNew: true,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
