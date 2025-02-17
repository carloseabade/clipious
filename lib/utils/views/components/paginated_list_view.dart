import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/paginatedList.dart';
import '../../states/paginated_list_view.dart';

class PaginatedListView<T> extends StatelessWidget {
  final PaginatedList<T> paginatedList;
  final List<T>? startItems;
  final Widget Function(T item) itemBuilder;

  const PaginatedListView({Key? key, required this.paginatedList, required this.itemBuilder, this.startItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginatedListCubit<T>(PaginatedListViewController<T>(paginatedList: this.paginatedList, startItems: this.startItems)),
      child: BlocBuilder<PaginatedListCubit<T>, PaginatedListViewController<T>>(
          builder: (context, _) => ListView.builder(
                controller: _.scrollController,
                itemCount: _.items.length,
                itemBuilder: (BuildContext context, int index) {
                  T item = _.items[index];
                  return itemBuilder(item);
                },
              )),
    );
  }
}
