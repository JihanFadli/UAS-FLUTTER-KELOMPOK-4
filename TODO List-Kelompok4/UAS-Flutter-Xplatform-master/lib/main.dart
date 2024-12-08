import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Map<String, dynamic>> _todoList = []; // Daftar tugas dengan waktu dan tanggal
  final TextEditingController _taskController = TextEditingController(); // Kontrol input tugas
  DateTime? _selectedDate; // Tanggal yang dipilih
  TimeOfDay? _selectedTime; // Waktu yang dipilih

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addTodo() {
    if (_taskController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      setState(() {
        _todoList.add({
          'task': _taskController.text,
          'date': _selectedDate,
          'time': _selectedTime,
        });
        _taskController.clear(); // Kosongkan input tugas
        _selectedDate = null; // Reset tanggal
        _selectedTime = null; // Reset waktu
      });
    }
  }

  void _removeTodoAt(int index) {
    setState(() {
      _todoList.removeAt(index); // Hapus tugas berdasarkan indeks
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List Kelompok 4"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    labelText: "Tambahkan tugas",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _pickDate(context),
                        child: Text(
                          _selectedDate == null
                              ? "Pilih Tanggal"
                              : "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _pickTime(context),
                        child: Text(
                          _selectedTime == null
                              ? "Pilih Waktu"
                              : "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text("Tambah"),
                ),
              ],
            ),
          ),
          Expanded(
            child: _todoList.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada tugas!",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _todoList.length,
                    itemBuilder: (context, index) {
                      final task = _todoList[index];
                      final date = task['date'] as DateTime;
                      final time = task['time'] as TimeOfDay;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ListTile(
                          title: Text(task['task']),
                          subtitle: Text(
                              "Tanggal: ${date.day}-${date.month}-${date.year}, Waktu: ${time.hour}:${time.minute.toString().padLeft(2, '0')}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeTodoAt(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}