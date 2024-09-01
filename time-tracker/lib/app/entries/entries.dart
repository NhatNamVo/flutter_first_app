import 'package:flutter/material.dart';
import 'package:my_app/app/entries/entries_bloc.dart';
import 'package:my_app/app/entries/entries_list_tile.dart';
import 'package:my_app/app/job_page/list_item_builder.dart';
import 'package:my_app/service/database.dart';
import 'package:provider/provider.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({super.key});

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(database: database),
      child: const EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
        elevation: 5.0,
      ),

      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context, listen: false);

    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListItemsBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      }
    );
  }
}