import 'package:flutter/material.dart';

class RemindersPage extends StatefulWidget {
  final Map<String, dynamic>? initialSettings;

  const RemindersPage({super.key, this.initialSettings});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  bool enableReminders = false;
  bool soundNotification = false;

  late TimeOfDay preferredTime;
  late TimeOfDay reminderTime;


  static const Color color1 = Color(0xFF0D2B5B);
  static const Color color2 = Color(0xFF91B3F1);

  @override
  void initState() {
    super.initState();

    final s = widget.initialSettings;

    enableReminders = s?["enableReminders"] == true;
    soundNotification = s?["soundNotification"] == true;

    preferredTime = _parseTime(s?["preferredBedtime"]) ??
        const TimeOfDay(hour: 23, minute: 0);

    reminderTime = _parseTime(s?["reminderTime"]) ??
        const TimeOfDay(hour: 22, minute: 30);
  }

  TimeOfDay? _parseTime(dynamic value) {
    if (value is! String) return null;
    final parts = value.split(":");
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  Future<void> _pickTime({
    required TimeOfDay initial,
    required Function(TimeOfDay) onSelected,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: color1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) onSelected(picked);
  }

  void _save() {
    Navigator.pop(context, {
      "enableReminders": enableReminders,
      "soundNotification": soundNotification,
      "preferredBedtime": _formatTime(preferredTime),
      "reminderTime": _formatTime(reminderTime),
    });
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _timeTile({
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: ListTile(
        onTap: enabled ? onTap : null,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.access_time, color: color1),
        title: Text(title,
            style: TextStyle(
                color: color1.withOpacity(0.9),
                fontWeight: FontWeight.w700)),
        trailing: Text(
          _formatTime(time),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _toggleTile({
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: color1),
        const SizedBox(width: 12),
        Expanded(child: Text(title)),
        Switch(value: value, onChanged: onChanged, activeColor: color1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminderDisabled = !enableReminders;

    return Scaffold(
      backgroundColor: color2,
      appBar: AppBar(
        title: const Text('SleepEase'),
        backgroundColor: color1,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.notifications_active, size: 88, color: color1),
            const SizedBox(height: 10),

            const Text(
              "Bedtime Reminder Settings",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color1),
            ),

            const SizedBox(height: 20),

            _card(
              child: Column(
                children: [

                  _timeTile(
                    title: "Preferred Bedtime",
                    time: preferredTime,
                    enabled: true,
                    onTap: () => _pickTime(
                      initial: preferredTime,
                      onSelected: (t) => setState(() => preferredTime = t),
                    ),
                  ),

                  const Divider(),

                  _timeTile(
                    title: "Reminder Time",
                    time: reminderTime,
                    enabled: !reminderDisabled,
                    onTap: () => _pickTime(
                      initial: reminderTime,
                      onSelected: (t) => setState(() => reminderTime = t),
                    ),
                  ),

                  const SizedBox(height: 10),

                  _toggleTile(
                    title: "Enable Reminders",
                    value: enableReminders,
                    onChanged: (v) => setState(() => enableReminders = v),
                    icon: Icons.notifications,
                  ),

                  _toggleTile(
                    title: "Sound Notification",
                    value: soundNotification,
                    onChanged:
                        reminderDisabled ? null : (v) => setState(() => soundNotification = v),
                    icon: Icons.volume_up,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Save Settings"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
