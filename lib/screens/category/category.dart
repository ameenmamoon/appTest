import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/blocs/category/category_cubit.dart';
import 'package:supermarket/blocs/category/category_state.dart';
import 'package:supermarket/configs/routes.dart';
import 'package:supermarket/models/model_category.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/widgets/widget.dart';

class Category extends StatefulWidget {
  final CategoryModel? item;
  const Category({Key? key, this.item}) : super(key: key);

  @override
  State<Category> createState() {
    return _CategoryState();
  }
}

class _CategoryState extends State<Category> {
  final _categoryCubit = CategoryCubit();
  final _textController = TextEditingController();

  CategoryView _type = CategoryView.full;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  void dispose() {
    _categoryCubit.close();
    _textController.dispose();
    super.dispose();
  }

  ///On refresh list
  Future<void> _onRefresh() async {
    await _categoryCubit.onLoad(
      item: widget.item,
      keyword: _textController.text,
    );
  }

  ///On select category
  void _onCategory(CategoryModel item) {
    Navigator.pushNamed(context, Routes.listProduct, arguments: item.id);
  }

  ///On change mode view
  void _onChangeModeView() {
    switch (_type) {
      case CategoryView.full:
        setState(() {
          _type = CategoryView.icon;
        });
        break;
      case CategoryView.icon:
        setState(() {
          _type = CategoryView.full;
        });
        break;
      default:
        break;
    }
  }

  ///On Search Category
  void _onSearch(String text) {
    _categoryCubit.onLoad(
      item: widget.item,
      keyword: _textController.text,
    );
  }

  ///Export icon
  IconData _exportIcon(CategoryView type) {
    switch (type) {
      case CategoryView.icon:
        return Icons.view_headline;
      default:
        return Icons.view_agenda_outlined;
    }
  }

  ///Build content list
  Widget _buildContent(List<CategoryModel>? category) {
    ///Success
    if (category != null) {
      ///Empty
      if (category.isEmpty) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.sentiment_satisfied),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  Translate.of(context).translate(
                    'category_not_found',
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
          itemCount: category.length,
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemBuilder: (context, index) {
            final item = category[index];
            return AppCategory(
              type: _type,
              item: item,
              onPressed: () {
                _onCategory(item);
              },
            );
          },
        ),
      );
    }

    ///Loading
    return ListView.separated(
      itemCount: List.generate(8, (index) => index).length,
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return AppCategory(type: _type);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? title;
    if (widget.item?.name != null) {
      title = widget.item?.name;
    }
    return BlocBuilder<CategoryCubit, CategoryState>(
      bloc: _categoryCubit,
      builder: (context, state) {
        List<CategoryModel>? category;
        if (state is CategorySuccess) {
          category = state.list;
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              title ?? Translate.of(context).translate('category'),
            ),
            actions: <Widget>[
              IconButton(
                enableFeedback: true,
                icon: Icon(
                  _exportIcon(_type),
                ),
                onPressed: _onChangeModeView,
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 16),
                  AppTextInput(
                    hintText: Translate.of(context).translate('search'),
                    controller: _textController,
                    onSubmitted: _onSearch,
                    onChanged: _onSearch,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildContent(category),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
