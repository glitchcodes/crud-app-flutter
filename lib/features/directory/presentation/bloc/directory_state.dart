class DirectoryState {
  final String appBarTitle;

  const DirectoryState({required this.appBarTitle});

  factory DirectoryState.initial() => const DirectoryState(
      appBarTitle: 'The Directory',
  );

  DirectoryState copyWith({String? appBarTitle}) {
    return DirectoryState(
      appBarTitle: appBarTitle ?? this.appBarTitle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DirectoryState && other.appBarTitle == appBarTitle;
  }

  @override
  int get hashCode => appBarTitle.hashCode;
}