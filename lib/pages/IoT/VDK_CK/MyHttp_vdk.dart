import 'package:http/http.dart' as http;

class MyHttpClient {
  final String baseUrlStepper;
  final String baseUrlMotor;

  MyHttpClient({
    this.baseUrlStepper = '',
    this.baseUrlMotor = '',
  });

  // Kết nối stepper với tham số cho ID của cửa
  Future<void> connectStepper(String doorId, int step) async {
    final url = '$baseUrlStepper$doorId?step=$step';
    await _performRequest(url);
  }

  // Bật motor với tham số cho ID của cửa
  Future<void> turnOnMotor(String doorId) async {
    final url = '$baseUrlMotor$doorId/turnOnMotor';
    print(url); // In ra URL để kiểm tra (không cần thiết
    await _performRequest(url);
  }

  // Tắt motor với tham số cho ID của cửa
  Future<void> turnOffMotor(String doorId) async {
    final url = '$baseUrlMotor$doorId/turnOffMotor';
    print(url); // In ra URL để kiểm tra (không cần thiết

    await _performRequest(url);
  }

  // Phương thức chung để thực hiện yêu cầu HTTP GET
  Future<void> _performRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Nếu kết nối thành công, xử lý dữ liệu tại đây
        print('Success: ${response.body}');
      } else {
        // Nếu kết nối thất bại, xử lý lỗi tại đây
        print('Failed to connect. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi ngoại lệ, xử lý lỗi tại đây
      print('Error: $e');
    }
  }
}
