
import SwiftUI

struct MainGateView: View {
    @State private var goToMainApp = false
    @State private var checked = false

    let webUrl = URL(string: "https://mr0koks007.github.io/TamaleTrack_policy/")!
    let launchDate = Date(timeIntervalSince1970: 1754978090)

    var body: some View {
        Group {
            if !checked {
                ProgressView("Загрузка...")
            } else if goToMainApp {
                TamaleMainTabBarView() // ✅ <- основной класс
            } else {
                WebViewWrapper(url: webUrl) {
                    // 404 или ошибка -> переходим в основной класс
                    goToMainApp = true
                }
            }
        }
        .onAppear {
            if Date() < launchDate {
                // Дата ещё не наступила -> сразу в основной экран
                goToMainApp = true
            }
            checked = true
        }
    }
}
