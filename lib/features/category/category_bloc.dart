import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/category.dart';
import '../../../data/repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _repository;

  CategoryBloc(this._repository) : super(const CategoryInitial()) {
    on<CategoryLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    CategoryLoadRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final categories = await _repository.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
