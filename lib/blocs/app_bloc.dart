import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class AppBloc {
  static final applicationCubit = ApplicationCubit();
  static final orderListCubit = OrderListCubit();
  // static final initCubit = InitCubit();
  // static final orderListCubit = OrderListCubit();
  static final discoveryCubit = PromotionCubit();
  static final profileListCubit = ProfileListCubit();
  static final userCubit = UserCubit();
  static final languageCubit = LanguageCubit();
  static final themeCubit = ThemeCubit();
  static final authenticateCubit = AuthenticationCubit();
  static final loginCubit = LoginCubit();
  static final homeCubit = HomeCubit();
  static final wishListCubit = WishListCubit();
  static final reviewCubit = ReviewCubit();
  static final messageCubit = MessageCubit();
  static final locationCubit = LocationCubit();
  static final searchCubit = SearchCubit();

  static final List<BlocProvider> providers = [
    BlocProvider<ApplicationCubit>(
      create: (context) => applicationCubit,
    ),
    BlocProvider<OrderListCubit>(
      create: (context) => orderListCubit,
    ),
    // BlocProvider<InitCubit>(
    //   create: (context) => initCubit,
    // ),
    // BlocProvider<OrderListCubit>(
    //   create: (context) => orderListCubit,
    // ),
    BlocProvider<LocationCubit>(
      create: (context) => locationCubit,
    ),
    BlocProvider<ProfileListCubit>(
      create: (context) => profileListCubit,
    ),
    BlocProvider<UserCubit>(
      create: (context) => userCubit,
    ),
    BlocProvider<PromotionCubit>(
      create: (context) => discoveryCubit,
    ),
    BlocProvider<LanguageCubit>(
      create: (context) => languageCubit,
    ),
    BlocProvider<ThemeCubit>(
      create: (context) => themeCubit,
    ),
    BlocProvider<AuthenticationCubit>(
      create: (context) => authenticateCubit,
    ),
    BlocProvider<LoginCubit>(
      create: (context) => loginCubit,
    ),
    BlocProvider<HomeCubit>(
      create: (context) => homeCubit,
    ),
    BlocProvider<WishListCubit>(
      create: (context) => wishListCubit,
    ),
    BlocProvider<ReviewCubit>(
      create: (context) => reviewCubit,
    ),
    BlocProvider<MessageCubit>(
      create: (context) => messageCubit,
    ),
    BlocProvider<SearchCubit>(
      create: (context) => searchCubit,
    ),
  ];

  static void dispose() {
    applicationCubit.close();
    profileListCubit.close();
    discoveryCubit.close();
    locationCubit.close();
    userCubit.close();
    languageCubit.close();
    themeCubit.close();
    homeCubit.close();
    wishListCubit.close();
    authenticateCubit.close();
    loginCubit.close();
    reviewCubit.close();
    messageCubit.close();
    searchCubit.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
