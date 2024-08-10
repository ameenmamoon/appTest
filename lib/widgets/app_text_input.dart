import 'package:flutter/material.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:flutter/services.dart';

class AppTextInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Function()? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final Widget? leading;
  final Widget? trailing;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final int? maxLines;
  final bool? autofocus;
  final bool? readOnly;
  final Color? color;

  const AppTextInput({
    Key? key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.leading,
    this.trailing,
    this.obscureText = false,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.maxLines = 1,
    this.autofocus = false,
    this.readOnly = false,
    this.color,
  }) : super(key: key);

  Widget _buildErrorLabel(BuildContext context) {
    if (errorText == null) {
      return Container();
    }
    if (leading != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                Translate.of(context).translate(errorText!),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.error),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              Translate.of(context).translate(errorText!),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.error),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget = const SizedBox(width: 16);
    if (leading != null) {
      leadingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          leading!,
          const SizedBox(width: 8),
        ],
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).dividerColor.withOpacity(.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Row(
            children: [
              leadingWidget,
              Expanded(
                child: TextField(
                  onTap: onTap,
                  textAlignVertical: TextAlignVertical.center,
                  onSubmitted: onSubmitted,
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: onChanged,
                  onEditingComplete: onEditingComplete,
                  obscureText: obscureText,
                  inputFormatters: inputFormatters,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    hintText: hintText,
                    suffixIcon: trailing,
                    border: InputBorder.none,
                  ),
                  autofocus: autofocus ?? false,
                  readOnly: readOnly ?? false,
                ),
              )
            ],
          ),
          _buildErrorLabel(context)
        ],
      ),
    );
  }
}
