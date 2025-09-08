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
  Map<DateTime, List<Task>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _loadEvents(List<Task> tasks) {
    final Map<DateTime, List<Task>> events = {};
    
    for (var task in tasks) {
      if (task.dueDate != null) {
        // Normalizar la fecha (sin hora)
        final date = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
        
        if (events[date] == null) {
          events[date] = [];
        }
        events[date]!.add(task);
      }
    }
    
    setState(() {
      _events = events;
    });
  }

  List<Task> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Cargar eventos cuando el taskProvider cambie
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents(taskProvider.tasks);
    });

    final tasksForSelectedDay = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
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
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: const Color(0xFFF50057),
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: Icon(
                            task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: task.completed ? Colors.green : Colors.grey,
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTaskScreen(task: task),
                              ),
                            );
                            // Recargar eventos después de regresar
                            _loadEvents(taskProvider.tasks);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
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
          // Recargar eventos después de regresar
          _loadEvents(taskProvider.tasks);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}