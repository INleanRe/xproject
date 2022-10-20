import 'package:experiment/model/doujin.dart';
import 'package:flutter/cupertino.dart';

enum FormMode { create, edit }

class CreateEditScreen extends StatefulWidget {
  const CreateEditScreen({super.key, required this.mode, this.doujin});

  final FormMode mode;
  final Doujin? doujin;

  @override
  State<CreateEditScreen> createState() => _CreateEditScreenState();
}

class _CreateEditScreenState extends State<CreateEditScreen> {
  final TextEditingController _ncodeController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.mode == FormMode.edit) {
      _ncodeController.text = widget.doujin!.ncode;
      _authorController.text = widget.doujin!.author;
      _descController.text = widget.doujin!.desc;
    }
  }

  getRekt() {
    return Doujin(
      ncode: _ncodeController.text,
      author: _authorController.text,
      desc: _descController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Data Mahasiswa'),
        trailing: GestureDetector(
          onTap: () {
            Navigator.pop(context, getRekt());
          },
          child: Text(widget.mode == FormMode.create ? 'Tambah' : 'Edit'),
        ),
      ),
      child: SafeArea(
        child: CupertinoFormSection(
          header: Text(
              widget.mode == FormMode.create ? 'Tambah Doujin' : 'Edit Doujin'),
          children: [
            CupertinoFormRow(
              prefix: Text('ncode'),
              child: CupertinoTextFormFieldRow(
                controller: _ncodeController,
                placeholder: 'Masukkan ncode',
              ),
            ),
            CupertinoFormRow(
              prefix: Text('author'),
              child: CupertinoTextFormFieldRow(
                controller: _authorController,
                placeholder: 'Masukkan author',
              ),
            ),
            CupertinoFormRow(
              prefix: Text('desc'),
              child: CupertinoTextFormFieldRow(
                controller: _descController,
                placeholder: 'Masukkan desc',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
