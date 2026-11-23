import 'package:flutter/material.dart';
import 'package:hostel_hisab/core/extensions/context_extensions.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/core/utils/formatters.dart';
import 'package:hostel_hisab/core/validators/validators.dart';
import 'package:hostel_hisab/core/widgets/app_card.dart';
import 'package:hostel_hisab/core/widgets/empty_view.dart';
import 'package:hostel_hisab/core/widgets/initial_avatar.dart';
import 'package:hostel_hisab/core/widgets/primary_button.dart';
import 'package:hostel_hisab/core/widgets/state_view.dart';
import 'package:hostel_hisab/core/widgets/status_chip.dart';
import 'package:hostel_hisab/features/members/domain/entities/member.dart';
import 'package:hostel_hisab/features/members/presentation/providers/members_provider.dart';
import 'package:provider/provider.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  static const _avatarColors = [
    AppColors.primary, AppColors.orange, AppColors.blue,
    AppColors.purple, AppColors.pink,
  ];

  Future<void> _addMember(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final members = context.read<MembersProvider>();
    // The sheet owns (and disposes) its own text controllers.
    final result = await showModalBottomSheet<(String, String)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AddMemberSheet(),
    );
    if (result == null) return;
    await members.add(result.$1, result.$2);
    if (members.error != null) messenger.toast(members.error!, isError: true);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MembersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('সদস্য'),
        actions: [
          IconButton(
            tooltip: 'সদস্য যোগ করুন',
            onPressed: () => _addMember(context),
            style: IconButton.styleFrom(
                backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: StateView(
        state: p.state,
        hasData: p.members.isNotEmpty,
        error: p.error,
        onRetry: p.load,
        child: p.members.isEmpty
            ? EmptyView(
                icon: Icons.people_outline,
                title: 'কোনো সদস্য নেই',
                message: 'প্রথম সদস্য যোগ করে শুরু করুন',
                actionLabel: 'সদস্য যোগ করুন',
                onAction: () => _addMember(context),
              )
            // builder: only the rows on screen are built
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: p.members.length + 1, // +1 = stats header
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(children: [
                        _Stat(Fmt.bn(p.members.length), 'মোট সদস্য', AppColors.primary, AppColors.greenSoft),
                        const SizedBox(width: 10),
                        _Stat(Fmt.bn(p.paidCount), 'পরিশোধিত', AppColors.blue, AppColors.blueSoft),
                        const SizedBox(width: 10),
                        _Stat(Fmt.bn(p.dueCount), 'বাকি', AppColors.orange, AppColors.orangeSoft),
                      ]),
                    );
                  }
                  final m = p.members[i - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _MemberRow(
                        member: m,
                        color: _avatarColors[(i - 1) % _avatarColors.length],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _AddMemberSheet extends StatefulWidget {
  const _AddMemberSheet();

  @override
  State<_AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<_AddMemberSheet> {
  final _name = TextEditingController();
  final _room = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _room.dispose();
    super.dispose();
  }

  void _submit() {
    if (Validators.requiredField(_name.text) != null) {
      context.toast('নাম লিখুন', isError: true);
      return;
    }
    Navigator.pop(context, (_name.text.trim(), _room.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // lifts the sheet above the keyboard
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'নাম')),
          const SizedBox(height: 12),
          TextField(controller: _room, decoration: const InputDecoration(labelText: 'রুম নম্বর')),
          const SizedBox(height: 16),
          PrimaryButton(label: 'যোগ করুন', onPressed: _submit),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label, this.color, this.soft);
  final String value, label;
  final Color color, soft;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        color: soft,
        borderColor: soft,
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
        ]),
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member, required this.color});
  final Member member;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final (label, fg, bg) = switch (member.status) {
      DueStatus.paid => ('পরিশোধিত', AppColors.primary, AppColors.greenSoft),
      DueStatus.due => ('বাকি', AppColors.orange, AppColors.orangeSoft),
      DueStatus.advance => ('অগ্রিম', AppColors.blue, AppColors.blueSoft),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        InitialAvatar(name: member.name, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(member.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('রুম ${member.room}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(Fmt.taka(member.balance.abs()), style: const TextStyle(fontWeight: FontWeight.w700)),
          StatusChip(label: label, color: fg, background: bg),
        ]),
      ]),
    );
  }
}
