import 'package:crud_app/features/directory/presentation/bloc/directory_bloc.dart';
import 'package:crud_app/features/directory/presentation/bloc/directory_event.dart';
import 'package:crud_app/services/firebase_service.dart';
import 'package:crud_app/ui/search_scp.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SeriesView extends StatefulWidget {
  const SeriesView({super.key});

  @override
  State<SeriesView> createState() => _SeriesViewState();
}

class _SeriesViewState extends State<SeriesView> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<DirectoryBloc>().add(UpdateAppBarTitle(title: 'The Directory'));

    return SingleChildScrollView(
      child: Column(
        children: [
          SearchSCP(),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextHeading(
                text: 'Series',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                fontName: 'Grenze Gotisch',
              ),
            ),
          ),
          SizedBox(height: 15),

          StreamBuilder(
            stream: _firebaseService.getAllSeries(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final seriesItems = snapshot.data?.docs ?? [];

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: seriesItems.length,
                itemBuilder: (context, index) {
                  final docId = seriesItems[index].id;
                  final data = seriesItems[index].data() as Map<String, dynamic>;

                  return ListTile(
                    title: Text(data['name']),
                    subtitle: Text(data['description']),
                    onTap: () {
                      context.push('/directory/$docId');
                    },
                  );
                }
              );
            }
          )
        ],
      ),
    );
  }
}