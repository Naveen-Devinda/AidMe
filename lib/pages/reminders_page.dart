import 'package:aidme/services/wellness_service.dart';
import 'package:aidme/models/reminder.dart';
import 'package:aidme/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  // Built‑in reminders
  Map<String, bool> _reminders = {
    "water": true,
    "medicine": false,
    "exercise": true,
    "sleep": true,
  };
  // Custom user reminders
  List<Reminder> _customReminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Reset enabled flags for a new day
    await WellnessService.clearEnabledIfNewDay();
    await _loadData();
    await _loadCustomReminders();
  }

  Future<void> _loadData() async {
    final loaded = await WellnessService.getReminders();
    setState(() {
      _reminders = loaded;
      _isLoading = false;
    });
  }

  Future<void> _loadCustomReminders() async {
    final list = await WellnessService.getCustomReminders();
    setState(() {
      _customReminders = list;
    });
  }

  Future<void> _toggleReminder(String key, bool val) async {
    setState(() {
      _reminders[key] = val;
    });
    await WellnessService.saveReminders(_reminders);
    _showSnack(
      "${_reminderMeta[key]!['title']} reminder ${val ? 'enabled' : 'disabled'}.",
    );
  }

  Future<void> _toggleCustom(Reminder reminder, bool val) async {
    setState(() {
      reminder.enabled = val;
    });
    await WellnessService.saveCustomReminders(_customReminders);
    if (val) {
      // schedule notification using reminder.id hash
      final notifId = reminder.id.hashCode & 0x7fffffff;
      await NotificationService.scheduleReminder(
        id: notifId,
        title: reminder.title,
        body: reminder.description ?? "It's time for ${reminder.title}!",
        time: reminder.time,
      );
    } else {
      await NotificationService.cancelReminder(reminder.id.hashCode);
    }
    _showSnack("${reminder.title} ${val ? 'enabled' : 'disabled'}.");
  }

  void _showSnack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xff3FBBBB),
        ),
      );
    }
  }

  // Meta for built‑in reminders (unchanged)
  final Map<String, Map<String, dynamic>> _reminderMeta = {
    "water": {
      "title": "Drink Water",
      "desc": "Keep hydrated throughout the day",
      "icon": Icons.local_drink,
      "color": Colors.blue,
    },
    "medicine": {
      "title": "Take Medicine",
      "desc": "Don't miss your daily dosage",
      "icon": Icons.medication,
      "color": Colors.redAccent,
    },
    "exercise": {
      "title": "Daily Exercise",
      "desc": "Take a 30 mins active break",
      "icon": Icons.directions_run,
      "color": Colors.green,
    },
    "sleep": {
      "title": "Sleep on Time",
      "desc": "Aim for a healthy 8‑hour sleep",
      "icon": Icons.bedtime,
      "color": Colors.purple,
    },
  };

  Future<void> _showAddDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final emojiController = TextEditingController();
    TimeOfDay? pickedTime;
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Custom Reminder'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                  ),
                ),
                TextField(
                  controller: emojiController,
                  decoration: const InputDecoration(
                    labelText: 'Emoji (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    pickedTime == null
                        ? 'Pick Time'
                        : pickedTime!.format(context),
                  ),
                  onPressed: () async {
                    final now = TimeOfDay.now();
                    final time = await showTimePicker(
                      context: context,
                      initialTime: now,
                    );
                    if (time != null) {
                      pickedTime = time;
                      // Force rebuild of dialog to show chosen time
                      (ctx as Element).markNeedsBuild();
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty || pickedTime == null) return;
                final newReminder = Reminder(
                  id: const Uuid().v4(),
                  title: titleController.text,
                  description: descController.text.isEmpty
                      ? null
                      : descController.text,
                  time: pickedTime!,
                  emoji: emojiController.text.isEmpty
                      ? null
                      : emojiController.text,
                );
                setState(() {
                  _customReminders.add(newReminder);
                });
                await WellnessService.saveCustomReminders(_customReminders);
                Navigator.of(ctx).pop();
                _showSnack('Custom reminder added');
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffDBF8F2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff98A9AA)),
        title: const Text(
          "Health Reminders",
          style: TextStyle(
            color: Color(0xff98A9AA),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff3FBBBB)),
            )
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  const Text(
                    "Daily Reminders",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Configure daily alert preferences to build healthy habits.",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  // Built‑in reminders
                  ..._reminderMeta.keys.map((key) {
                    final meta = _reminderMeta[key]!;
                    final isEnabled = _reminders[key] ?? false;
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: meta["color"].withValues(
                                alpha: 0.12,
                              ),
                              radius: 22,
                              child: Icon(
                                meta["icon"],
                                color: meta["color"],
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meta["title"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    meta["desc"],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              activeTrackColor: const Color(0xff3FBBBB),
                              value: isEnabled,
                              onChanged: (val) => _toggleReminder(key, val),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  // Custom reminders header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Custom Reminders",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._customReminders.map((r) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 1,
                        child: ListTile(
                          leading: r.emoji != null && r.emoji!.isNotEmpty
                              ? Text(
                                  r.emoji!,
                                  style: const TextStyle(fontSize: 24),
                                )
                              : const Icon(Icons.alarm),
                          title: Text(
                            r.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            r.description ?? r.time.format(context),
                          ),
                          trailing: Switch.adaptive(
                            activeTrackColor: const Color(0xff3FBBBB),
                            value: r.enabled,
                            onChanged: (val) => _toggleCustom(r, val),
                          ),
                          onTap: () async {
                            // Allow editing time
                            final newTime = await showTimePicker(
                              context: context,
                              initialTime: r.time,
                            );
                            if (newTime != null) {
                              setState(() {
                                r.time = newTime;
                              });
                              await WellnessService.saveCustomReminders(
                                _customReminders,
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xffD8EEEE)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xff3FBBBB),
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Habits take 21 days to form!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Keep these reminders active to ensure consistency in drinking water, sleeping on time, and doing physical activities.",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        label: const Text('Add Reminder'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xff3FBBBB),
      ),
    );
  }
}
