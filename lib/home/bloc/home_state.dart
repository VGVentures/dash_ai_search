part of 'home_bloc.dart';

enum Status { welcome, welcomeToAskQuestion, askQuestion }

class HomeState extends Equatable {
  const HomeState({
    required this.status,
  });

  const HomeState.initial() : status = Status.welcome;

  final Status status;

  bool get isWelcomeVisible =>
      status == Status.welcome || status == Status.welcomeToAskQuestion;
  bool get isQuestionVisible =>
      status == Status.welcomeToAskQuestion || status == Status.askQuestion;

  HomeState copyWith({
    Status? status,
  }) {
    return HomeState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
