import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/repository/repository.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';

class SizesPicker extends StatefulWidget {
  final List<String> selected;

  const SizesPicker({Key? key, required this.selected}) : super(key: key);

  @override
  _SizesPickerState createState() {
    return _SizesPickerState();
  }
}

class _SizesPickerState extends State<SizesPicker> {
  final _textEditController = TextEditingController();

  List<String> _sizes = [];
  List<String> _suggest = [];
  Timer? _debounce;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _sizes = widget.selected;
    _textEditController.text = _sizes.join(",");
  }

  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }

  ///On change text
  void _onChange(String keyword) {
    _debounce?.cancel();
    final arrList = keyword.split(",");
    if (keyword.isNotEmpty) {
      setState(() {
        _searching = true;
      });
      _debounce = Timer(const Duration(seconds: 1), () async {
        final result = await Future.microtask(() {
          Future.delayed(const Duration(seconds: 2));
          return ["كبير", "وسط", "صغير"];
        });
        // final result = await ListRepository.loadTags(arrList.last);
        setState(() {
          _sizes = arrList;
          _searching = false;
          _suggest = result;
        });
      });
    } else {
      setState(() {
        _sizes.clear();
        _searching = false;
        _suggest = [];
      });
    }
  }

  ///On completed
  void _onCompleted(String item) {
    final arrList = _textEditController.text.split(",");
    arrList.last = item;
    _textEditController.text = arrList.join(",");
    _textEditController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textEditController.text.length),
    );
    setState(() {
      _sizes = arrList;
    });
  }

  ///On completed
  void _onRemove(String item) {
    setState(() {
      _sizes.remove(item);
    });
    _textEditController.text = _sizes.join(",");
    _textEditController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textEditController.text.length),
    );
  }

  ///On apply
  void _onApply() {
    Navigator.pop(context, _sizes);
  }

  @override
  Widget build(BuildContext context) {
    Widget trailing = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      onTap: () {
        setState(() {
          _textEditController.clear();
          _sizes.clear();
          _searching = false;
          _suggest = [];
        });
      },
      child: const Icon(Icons.clear),
    );
    if (_searching) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
            ),
          ),
          SizedBox(width: 16),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('choose_sizes'),
        ),
        actions: [
          AppButton(
            Translate.of(context).translate('apply'),
            onPressed: _onApply,
            type: ButtonType.text,
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextInput(
                hintText: Translate.of(context).translate('input_sizes'),
                controller: _textEditController,
                onChanged: _onChange,
                onSubmitted: _onChange,
                trailing: trailing,
                autofocus: true,
              ),
              const SizedBox(height: 2),
              Text(
                Translate.of(context).translate('separate_size'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              AnimatedContainer(
                height: _suggest.isNotEmpty ? 88 : 0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _suggest.map((item) {
                        return SizedBox(
                          height: 32,
                          child: InputChip(
                            avatar: const Icon(Icons.add),
                            label: Text(item),
                            onPressed: () {
                              _onCompleted(item);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _sizes.map((item) {
                    return SizedBox(
                      height: 32,
                      child: InputChip(
                        avatar: const Icon(Icons.highlight_remove),
                        label: Text(item),
                        onPressed: () {
                          _onRemove(item);
                        },
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
