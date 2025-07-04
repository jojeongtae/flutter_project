import 'package:flutter/material.dart';
import 'package:jomakase/public_file/layout.dart';
import 'package:jomakase/public_file/token.dart';
import 'package:jomakase/public_file/userinfo.dart';
import 'package:provider/provider.dart';
import 'package:jomakase/public_file/api_service.dart'; // ApiService import

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserInfo>();
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _nicknameController = TextEditingController(text: user.nickname);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = context.read<UserInfo>();
      final tokenToSend = context.read<Token>().accessToken;
      final userData = {
        "email": _emailController.text,
        "phone": _phoneController.text,
        "nickname": _nicknameController.text,
      };

      try {
        await ApiService.updateProfile(tokenToSend, userData); // ApiService.updateProfile 호출
        user.updateFromJson(userData); // Update local UserInfo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('정보가 성공적으로 업데이트되었습니다.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('정보 업데이트 실패: ${e.toString().replaceFirst('Exception: ', '')}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '내 정보 수정',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '전화번호',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전화번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '닉네임',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '닉네임을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed:() async{
                  _updateProfile();
                  await Future.delayed(Duration(seconds: 2));
                   await Navigator.pushNamed(context, "/home");
                } ,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('정보 업데이트'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
