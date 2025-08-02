import 'package:flutter/material.dart';
import '../models/password_entry.dart';
import '../services/db_helper.dart';

class EntryFormScreen extends StatefulWidget {
  final PasswordEntry? entry;

  const EntryFormScreen({Key? key, this.entry}) : super(key: key);

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _usernameController = TextEditingController(text: widget.entry?.username ?? '');
    _passwordController = TextEditingController(text: widget.entry?.password ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final newEntry = PasswordEntry(
        id: widget.entry?.id,
        title: _titleController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (widget.entry == null) {
        await DBHelper.instance.insertEntry(newEntry);
      } else {
        await DBHelper.instance.updateEntry(newEntry);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑密码记录' : '添加密码记录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '标题'),
                validator: (value) => value!.isEmpty ? '请输入标题' : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: '用户名/账号'),
                validator: (value) => value!.isEmpty ? '请输入用户名/账号' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '密码'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? '请输入密码' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? '更新' : '保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
