import 'dart:developer';

void errorLogger({required String functionName, required String error}) =>
    log('exception in function $functionName $error');

String getErrorMessage(result) =>
    (result.exception as dynamic).message ?? result.exception.toString();

num getPrice(double price) => price.toInt() == price ? price.toInt() : price;
