// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_requests_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExchangeRequestsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeRequestsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeRequestsState()';
}


}

/// @nodoc
class $ExchangeRequestsStateCopyWith<$Res>  {
$ExchangeRequestsStateCopyWith(ExchangeRequestsState _, $Res Function(ExchangeRequestsState) __);
}


/// Adds pattern-matching-related methods to [ExchangeRequestsState].
extension ExchangeRequestsStatePatterns on ExchangeRequestsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Updating value)?  updating,TResult Function( _UpdateSuccess value)?  updateSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Updating() when updating != null:
return updating(_that);case _UpdateSuccess() when updateSuccess != null:
return updateSuccess(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Updating value)  updating,required TResult Function( _UpdateSuccess value)  updateSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Updating():
return updating(_that);case _UpdateSuccess():
return updateSuccess(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Updating value)?  updating,TResult? Function( _UpdateSuccess value)?  updateSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Updating() when updating != null:
return updating(_that);case _UpdateSuccess() when updateSuccess != null:
return updateSuccess(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ExchangeRequestModel> requests)?  loaded,TResult Function( List<ExchangeRequestModel> requests,  int updatingId)?  updating,TResult Function( List<ExchangeRequestModel> requests)?  updateSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.requests);case _Updating() when updating != null:
return updating(_that.requests,_that.updatingId);case _UpdateSuccess() when updateSuccess != null:
return updateSuccess(_that.requests);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ExchangeRequestModel> requests)  loaded,required TResult Function( List<ExchangeRequestModel> requests,  int updatingId)  updating,required TResult Function( List<ExchangeRequestModel> requests)  updateSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.requests);case _Updating():
return updating(_that.requests,_that.updatingId);case _UpdateSuccess():
return updateSuccess(_that.requests);case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ExchangeRequestModel> requests)?  loaded,TResult? Function( List<ExchangeRequestModel> requests,  int updatingId)?  updating,TResult? Function( List<ExchangeRequestModel> requests)?  updateSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.requests);case _Updating() when updating != null:
return updating(_that.requests,_that.updatingId);case _UpdateSuccess() when updateSuccess != null:
return updateSuccess(_that.requests);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ExchangeRequestsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeRequestsState.initial()';
}


}




/// @nodoc


class _Loading implements ExchangeRequestsState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeRequestsState.loading()';
}


}




/// @nodoc


class _Loaded implements ExchangeRequestsState {
  const _Loaded(final  List<ExchangeRequestModel> requests): _requests = requests;
  

 final  List<ExchangeRequestModel> _requests;
 List<ExchangeRequestModel> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}


/// Create a copy of ExchangeRequestsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._requests, _requests));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_requests));

@override
String toString() {
  return 'ExchangeRequestsState.loaded(requests: $requests)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $ExchangeRequestsStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<ExchangeRequestModel> requests
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of ExchangeRequestsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requests = null,}) {
  return _then(_Loaded(
null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<ExchangeRequestModel>,
  ));
}


}

/// @nodoc


class _Updating implements ExchangeRequestsState {
  const _Updating({required final  List<ExchangeRequestModel> requests, required this.updatingId}): _requests = requests;
  

 final  List<ExchangeRequestModel> _requests;
 List<ExchangeRequestModel> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}

 final  int updatingId;

/// Create a copy of ExchangeRequestsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatingCopyWith<_Updating> get copyWith => __$UpdatingCopyWithImpl<_Updating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Updating&&const DeepCollectionEquality().equals(other._requests, _requests)&&(identical(other.updatingId, updatingId) || other.updatingId == updatingId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_requests),updatingId);

@override
String toString() {
  return 'ExchangeRequestsState.updating(requests: $requests, updatingId: $updatingId)';
}


}

/// @nodoc
abstract mixin class _$UpdatingCopyWith<$Res> implements $ExchangeRequestsStateCopyWith<$Res> {
  factory _$UpdatingCopyWith(_Updating value, $Res Function(_Updating) _then) = __$UpdatingCopyWithImpl;
@useResult
$Res call({
 List<ExchangeRequestModel> requests, int updatingId
});




}
/// @nodoc
class __$UpdatingCopyWithImpl<$Res>
    implements _$UpdatingCopyWith<$Res> {
  __$UpdatingCopyWithImpl(this._self, this._then);

  final _Updating _self;
  final $Res Function(_Updating) _then;

/// Create a copy of ExchangeRequestsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requests = null,Object? updatingId = null,}) {
  return _then(_Updating(
requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<ExchangeRequestModel>,updatingId: null == updatingId ? _self.updatingId : updatingId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _UpdateSuccess implements ExchangeRequestsState {
  const _UpdateSuccess(final  List<ExchangeRequestModel> requests): _requests = requests;
  

 final  List<ExchangeRequestModel> _requests;
 List<ExchangeRequestModel> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}


/// Create a copy of ExchangeRequestsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateSuccessCopyWith<_UpdateSuccess> get copyWith => __$UpdateSuccessCopyWithImpl<_UpdateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateSuccess&&const DeepCollectionEquality().equals(other._requests, _requests));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_requests));

@override
String toString() {
  return 'ExchangeRequestsState.updateSuccess(requests: $requests)';
}


}

/// @nodoc
abstract mixin class _$UpdateSuccessCopyWith<$Res> implements $ExchangeRequestsStateCopyWith<$Res> {
  factory _$UpdateSuccessCopyWith(_UpdateSuccess value, $Res Function(_UpdateSuccess) _then) = __$UpdateSuccessCopyWithImpl;
@useResult
$Res call({
 List<ExchangeRequestModel> requests
});




}
/// @nodoc
class __$UpdateSuccessCopyWithImpl<$Res>
    implements _$UpdateSuccessCopyWith<$Res> {
  __$UpdateSuccessCopyWithImpl(this._self, this._then);

  final _UpdateSuccess _self;
  final $Res Function(_UpdateSuccess) _then;

/// Create a copy of ExchangeRequestsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requests = null,}) {
  return _then(_UpdateSuccess(
null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<ExchangeRequestModel>,
  ));
}


}

/// @nodoc


class _Error implements ExchangeRequestsState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of ExchangeRequestsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ExchangeRequestsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ExchangeRequestsStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ExchangeRequestsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
