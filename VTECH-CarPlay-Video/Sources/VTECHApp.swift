import SwiftUI

@main
struct VTECHApp: App {
    var body: some Scene { WindowGroup { DashboardView() } }
}

struct DashboardView: View {
    @State private var showGuide = false
    @State private var showInfo = false
    private let bg = Color(red: 0.055, green: 0.075, blue: 0.12)
    private let panel = Color(red: 0.105, green: 0.13, blue: 0.19)
    var body: some View {
        ZStack {
            bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Image(systemName: "car.side.fill").font(.title2).foregroundStyle(.cyan)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("VTECH").font(.system(size: 23, weight: .black, design: .rounded))
                            Text("CARPLAY VIDEO · DEMO").font(.system(size: 10, weight: .semibold)).tracking(2).foregroundStyle(.gray)
                        }
                        Spacer()
                        Image(systemName: "gearshape.fill").foregroundStyle(.gray)
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Giải trí khi đỗ xe").font(.system(size: 30, weight: .bold, design: .rounded))
                        Text("Giao diện thử nghiệm dành cho iPhone và Tucson 2024.")
                            .font(.subheadline).foregroundStyle(.gray)
                    }
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Image(systemName: "play.rectangle.fill").font(.system(size: 48)).foregroundStyle(.red)
                            Spacer()
                            Text("VIDEO").font(.caption2).bold().padding(8).background(.white.opacity(0.1)).clipShape(Capsule())
                        }
                        Text("YouTube").font(.title2).bold()
                        Text("Mở YouTube trên iPhone. Chỉ phát lên xe nếu hệ thống hỗ trợ video CarPlay/AirPlay.")
                            .font(.subheadline).foregroundStyle(.gray)
                        Button { if let url = URL(string: "https://www.youtube.com") { UIApplication.shared.open(url) } } label: {
                            Label("Mở YouTube trên iPhone", systemImage: "arrow.up.right")
                                .font(.headline).frame(maxWidth: .infinity).padding(15)
                        }
                        .buttonStyle(.plain).background(Color.red).clipShape(RoundedRectangle(cornerRadius: 13))
                    }.padding(20).background(panel).clipShape(RoundedRectangle(cornerRadius: 22))
                    VStack(alignment: .leading, spacing: 14) {
                        Label("TRẠNG THÁI", systemImage: "checkmark.shield").font(.caption).bold().foregroundStyle(.gray)
                        status("Ứng dụng iPhone", "Bản mẫu giao diện", "checkmark.circle.fill", .green)
                        status("Video trên Tucson", "Chưa xác minh tương thích", "questionmark.circle.fill", .orange)
                        status("Quyền CarPlay Video", "Chưa được cấp", "lock.fill", .orange)
                    }.padding(20).background(panel).clipShape(RoundedRectangle(cornerRadius: 22))
                    Button { showGuide = true } label: {
                        Label("Hướng dẫn kiểm tra trên xe", systemImage: "list.bullet.rectangle")
                            .frame(maxWidth: .infinity).padding(15)
                    }.buttonStyle(.plain).background(.white.opacity(0.10)).clipShape(RoundedRectangle(cornerRadius: 13))
                    Button { showInfo = true } label: { Text("Giới hạn kỹ thuật & pháp lý").font(.footnote).foregroundStyle(.cyan) }
                        .frame(maxWidth: .infinity)
                    Text("VTECH · Prototype 0.1 · Không phát video khi lái xe")
                        .font(.caption2).foregroundStyle(.gray).frame(maxWidth: .infinity)
                }.padding(22)
            }
        }
        .foregroundStyle(.white)
        .alert("Kiểm tra trên Tucson", isPresented: $showGuide) {
            Button("Đã hiểu", role: .cancel) { }
        } message: {
            Text("1. Đỗ xe và chuyển về P. 2. Kết nối iPhone với CarPlay. 3. Mở video bằng ứng dụng có AirPlay. 4. Kiểm tra xem màn hình xe có xuất hiện trong danh sách phát video không. Không có nghĩa là YouTube được thêm vào CarPlay.")
        }
        .alert("Giới hạn của bản mẫu", isPresented: $showInfo) {
            Button("Đóng", role: .cancel) { }
        } message: {
            Text("Bản mẫu không sử dụng entitlement CarPlay Video, không jailbreak, không thay đổi firmware và không thể đưa YouTube vào CarPlay nếu xe không hỗ trợ.")
        }
    }
    private func status(_ title: String, _ detail: String, _ symbol: String, _ color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol).foregroundStyle(color).frame(width: 24)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.subheadline).bold()
                Text(detail).font(.caption).foregroundStyle(.gray)
            }
            Spacer()
        }
    }
}
