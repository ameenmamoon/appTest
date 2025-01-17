import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';

class SocialNetwork extends StatefulWidget {
  final Map<String, dynamic>? socials;

  const SocialNetwork({Key? key, this.socials}) : super(key: key);

  @override
  _SocialNetworkState createState() {
    return _SocialNetworkState();
  }
}

class _SocialNetworkState extends State<SocialNetwork> {
  final _textFacebookController = TextEditingController();
  final _textTwitterController = TextEditingController();
  final _textInstagramController = TextEditingController();
  final _textGmailController = TextEditingController();
  final _textLinkedinController = TextEditingController();
  final _textYoutubeController = TextEditingController();
  // final _textTumblrController = TextEditingController();
  // final _textFlickrController = TextEditingController();
  // final _textPinterestController = TextEditingController();

  final _focusFacebook = FocusNode();
  final _focusTwitter = FocusNode();
  final _focusInstagram = FocusNode();
  final _focusGmail = FocusNode();
  final _focusLinkedin = FocusNode();
  final _focusYoutube = FocusNode();
  // final _focusTumblr = FocusNode();
  // final _focusFlickr = FocusNode();
  // final _focusPinterest = FocusNode();

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  @override
  void dispose() {
    super.dispose();
    _textFacebookController.dispose();
    _textTwitterController.dispose();
    _textInstagramController.dispose();
    _textGmailController.dispose();
    _textLinkedinController.dispose();
    _textYoutubeController.dispose();
    // _textTumblrController.dispose();
    // _textFlickrController.dispose();
    // _textPinterestController.dispose();
    _focusFacebook.dispose();
    _focusTwitter.dispose();
    _focusInstagram.dispose();
    _focusGmail.dispose();
    _focusLinkedin.dispose();
    _focusYoutube.dispose();
    // _focusTumblr.dispose();
    // _focusFlickr.dispose();
    // _focusPinterest.dispose();
  }

  ///On Init
  void _initForm() {
    if (widget.socials != null) {
      _textFacebookController.text = widget.socials!['facebook'] ?? '';
      _textTwitterController.text = widget.socials!['twitter'] ?? '';
      _textInstagramController.text = widget.socials!['instagram'] ?? '';
      _textGmailController.text = widget.socials!['gmail'] ?? '';
      _textLinkedinController.text = widget.socials!['linkedin'] ?? '';
      _textYoutubeController.text = widget.socials!['youtube'] ?? '';
      // _textTumblrController.text = widget.socials!['tumblr'] ?? '';
      // _textFlickrController.text = widget.socials!['flick'] ?? '';
      // _textPinterestController.text = widget.socials!['pinterest'] ?? '';
    }
  }

