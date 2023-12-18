class ResponseData<T> {
  ResponseData(this.statusCode, this.data, {this.message});

  List<T> data;
  int statusCode;
  String? message;
}