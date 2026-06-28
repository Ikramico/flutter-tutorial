part of 'category_bloc.dart';



abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class CategoryLoadRequested extends CategoryEvent {
  const CategoryLoadRequested();
}
