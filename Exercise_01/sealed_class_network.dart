/// Exercise 2: Sealed Class Network State

sealed class NetworkState {}

class Loading extends NetworkState {}

class Success extends NetworkState {
  final String data;
  Success(this.data);
}

class Error extends NetworkState {
  final String message;
  Error(this.message);
}

void handleState(NetworkState state) {
  switch (state) {
    case Loading():
      print('⏳ Loading...');
    case Success(:final data):
      print('✅ Success! Data: $data');
    case Error(:final message):
      print('❌ Error: $message');
  }
}

void main() {
  print('\nEXERCISE 2: Sealed Class - Network State\n');
  final states = [
    Loading(),
    Success('User data loaded'),
    Error('Network timeout'),
  ];
  states.forEach(handleState);
  print('');
}