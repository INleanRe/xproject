import 'dart:convert';

import 'package:experiment/screen/create.dart';
import 'package:flutter/cupertino.dart';
import 'package:experiment/model/doujin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final storage = const FlutterSecureStorage();

  final List<Doujin> _listdoujin = [];

  @override
  initState() {
    super.initState();
    _getDataFromStorage();
  }

  _getDataFromStorage() async {
    String? data = await storage.read(key: 'list_doujin');
    if (data != null) {
      final dataDecoded = jsonDecode(data);
      if (dataDecoded is List) {
        setState(() {
          _listdoujin.clear();
          for (var item in dataDecoded) {
            _listdoujin.add(Doujin.fromJson(item));
          }
        });
      }
    }
  }

  _saveDataToStorage() async {
    final List<Object> tmp = [];
    for (var item in _listdoujin) {
      tmp.add(item.toJson());
    }

    await storage.write(
      key: 'list_doujin',
      value: jsonEncode(tmp),
    );
  }

  _showPopupMenuItem(BuildContext context, int index) {
    final doujinClicked = _listdoujin[index];

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Abandon All Hope ${doujinClicked.ncode}'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => CreateEditScreen(
                    mode: FormMode.edit,
                    doujin: doujinClicked,
                  ),
                ),
              );
              if (result is Doujin) {
                setState(() {
                  _listdoujin[index] = result;
                });
                _saveDataToStorage();
              }
            },
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text('Apakah anda yakin?'),
                  content: Text(
                      'Data mahasiswa ${doujinClicked.ncode} akan dihapus'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Tidak'),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _listdoujin.removeAt(index);
                        });
                      },
                      child: const Text('Iya'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Data Mahasiswa'),
        trailing: GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const CreateEditScreen(
                  mode: FormMode.create,
                ),
              ),
            );
            if (result is Doujin) {
              setState(() {
                _listdoujin.add(result);
              });
              _saveDataToStorage();
            }
          },
          child: Icon(
            CupertinoIcons.add_circled,
            size: 22,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView.separated(
          itemCount: _listdoujin.length,
          itemBuilder: (context, index) {
            final item = _listdoujin[index];
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: GestureDetector(
                onTap: () => _showPopupMenuItem(context, index),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.ncode} (${item.author})',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '${item.desc}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ),
    );
  }
}
