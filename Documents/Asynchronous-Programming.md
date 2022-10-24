# 비동기 프로그래밍

<br />

## 들어가기전에

Rx, Reactive Programming이 비동기 프로그래밍을 잘하기 위한 노력이라고 이전 시간([Reactive Programming 편](https://github.com/Taehyeon-Kim/Go-RxSwift/blob/master/Reactive-Programming.md))에 배웠는데   
그럼 비동기? 비동기 프로그래밍이 무엇일가요? 간단하게 살펴보도록 하죠.

<br />

## 비동기 프로그래밍?

iOS 앱은 다음과 같은 작업을 수행할 수 있습니다.

- 버튼 탭(클릭)에 반응하기
- 키보드를 텍스트 필드로 애니메이션하면 포커스가 사라짐
- 인터넷에서 큰 사진 다운로드 → 다운로드 중에 다른 작업을 수행
- 데이터 비트를 디스크에 저장
- 오디오 재생

<img src = "https://user-images.githubusercontent.com/61109660/130630347-11b48340-4efe-4a6a-9a87-d4e1d0a4b350.png" width = "700" />

출처 : Raywenderich - [여기](https://www.raywenderlich.com/books/rxswift-reactive-programming-with-swift/v4.0/chapters/1-hello-rxswift) 클릭

한 번 생각을 해보면 각각의 작업들은 서로의 실행을 차단하지 않습니다.

서로 다른 스레드에서 서로 다른 작업을 수행할 수 있도록 iOS는 다양한 종류의 API를 제공합니다.

<br />

## Apple의 Cocoa and UIKit asynchronous APIs (비동기 API)

한 번쯤 사용해봤거나 들어본 내용일 것입니다.  
Apple은 iOS SDK에서 비동기식 코드를 작성할 수 있도록 다음과 같은 방법들을 제공하고 있습니다.

- NotificationCenter
- Delegate Pattern
- Grand Central Dispatch(GCD)
- Closures
- Combine - iOS13부터 이용가능한 API

대부분의 클래스들은 개발자의 의도와 다르게 비동기적으로 수행하고,   
UI 요소의 경우도 본질적으로 비동기적입니다.

개발자가 앱 코드를 작성했을 때, 매번 어떤 순서로 작동한다고 가정하는 것은 불가능합니다.  
사용자와의 인터랙션, 네트워킹, 이벤트 등의 외부 요인에 의해 완전히 다른 순서로 실행될 수 있습니다.

<br />

## 비동기 프로그래밍을 하다 보면 갖게 되는 문제 의식

```
🗣 클래스와 함수의 작동 순서를 보장할 수 없습니다!
```

어떤 것이 먼저 리턴될지, 작동 순서를 보장할 수 없기 대문에 코드를 작성하다보면 자연스럽게 뎁스가 복잡해지는 코드가 만들어집니다.

- 코드 예시

    ```swift
    IBAction func onLoad() {
        editView.text = ""
        self.setVisibleWithAnimation(self.activityIndicator, true)
        
        downloadJson(MEMBER_LIST_URL) { json in
            self.editView.text = json
            self.setVisibleWithAnimation(self.activityIndicator, false)
            
            self.downloadJson(MEMBER_LIST_URL) { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            }
            
            self.downloadJson(MEMBER_LIST_URL) { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            }
            
            self.downloadJson(MEMBER_LIST_URL) { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            }
            
            self.downloadJson(MEMBER_LIST_URL) { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            }
        }
    }
    ```

<br />

```
🗣 처리해야 할 작업이 많아질 경우 코드가 복잡해진다.
```

Swift 개발을 하다보면 **Escaping Closure** 및 **Completion Handler**를 사용하는 비동기 프로그래밍을 많이 하게 됩니다.   
많은 비동기 작업, 오류 처리, 비동기 호출 간의 제어 흐름이 복잡할 때 문제가 생기게 됩니다.

기본적으로 Apple에서 제공하는 API(ex. GCD)를 사용해서 비동기 프로그래밍을 하면서도 여러 문제점을 느끼게 되죠.   
DispatchQueue나 클로저만으로도 비동기 프로그래밍이 가능은 하지만 처리해야할 작업이 많아질 경우 코드가 매우 복잡해지는 문제가 생기게 됩니다.

<br />

```
🗣 비동기 작업의 경우 즉시 결과가 나오지 않는다.
```

나중에 데이터가 오면 처리하는 방식으로 코드를 짜고 싶습니다. Completion Handler 말고 Return 값으로 처리하고 싶은거죠.   
그것을 가능하게 해주는 것이 Rx의 Observable입니다. (우리는 RxSwift에서의 Observable 이겠죠?)

<br />

나중에 다시 알아보겠지만 정리해보면 다음과 같습니다.

> **[Rx(Swift)란 비동기적으로 생기는 데이터를 completion 같은 closure로 전달하는 것이 아니라 return 값으로 전달하기 위해서 만들어진 유틸리티(API)이다.](https://haningya.tistory.com/112)**

<br />

## 비동기 라이브러리에서 필요한 4가지

모든 비동기작업을 처리하는 라이브러리에서 필요한 것은 다음과 같습니다.

나머지 항목에 대한 자세한 내용은 [여기](https://dev-daddy.tistory.com/25)에서 읽어보세요.  
우리는 이 중에서 스레드 관리에 집중해봅시다.

- 명시적 실행(Explicit execution)

    새로운 스레드에서 작업을 시작하면 그것을 컨트롤할 수 있어야 한다.

- **쉬운 스레드 관리(Easy thread management)**

    ```
    🗣
    비동기작업에서 스레드 관리가 핵심이다.
    백그라운드 작업 도중이나 작업이 끝난 후, (예를 들면 네트워킹 처리 후)
    메인스레드에서 UI를 업데이트해야 할 때가 있다.

    이 때 스레드(백그라운드) → 다른 스레드(메인)로 작업을 넘겨야 하는데
    스레드를 쉽게 전환하고 필요한 경우 다른 스레드로 작업을 넘길 수 있어야 한다.
    ```

- 쉬운 구성력(Easily composable)

    비동기작업을 생성하고 시작하면 그것은 다른 어떤 스레드에 의존하지 않고 작업이 끝날 때까지 독립적으로 유지하는 것이 좋다.

- 부작용 최소화(Minimum the sid effects)

    멀티 스레드가 수행되는 동안 스레드 서로 간 영향을 끼치는 부작용을 최소화해야한다.

<br />

## 마무리 시간

### 비동기 프로그래밍

우리는 개발을 하게 될 때 필수불가결하게 비동기 프로그래밍을 하게 됩니다.

네트워크 통신만을 보더라도 우리는 서버에서 데이터를 받아올 때 결과 데이터가 언제 도착할 지 모르고, 결과 데이터가 도착하면 어떤 처리를 하게 되죠?   
이처럼 우리는 작업에 대한 순서를 항상 보장할 수 없습니다. 그렇기 때문에 비동기적 프로그래밍이 필요한 것입니다.

### 문제점

비동기적 프로그래밍을 할 때에 보통 Closure와 Completion handler를 이용해서 코드를 작성합니다.   
이 경우 작업이 많아질 경우 코드가 복잡해질 수 있습니다. 리턴값을 받아서 처리하고 싶다는 생각이 자연스럽게 들게 되는데 이 때 우리는 RxSwift를 이용할 수 있습니다.

### 요약

```
비동기 프로그래밍이란 각각의 스레드가 독립적으로 자기 작업을 수행하는 것을 의미하고, 그렇기 때문에 작업 순서를 보장할 수 없다. 
간단하게 말하면 어떤 스레드가 먼저 작업을 마칠지 알 수 없다는 것이다.
```

<br />

## 레퍼런스

[https://gaki2745.github.io/swift/2019/10/13/Swift-RxSwift-01/](https://gaki2745.github.io/swift/2019/10/13/Swift-RxSwift-01/)

[https://zeddios.tistory.com/1230](https://zeddios.tistory.com/1230)

[https://duda-programming.tistory.com/48](https://duda-programming.tistory.com/48)

[https://haningya.tistory.com/112](https://haningya.tistory.com/112)

[https://dev-daddy.tistory.com/25](https://dev-daddy.tistory.com/25)
