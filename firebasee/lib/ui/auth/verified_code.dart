import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasee/ui/post/post_screen.dart';
import 'package:firebasee/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class VerifiedCode extends StatefulWidget {
  final String verifiedId;
  const VerifiedCode({super.key, required this.verifiedId});

  @override
  State<VerifiedCode> createState() => _VerifiedCodeState();
}

class _VerifiedCodeState extends State<VerifiedCode> {
  bool loading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verified Code"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          TextFormField(
            controller: verificationCodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: '6 digit code'),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundedButton(
              title: 'Verify',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final crendital = PhoneAuthProvider.credential(
                    verificationId: widget.verifiedId,
                    smsCode: verificationCodeController.text.toString());

                try {
                  await auth.signInWithCredential(crendital);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PostScreen()));
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(e.toString());
                }
              })
        ],
      ),
    );
  }
}
