abstract class DirectoryEvent {}

class UpdateAppBarTitle extends DirectoryEvent {
  final String title;

  UpdateAppBarTitle({required this.title});
}

