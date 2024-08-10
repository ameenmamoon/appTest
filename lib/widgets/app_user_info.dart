import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/blocs/app_bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/widgets/app_placeholder.dart';

import '../utils/translate.dart';

enum UserViewType {
  basic,
  information,
  qrcode,
  company,
  office,
  informationAdv
}

class AppUserInfo extends StatelessWidget {
  final UserModel? user;
  final VoidCallback? onPressed;
  final UserViewType type;

  const AppUserInfo({
    Key? key,
    this.user,
    this.onPressed,
    this.type = UserViewType.basic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case UserViewType.information:
        if (user == null) {
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return InkWell(
          onTap: onPressed,
          child: Row(
            children: <Widget>[
              if (user?.profilePictureDataUrl.isEmpty ?? true)
                Image.asset(
                  Images.user,
                  height: 60,
                  width: 100,
                ),
              if (user?.profilePictureDataUrl.isNotEmpty ?? false)
                CachedNetworkImage(
                  imageUrl: user!.getProfileImage(),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.05),
                        ),
                      ),
                    );
                  },
                  placeholder: (context, url) {
                    return AppPlaceholder(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return AppPlaceholder(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.error),
                      ),
                    );
                  },
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${user!.firstName} ${user!.lastName}',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 16),
                    ),
                    // const SizedBox(height: 4),
                    // Text(
                    //   "${user!.countryCode.replaceAll("+", "00")}-${user!.phoneNumber}",
                    //   maxLines: 3,
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    const SizedBox(height: 4),
                    Text(
                      user!.phoneNumber.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case UserViewType.company:
        if (user == null) {
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return InkWell(
            onTap: onPressed,
            child: user?.profilePictureDataUrl.isEmpty ?? true
                ? Image.asset(
                    Images.user,
                    height: 60,
                    width: 100,
                  )
                : CachedNetworkImage(
                    colorBlendMode: BlendMode.color,
                    color: Theme.of(context).primaryColor,
                    imageUrl: user!.getProfileImage(),
                    placeholder: (context, url) {
                      return AppPlaceholder(
                        child: Container(
                          width: 60,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return AppPlaceholder(
                        child: Container(
                          width: 60,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(Icons.error),
                        ),
                      );
                    },
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xff000000),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    user!.firstName,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  if (user!.isAppearPhoneNumber)
                                    Text(
                                      '${user!.countryCode.replaceAll('+', '00')}-${user!.phoneNumber}',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user!.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }));

      case UserViewType.informationAdv:
        if (user == null) {
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 150,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(height: 4),
              InkWell(
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      if (user?.profilePictureDataUrl.isEmpty ?? true)
                        Image.asset(
                          Images.user,
                          height: 60,
                          width: 100,
                        ),
                      if (user?.profilePictureDataUrl.isNotEmpty ?? false)
                        CachedNetworkImage(
                          imageUrl: user!.getProfileImage(),
                          placeholder: (context, url) {
                            return AppPlaceholder(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                            );
                          },
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.rectangle,
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return AppPlaceholder(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                ),
                                child: const Icon(Icons.error),
                              ),
                            );
                          },
                        ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            user!.firstName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (user!.isAppearPhoneNumber)
                            Text(
                              "${user!.countryCode}-${user!.phoneNumber}",
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 50),
                  color: Theme.of(context).colorScheme.onTertiary,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(user?.description ?? ""),
                  )),
            ]);

      case UserViewType.qrcode:
        return Container();

      default:
        if (user == null) {
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 150,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return InkWell(
          onTap: onPressed,
          child: Row(
            children: <Widget>[
              if (user?.profilePictureDataUrl.isEmpty ?? true)
                Image.asset(
                  Images.user,
                  height: 60,
                  width: 100,
                ),
              if (user?.profilePictureDataUrl.isNotEmpty ?? false)
                CachedNetworkImage(
                  imageUrl: user!.getProfileImage(),
                  placeholder: (context, url) {
                    return AppPlaceholder(
                      child: Container(
                        width: 100,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return AppPlaceholder(
                      child: Container(
                        width: 100,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.error),
                      ),
                    );
                  },
                ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user!.firstName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (user!.isAppearPhoneNumber)
                    Text(
                      "${user!.countryCode}-${user!.phoneNumber}",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                ],
              )
            ],
          ),
        );
    }
  }
}
