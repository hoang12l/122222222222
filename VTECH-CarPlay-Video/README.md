# VTECH CarPlay Video v0.1 — UI prototype

## Chức năng
- SwiftUI native iPhone UI; nút mở YouTube trong Safari.
- Thông tin trạng thái minh bạch, hướng dẫn kiểm tra video khi đỗ.
- HTML UI preview trên Windows: mở `Preview/index.html`.
- GitHub Actions build iOS Simulator app unsigned (KHÔNG phải IPA cài iPhone thật).

## Build qua GitHub từ Windows
1. Tạo GitHub repository mới, upload toàn bộ nội dung thư mục này, gồm `.github/workflows/build-ios.yml` (bật hiển thị hidden files).
2. Vào tab Actions → Build iOS simulator demo → Run workflow.
3. Tải artifact `VTECHCarPlayVideo-Simulator` sau khi job thành công.
4. File `.app` là bản dành cho iOS Simulator; không cài được trực tiếp lên iPhone thật.

## Để cài trên iPhone thật
Cần ký ứng dụng với Apple provisioning profile và chạy build/archive iOS device trên macOS/Xcode. GitHub Actions có thể build nhưng không thay thế yêu cầu code signing. Không chia sẻ tài khoản Apple hoặc private signing keys công khai.

## Giới hạn bắt buộc
Ứng dụng này KHÔNG mở khóa CarPlay, KHÔNG tự thêm YouTube vào giao diện CarPlay, KHÔNG can thiệp firmware Hyundai và KHÔNG giả mạo entitlement. Video CarPlay chỉ hoạt động khi hệ thống xe hỗ trợ và ứng dụng có entitlement thích hợp. Để phát YouTube phải tuân thủ chính sách YouTube.
