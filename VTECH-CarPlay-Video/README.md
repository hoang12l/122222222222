# VTECH CarPlay Video 0.2

Ứng dụng iPhone để mở video cá nhân khi đã đỗ xe. Có bản xem trước chạy trên Windows.

## Đã triển khai
- Chọn một video trong Tệp/iCloud Drive, kiểm tra khả năng phát và mở bằng AVKit.
- Giữ quyền đọc tệp trong phiên xem, giải phóng khi đóng; không sao chép video.
- Điều khiển phát/tua/âm lượng hệ thống, tạm dừng khi ứng dụng không hoạt động.
- Xác nhận đã đỗ xe trước khi mở video hoặc YouTube; đây là xác nhận thủ công, không phải cảm biến xe.
- Cài đặt tên xe được lưu trên thiết bị; hướng dẫn và thông báo lỗi bằng tiếng Việt.
- YouTube mở ngoài ứng dụng; không tải hoặc trích xuất video YouTube.

## Chạy bản xem trước trên Windows
Mở `Preview/index.html` bằng Edge hoặc Chrome. Xác nhận đã đỗ xe rồi chọn video trên máy. Tên xe được lưu nếu trình duyệt cho phép localStorage. Video không được tải lên mạng và chỉ tồn tại trong phiên xem.

## Build iPhone trên Mac
Yêu cầu macOS, Xcode có iOS SDK 17 trở lên, XcodeGen.

```sh
brew install xcodegen
xcodegen generate
open VTECHCarPlayVideo.xcodeproj
```

Chọn scheme VTECHCarPlayVideo và một iPhone Simulator rồi Run. Để cài iPhone thật, chọn Team của bạn trong Signing & Capabilities, đổi bundle identifier thành giá trị riêng và bật Automatically manage signing. Cần thiết bị/profile phù hợp. Không có IPA đã ký trong gói này.

## Build tự động qua GitHub
Upload toàn bộ thư mục (bao gồm `.github`) vào repository. Actions → Build iOS simulator demo → Run workflow. Workflow biên dịch bản Simulator không ký và cung cấp ZIP chứa `.app`. File đó chỉ chạy trong Simulator trên Mac, không cài trực tiếp lên iPhone. Pull request cũng được kiểm tra build.

## Phạm vi và giới hạn
Đây là ứng dụng iPhone; chưa có CarPlay scene hoặc entitlement, không đưa YouTube lên màn hình xe và không xác nhận khả năng phát video của Tucson. Không sửa firmware hay jailbreak. Tên xe trong cài đặt chỉ là nhãn hiển thị. Video DRM hoặc codec không tương thích có thể không phát được. Chỉ xem video khi đã đỗ xe an toàn.

## Kiểm tra thủ công trước khi phát hành
Xem `CHECKLIST.md`. Mã iOS cần được build và kiểm tra trên Mac/iPhone trước khi phát hành. Gói này được chuẩn bị trên Windows nên không khẳng định đã biên dịch thành công bằng Xcode.

## Tài liệu API
- Apple fileImporter: https://developer.apple.com/documentation/swiftui/view/fileimporter(ispresented:allowedcontenttypes:oncompletion:)
- Apple VideoPlayer: https://developer.apple.com/documentation/avkit/videoplayer
