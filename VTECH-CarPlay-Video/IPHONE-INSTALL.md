# Cài thử trên iPhone 14 Pro Max / iOS 26 từ Windows

## 1. Chạy build trên GitHub
Gói iPhone-GitHub này có cấu trúc trùng repository hoang12l/122222222222:

```
.github/workflows/iphone.yml
VTECH-CarPlay-Video/project.yml
VTECH-CarPlay-Video/Sources/...
VTECH-CarPlay-Video/UITests/...
```

Đưa nội dung gói vào GỐC repository, không đặt thêm thư mục iPhone-GitHub ở ngoài. Thư mục .github ở gốc là bắt buộc.
Vào Actions → Test and build iPhone IPA → Run workflow. Workflow sẽ chạy kiểm tra giao diện trên Simulator trước, sau đó mới tạo IPA dành cho iPhone vật lý.
Chỉ khi tất cả bước màu xanh, tải artifact VTECH-iPhone-unsigned-IPA và giải nén để lấy VTECHCarPlayVideo-iPhone-unsigned.ipa.
Nếu lỗi, tải VTECH-test-results để chẩn đoán. Chưa có build thực thi thì chưa có IPA thật.

## 2. Ký và cài từ Windows
Tải Sideloadly từ https://sideloadly.io/ và làm theo hướng dẫn Windows chính thức, bao gồm thành phần Apple/iTunes/iCloud mà phiên bản hiện tại yêu cầu.
Kết nối iPhone bằng cáp, mở khóa và chọn Tin cậy máy tính.
Mở Sideloadly, chọn đúng iPhone và IPA ở bước 1, dùng Apple Account của bạn để ký và cài.
Bạn tự nhập mật khẩu và xác thực trong công cụ. Không đưa chúng vào repository hoặc gửi trong chat.
Làm theo yêu cầu Trust Developer trong Settings → General → VPN & Device Management, và bật Developer Mode trong Privacy & Security nếu iOS yêu cầu.
Theo Sideloadly, chữ ký tài khoản miễn phí có hiệu lực 7 ngày; cần gia hạn/ký lại để tiếp tục dùng. Khả năng ký/cài còn phụ thuộc dịch vụ Apple và phiên bản công cụ.

## 3. Test thực tế trên iPhone
- Mở app: chưa xác nhận đỗ xe thì nút chọn video bị khóa.
- Xác nhận đỗ xe rồi chọn một MP4 ngắn tương thích iPhone từ Tệp.
- Nhấn Play; kiểm tra hình, tiếng, tua, tạm dừng, đóng rồi mở lại.
- Hủy bộ chọn tệp; app vẫn dùng được.
- Mở tệp lỗi/không tương thích; kiểm tra thông báo lỗi.
- Khi đang phát, về màn hình chính; video phải tạm dừng.
- Đổi tên xe, đóng và mở lại app; tên vẫn còn.
- Mở hướng dẫn, YouTube và kiểm tra bố cục dọc/ngang, cỡ chữ lớn.

Ghi kết quả vào IPHONE-TEST-REPORT.md. Simulator không thay thế việc test này.
Ứng dụng hiện chỉ chạy trên iPhone; chưa có chức năng phát lên CarPlay.

Nguồn: https://sideloadly.io/faq.html
Apple: https://developer.apple.com/documentation/xcode/running-your-app-on-simulated-or-physical-devices
