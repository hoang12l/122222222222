import SwiftUI
import AVKit
import UniformTypeIdentifiers

@main
struct VTECHApp: App {
    var body: some Scene { WindowGroup { DashboardView().preferredColorScheme(.dark) } }
}

struct DashboardView: View {
    @AppStorage("vehicleName") private var vehicleName = "Tucson 2024"
    @State private var importing = false
    @State private var parked = false
    @State private var sheet: Sheet?
    @State private var video: SelectedVideo?
    @State private var errorMessage: String?
    @State private var loading = false
    private let panel = Color(red: 0.105, green: 0.13, blue: 0.19)
    enum Sheet: String, Identifiable { case guide, settings; var id: String { rawValue } }
    struct SelectedVideo: Identifiable { let id = UUID(); let url: URL }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Giải trí khi đỗ xe").font(.largeTitle.bold())
                    Text("Video cá nhân trên iPhone · \(vehicleName)").foregroundStyle(.secondary)
                    Toggle("Tôi đã đỗ xe an toàn", isOn: $parked).tint(.cyan).accessibilityIdentifier("parkedToggle")
                        .padding().background(panel, in: RoundedRectangle(cornerRadius: 16))
                    VStack(alignment: .leading, spacing: 14) {
                        Label("Thư viện video", systemImage: "film.stack.fill").font(.title2.bold()).foregroundStyle(.cyan)
                        Text("Chọn video từ ứng dụng Tệp để phát trên iPhone. Tệp được mở cho phiên xem này, không sao chép vào ứng dụng.").foregroundStyle(.secondary)
                        Button { importing = true } label: {
                            Label(loading ? "Đang kiểm tra video…" : "Chọn video", systemImage: "folder.badge.plus")
                                .frame(maxWidth: .infinity).padding(8)
                        }.buttonStyle(.borderedProminent).tint(.cyan).disabled(!parked || loading).accessibilityIdentifier("chooseVideo")
                        if !parked { Text("Xác nhận đã đỗ xe để mở trình phát.").font(.caption).foregroundStyle(.secondary) }
                    }.padding(20).background(panel, in: RoundedRectangle(cornerRadius: 22))
                    VStack(alignment: .leading, spacing: 14) {
                        Label("YouTube", systemImage: "play.rectangle.fill").font(.title2.bold()).foregroundStyle(.red)
                        Text("Mở trang YouTube bên ngoài ứng dụng. Không tự đưa YouTube lên màn hình xe.").foregroundStyle(.secondary)
                        Link(destination: URL(string: "https://www.youtube.com")!) {
                            Label("Mở YouTube", systemImage: "arrow.up.right.square").frame(maxWidth: .infinity).padding(8)
                        }.buttonStyle(.bordered).tint(.red).disabled(!parked).accessibilityIdentifier("youtubeLink")
                    }.padding(20).background(panel, in: RoundedRectangle(cornerRadius: 22))
                    VStack(alignment: .leading, spacing: 14) {
                        Label("Trạng thái", systemImage: "info.circle").font(.headline)
                        status("Ứng dụng iPhone", "Phát video từ Tệp", "iphone", .green)
                        status("Màn hình xe", "Chưa xác minh tương thích", "car.side", .orange)
                        status("Tích hợp CarPlay", "Chưa được triển khai trong bản này", "lock", .orange)
                    }.padding(20).background(panel, in: RoundedRectangle(cornerRadius: 22))
                    Button { sheet = .guide } label: {
                        Label("Hướng dẫn sử dụng", systemImage: "list.bullet.rectangle").frame(maxWidth: .infinity)
                    }.buttonStyle(.bordered)
                    Text("VTECH · 0.2 · Chỉ xem video khi đã đỗ xe").font(.caption).foregroundStyle(.secondary).frame(maxWidth: .infinity)
                }.padding(22)
            }.background(Color(red: 0.055, green: 0.075, blue: 0.12))
            .navigationTitle("VTECH").navigationBarTitleDisplayMode(.inline)
            .toolbar { Button { sheet = .settings } label: { Image(systemName: "gearshape") }.accessibilityLabel("Cài đặt").accessibilityIdentifier("settingsButton") }
            .sheet(item: $sheet) { item in
                NavigationStack {
                    Form {
                        if item == .settings {
                            Section("Phương tiện") { TextField("Tên xe", text: $vehicleName).accessibilityIdentifier("vehicleName") }
                            Section("Thông tin") {
                                Text("VTECH CarPlay Video 0.2")
                                Text("Ứng dụng không kiểm tra được vị trí cần số, trạng thái chuyển động hoặc khả năng video của xe.")
                            }
                        } else {
                            Section("Trên iPhone") {
                                Text("1. Đỗ xe an toàn và xác nhận trên màn hình chính.")
                                Text("2. Chọn video → chọn một tệp trong Tệp hoặc iCloud Drive.")
                                Text("3. Dùng điều khiển phát, tua và âm lượng của trình phát hệ thống.")
                                Text("4. Đóng trình phát để dừng video và kết thúc quyền truy cập tệp.")
                            }
                            Section("Màn hình xe") {
                                Text("Bản này phát trên iPhone. Chưa có ứng dụng hoặc entitlement CarPlay; không xác nhận hỗ trợ video trên Tucson. Kiểm tra tài liệu chính thức của xe trước khi dùng chức năng trình chiếu của hệ thống.")
                            }
                            Section("Lỗi phát video") { Text("Tải tệp iCloud về máy, thử video MP4/MOV tương thích iPhone. Đổi tệp nếu video hỏng hoặc codec không được hỗ trợ.") }
                        }
                    }.navigationTitle(item == .settings ? "Cài đặt" : "Hướng dẫn")
                        .toolbar { Button("Đóng") { sheet = nil }.accessibilityIdentifier("closeSheet") }
                }
            }
            .fileImporter(isPresented: $importing, allowedContentTypes: [.movie]) { result in
                switch result {
                case .success(let url):
                    loading = true
                    Task { @MainActor in
                        let scoped = url.startAccessingSecurityScopedResource()
                        defer { loading = false }
                        do {
                            let playable = try await AVURLAsset(url: url).load(.isPlayable)
                            guard playable else { throw VideoError.unsupported }
                            guard parked else {
                                if scoped { url.stopAccessingSecurityScopedResource() }
                                return
                            }
                            // The player owns access until its sheet disappears.
                            activeScopedURL = scoped ? url : nil
                            video = SelectedVideo(url: url)
                        } catch {
                            if scoped { url.stopAccessingSecurityScopedResource() }
                            errorMessage = "Không mở được video. Kiểm tra tệp đã tải về và định dạng tương thích iPhone.\n\(error.localizedDescription)"
                        }
                    }
                case .failure(let error): errorMessage = error.localizedDescription
                }
            }
            .fullScreenCover(item: $video, onDismiss: releaseVideo) { item in PlayerScreen(url: item.url) }
            .alert("Không thể mở video", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("Đóng", role: .cancel) { errorMessage = nil }
            } message: { Text(errorMessage ?? "") }
        }
    }
    @State private var activeScopedURL: URL?
    private func releaseVideo() {
        activeScopedURL?.stopAccessingSecurityScopedResource()
        activeScopedURL = nil
    }
    private func status(_ title: String, _ detail: String, _ symbol: String, _ color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol).foregroundStyle(color).frame(width: 24)
            VStack(alignment: .leading) { Text(title).bold(); Text(detail).font(.caption).foregroundStyle(.secondary) }
        }
    }
}
enum VideoError: LocalizedError {
    case unsupported
    var errorDescription: String? { "Video không được hỗ trợ hoặc tệp bị hỏng." }
}
struct PlayerScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @State private var player: AVPlayer
    @State private var failed = false
    init(url: URL) { _player = State(initialValue: AVPlayer(url: url)) }
    var body: some View {
        NavigationStack {
            VideoPlayer(player: player)
                .navigationTitle("Video cá nhân").navigationBarTitleDisplayMode(.inline)
                .toolbar { Button("Đóng") { player.pause(); dismiss() } }
                .onDisappear { player.pause(); player.replaceCurrentItem(with: nil) }
                .onChange(of: scenePhase) { _, phase in if phase != .active { player.pause() } }
                .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemFailedToPlayToEndTime, object: player.currentItem)) { _ in failed = true }
                .alert("Không phát được video", isPresented: $failed) {
                    Button("Đóng") { dismiss() }
                } message: { Text("Hãy thử tệp MP4/MOV khác tương thích iPhone.") }
        }
    }
}

