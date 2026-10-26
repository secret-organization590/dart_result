sealed class Result<T> {
  const Result();

  const factory ok(T value) = Ok._;

  const factory error(Exception error) = Error._;
}

final class Ok<T> extends Result<T> {
  final T value;

  const new _(this.value);
}

final class Error<T> extends Result<T> {
  final Exception error;

  const new _(this.error);
}
