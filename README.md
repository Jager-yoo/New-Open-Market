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

<br>

# 📱 시연 영상

|무한 스크롤과 리프레시|Image 컨트롤러|
|:-:|:-:|
|<img src="https://user-images.githubusercontent.com/71127966/166938318-e6e5be81-c989-42be-ab1b-4cf8a28bf0a3.gif" width="300">|<img src="https://user-images.githubusercontent.com/71127966/166938338-b3042390-326f-4df4-91ed-888babccc9b0.gif" width="300">|
|버벅임 없이 무한 스크롤이 가능합니다.<br>리프레시 버튼은 1.5초의 대기시간을 걸었습니다.|사진을 선택하거나 취소할 수 있습니다.<br>최대 개수에 도달하면 Alert 를 보여줍니다.|

|키보드 애드온|상품 등록|
|:-:|:-:|
|<img src="https://user-images.githubusercontent.com/71127966/166940301-70a32662-0b2b-446c-b690-a646589df5e1.gif" width="300">|<img src="https://user-images.githubusercontent.com/71127966/166940315-38f3f073-82a9-4381-b3f8-a05ce560c43c.gif" width="300">|
|textField 사이를 이동할 수 있는<br>버튼을 키보드 위에 구현했습니다.<br>우측엔 키보드 dismiss 버튼을 뒀습니다.|데이터를 검증한 뒤, 서버에 상품을 등록합니다.<br>Alert 를 확인하면 ListView 로 돌아가서<br>자동으로 리프레시합니다.|

|Page Style 이미지 뷰어|상품 수정|
|:-:|:-:|
|<img src="https://user-images.githubusercontent.com/71127966/166942528-7d6a7984-2e35-4b0d-82e2-70ca395ca32a.gif" width="300">|<img src="https://user-images.githubusercontent.com/71127966/166942542-b0483ba4-bcf7-406b-83b2-bb14951c4549.gif" width="300">|
|정방형의 이미지들을 Page 처럼 넘길 수 있습니다.<br>NavigationBar 에 달라붙은<br>Sticky Image 효과를 구현했습니다.|상품 데이터를 변경 후, 서버에 수정을 요청합니다.<br>DetailView 는 즉시 변경되며<br>ListView 로 돌아가면 자동으로 리프레시합니다.|

|다크 모드 토글|상품 삭제|
|:-:|:-:|
|<img src="https://user-images.githubusercontent.com/71127966/166946594-bd196010-9305-43bd-b33f-e80803ac838e.gif" width="300">|<img src="https://user-images.githubusercontent.com/71127966/166946558-c9b13327-9207-4d47-a069-80dad5fd413a.gif" width="300">|
|설정의 다크 모드 토글을 통해<br>앱 전체에 다크 테마를 적용할 수 있습니다.<br>앱을 다시 실행해도 변경 상태가 저장됩니다.|상품 삭제를 서버에 요청합니다.<br>Alert 를 확인하면 ListView 로 돌아가서<br>자동으로 리프레시합니다.|
