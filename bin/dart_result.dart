import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:dart_result/result.dart';

@immutable
class UserProfile({
  required final int identifier,
  required final String email,
}) {
  factory fromJson(Map<String, Object?> json) {
    switch (json) {
      case {'id': final int identifier, 'email': final String email}:
        return UserProfile(identifier: identifier, email: email);

      default:
        throw const FormatException('failed to load');
    }
  }
}

class UserProfileModel {
  Future<Result<UserProfile>> fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.https('jsonplaceholder.typicode.com', 'users/1'),
      );

      if (response.statusCode != HttpStatus.ok) {
        return Result.error(HttpException('failed to fetch'));
      }

      return Result.ok(UserProfile.fromJson(jsonDecode(response.body)));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}

class UserProfileViewModel {
  UserProfile? userProfile;
  Exception? error;

  final UserProfileModel model;

  new(this.model) {
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final result = await model.fetchUserProfile();

    switch (result) {
      case Ok():
        userProfile = result.value;

      case Error():
        error = result.error;
    }
  }
}

class UserProfileView {
  final UserProfileViewModel viewModel;

  const new(this.viewModel);

  @override
  String toString() {
    if (viewModel.error != null) {
      return 'Error: ${viewModel.error!}';
    }

    if (viewModel.userProfile != null) {
      return 'User Profile: ${viewModel.userProfile!.email}';
    }

    return 'Loading...';
  }
}

void main(List<String> arguments) async {
  final model = UserProfileModel();
  final viewModel = UserProfileViewModel(model);
  final view = UserProfileView(viewModel);

  await Future.delayed(Duration(seconds: 3));

  print(view);
}