  ///On Save
  void _onSave() {
    final Map<String, dynamic> data = {};
    if (_textFacebookController.text.isNotEmpty) {
      data['facebook'] = _textFacebookController.text;
    }
    if (_textTwitterController.text.isNotEmpty) {
      data['twitter'] = _textTwitterController.text;
    }
    if (_textInstagramController.text.isNotEmpty) {
      data['instagram'] = _textInstagramController.text;
    }
    if (UtilValidator.validate(_textGmailController.text,
                type: ValidateType.email, allowEmpty: true)
            ?.isEmpty ??
        false) {
      data['gmail'] = _textGmailController.text;
    }
    if (_textLinkedinController.text.isNotEmpty) {
      data['linkedin'] = _textLinkedinController.text;
    }
    if (_textYoutubeController.text.isNotEmpty) {
      data['youtube'] = _textYoutubeController.text;
    }
    // if (_textTumblrController.text.isNotEmpty) {
    //   data['tumblr'] = _textTumblrController.text;
    // }
    // if (_textFlickrController.text.isNotEmpty) {
    //   data['flick'] = _textFlickrController.text;
    // }
    // if (_textPinterestController.text.isNotEmpty) {
    //   data['pinterest'] = _textPinterestController.text;
    // }
    Navigator.pop(context, data.isNotEmpty ? data : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('social_network'),
        ),
        actions: [
          AppButton(
            Translate.of(context).translate('apply'),
            onPressed: _onSave,
            type: ButtonType.text,
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              Translate.of(context).translate(
                'facebook',
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_facebook',
              ),
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusFacebook,
                  _focusTwitter,
                );
              },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textFacebookController.clear();
                },
                child: const Icon(Icons.clear),
              ),
              controller: _textFacebookController,
              focusNode: _focusFacebook,
            ),
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate(
                'twitter',
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_twitter',
              ),
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusTwitter,
                  _focusInstagram,
                );
              },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textTwitterController.clear();
                },
                child: const Icon(Icons.clear),
              ),
              controller: _textTwitterController,
              focusNode: _focusTwitter,
            ),
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate(
                'instagram',
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_instagram',
              ),
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusInstagram,
                  _focusGmail,
                );
              },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textInstagramController.clear();
                },
                child: const Icon(Icons.clear),
              ),
              controller: _textInstagramController,
              focusNode: _focusInstagram,
            ),
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate(
                'gmail',
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_gmail',
              ),
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusGmail,
                  _focusLinkedin,
                );
              },
              errorText: UtilValidator.validate(_textGmailController.text,
                  type: ValidateType.email, allowEmpty: true),
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textGmailController.clear();
                },
                child: const Icon(Icons.clear),
              ),
              controller: _textGmailController,
              focusNode: _focusGmail,
            ),
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate(
                'linkedin',
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_linkedin',
              ),
              onSubmitted: (text) {
                UtilOther.fieldFocusChange(
                  context,
                  _focusLinkedin,
                  _focusYoutube,
                );
              },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textLinkedinController.clear();
                },
                child: const Icon(Icons.clear),
              ),
              controller: _textLinkedinController,
              focusNode: _focusLinkedin,
            ),
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate(
                'youtube',
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_youtube',
              ),
              // onSubmitted: (text) {
              //   UtilOther.fieldFocusChange(
              //     context,
              //     _focusYoutube,
              //     _focusTumblr,
              //   );
              // },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textYoutubeController.clear();
                },
                child: const Icon(Icons.clear),
              ),
              controller: _textYoutubeController,
              focusNode: _focusYoutube,
            ),
            // const SizedBox(height: 8),
            // Text(
            //   'Tumblr',
            //   style: Theme.of(context)
            //       .textTheme
            //       .titleSmall!
            //       .copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 4),
            // AppTextInput(
            //   hintText: Translate.of(context).translate(
            //     'input_tumblr',
            //   ),
            //   onSubmitted: (text) {
            //     UtilOther.fieldFocusChange(
            //       context,
            //       _focusTumblr,
            //       _focusFlickr,
            //     );
            //   },
            //   trailing: GestureDetector(
            //     dragStartBehavior: DragStartBehavior.down,
            //     onTap: () {
            //       _textTumblrController.clear();
            //     },
            //     child: const Icon(Icons.clear),
            //   ),
            //   controller: _textTumblrController,
            //   focusNode: _focusTumblr,
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   'Flickr',
            //   style: Theme.of(context)
            //       .textTheme
            //       .titleSmall!
            //       .copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 4),
            // AppTextInput(
            //   hintText: Translate.of(context).translate(
            //     'input_flickr',
            //   ),
            //   onSubmitted: (text) {
            //     UtilOther.fieldFocusChange(
            //       context,
            //       _focusFlickr,
            //       _focusPinterest,
            //     );
            //   },
            //   trailing: GestureDetector(
            //     dragStartBehavior: DragStartBehavior.down,
            //     onTap: () {
            //       _textFlickrController.clear();
            //     },
            //     child: const Icon(Icons.clear),
            //   ),
            //   controller: _textFlickrController,
            //   focusNode: _focusFlickr,
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   'Pinterest',
            //   style: Theme.of(context)
            //       .textTheme
            //       .titleSmall!
            //       .copyWith(fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 4),
            // AppTextInput(
            //   hintText: Translate.of(context).translate(
            //     'input_pinterest',
            //   ),
            //   trailing: GestureDetector(
            //     dragStartBehavior: DragStartBehavior.down,
            //     onTap: () {
            //       _textPinterestController.clear();
            //     },
            //     child: const Icon(Icons.clear),
            //   ),
            //   controller: _textPinterestController,
            //   focusNode: _focusPinterest,
            // ),
          ],
        ),
      ),
    );
  }
}
