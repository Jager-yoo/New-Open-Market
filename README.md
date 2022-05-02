# 🥕 스유 마켓
> 야곰 아카데미 구성원들과 함께 관리하는 오픈 마켓 앱

<br>

# ✨ 핵심 키워드

- SwiftUI (iOS 15.0)
- MVVM 패턴
- 프로토콜 지향 네트워크 레이어
- `async-await` 적용한 비동기 메서드 & 테스트
- PHPickerViewController (iOS 14.0+)
- 무한 스크롤
- SwiftLint (via Homebrew)

<br>

# 🏗 화면 구조

<img width="1207" alt="스유마켓 App 화면 구조" src="https://user-images.githubusercontent.com/71127966/166109655-c0d81b89-1bd5-48e6-9989-fa70e4276496.png">

<br>

# 📡 네트워크 레이어 구조 (클래스 다이어그램)

<img width="1708" alt="스유마켓 Network Layer Class Diagram" src="https://user-images.githubusercontent.com/71127966/166131694-e874884d-21a9-4ecd-80a6-8a23c9762b4d.png">

<br>

# 📂 디렉토리 구조

```
NewOpenMarket
├── Source
│   ├── App
│   ├── Network
│   │   └── API
│   ├── Presentation
│   │   ├── MainView
│   │   ├── ItemsListView
│   │   ├── ItemDetailView
│   │   ├── ItemFormView
│   │   ├── SettingsView
│   │   └── Shared
│   ├── Model
│   ├── Utility
│   ├── Extension
│   └── Resource
└── UnitTests
```
