# RxCocoa의 개념적 이해

```
이번에는 RxCocoa에 대해서 알아봅시다^^
RxCocoa를 생각해보면 UI에 Rx를 적용하기 위한 라이브러리가 아닐까 싶습니다.

사실 위에서 이야기한 내용은 정확한 정의가 되지는 못합니다.
그러나 처음부터 정확한 이론이나 정의에 집중하다가는 공부할 맛이 나지 않을 것 같아서..
우선은 사용하고 봅시다!!!😏

어차피 내가 사용해봐야 정리가 되는거니깐 ~~

(소곤소곤)밑에서 이론을 살펴보긴 합니다🙃
```

<br />

## 들어가기전에

ㅇㅏ, 잠깐!! 절대 여기서 한 번에 다 이해안되는게 정상이니까 그냥 편하게 살펴봅시다~!~!🐶

본격적으로 들어가기전에 우리의 목표를 생각해봅시다. 이 파트를 다 보고 난 뒤에는 어떤 모습을 갖춰야할지! 맞아요, 코드를 작성할수는 있어야 겠죠..? 우리 RxSwift 적용할거 잖아요! 우리 RxCocoa 사용해서 UI 보여줄 거 잖아요!!!!!! (분노 😠) ~~(거의 분조장)~~

솔직히 다 보고나서 이론은 기억못해도 코드 작성해볼 수 있도록 합시다 😁 

네 잠시 진정 좀 하고 천천히 하나씩 살펴보도록 하져 👉👉 **고고고** ~~(맨날 서론이 긴 이상한 정리법)~~

<br />

## 1. RxCocoa는 누구고 왜 사용하는걸까?

### RxCocoa의 개념

정리부터하고 들어가자면 다음과 같이 설명할 수 있습니다.

- 애플 환경의 애플리케이션을 제작하기 위한 도구들을 모아놓은 기존의 **Cocoa Framework를 Rx와 합친 기능**을 제공하는 라이브러리 (RxSwift와 별도로 추가해주어야 사용할 수 있습니다.)
- UI Control과 다른 SDK 클래스를 Wrapping한 커스텀 Extension set
- 다양한 protocol을 extension한 것들과 UIKit을 위한 rx 영역을 제공하는 프레임워크

### 코코아 터치 프레임워크(Cocoa Touch Framework)

여기부터는 잠깐 TMI이기 때문에 넘어갈 사람은 넘어가세요~

- 코코아라는 단어는 NSObject를 상속받는 모든 클래스, 객체를 가리킬 때 사용한다.
- 자바의 어원이 개발자들이 자주 마시던 인도네시아산 커피 이름에서 따온 것이라는 이야기가 있는데, 코코아라는 이름은 애플 개발자들이 '어린이도 개발할 수 있게하자' · '어린이를 위한 Java를 만들자' 라는 의미에서 코코아라는 단어를 가져왔다고 한다.
- 코코아 터치 프레임워크란 iOS 개발 환경을 구축하기 위한 최상위 프레임워크다.
- 코코아 프레임워크는 macOS 개발을 위한 프레임워크이며 아이폰, 아이패드의 터치 기반의 iOS 개발 환경에 사용하여 코코아 터치 프레임워크라고 이름이 붙었다.

    <img src = "https://user-images.githubusercontent.com/61109660/131636700-a95b4d45-317c-434f-83d4-8404e699c0d4.png" width = "300" />


    터치와 관련된 디바이스의 애플리케이션을 개발할 때 우리는 코코아 터치 프레임워크를 사용하는데요. 보통 iOS 개발할때는 코코아 터치 프레임워크를 사용합니다. 우리가 책보다 자주 만나는 UIKit이랑 Foundation 프레임워크가 이 안에 포함되어 있죠.

위에서 무슨 익스텐션 세트다, 코코아 프레임워크를 합친거다... 굉장히 추상적으로 설명이 되었는데, RxCocoa가 뭐냐고 제게 물어본다면,, 밑의 개념 정의가 가장 와닿을 것 같아서 다음과 같이 말할 거 같아요!

> RxSwift는 일반적인 Rx API라서, Cocoa나 특정 UIKit 클래스에 대한 아무런 정보가 없다. RxCocoa는 RxSwift의 동반 라이브러리로써, **UIKit과 Cocoa 프레임워크 기반 개발을 지원하는 모든 클래스를 보유**하는 친구이다.

**[인용 출처]**: [https://jinshine.github.io/2019/01/01/RxSwift/1.RxSwift란/](https://jinshine.github.io/2019/01/01/RxSwift/1.RxSwift%EB%9E%80/)

**한 줄 정리**

> UIKit 관련해서 개발할때도 Rx기능을 이용하고 싶어? 그럼 RxCocoa 라이브러리 사용하는거야 👌 ⁇ 

<br />

## 2. RxCocoa를 알기 전 용어 정리

- **ObserverType** : **값을 주입시킬 수 있는 타입**
- **ObservableType** : **값의 변화를 관찰할 수 있는 타입**
- **ControlProperty** : subject와 같이 프로퍼티에 새 값을 주입시킬 수 있고, 값의 변화도 관찰할 수 있는 타입, ObserverType과 ObservableType을 준수함.
    - 코드 예시 (UITextField+Rx.swift)

        Text 라는 프로퍼티가 ControlProperty 타입을 따르고 있는 것을 확인할 수 있다.

        ```swift
        import RxSwift
        import UIKit

        extension Reactive where Base: UITextField {
            /// Reactive wrapper for `text` property.
            public var text: ControlProperty<String?> {
                value
            }
            
            /// Reactive wrapper for `text` property.
            public var value: ControlProperty<String?> {
                return base.rx.controlPropertyWithDefaultEvents(
                    getter: { textField in
                        textField.text
                    },
                    setter: { textField, value in
                        // This check is important because setting text value always clears control state
                        // including marked text selection which is imporant for proper input 
                        // when IME input method is used.
                        if textField.text != value {
                            textField.text = value
                        }
                    }
                )
            }
            
            /// Bindable sink for `attributedText` property.
            public var attributedText: ControlProperty<NSAttributedString?> {
                return base.rx.controlPropertyWithDefaultEvents(
                    getter: { textField in
                        textField.attributedText
                    },
                    setter: { textField, value in
                        // This check is important because setting text value always clears control state
                        // including marked text selection which is imporant for proper input
                        // when IME input method is used.
                        if textField.attributedText != value {
                            textField.attributedText = value
                        }
                    }
                )
            }
        }
        ```

- **Binder** : ObserverType을 따름 (값을 주입시킬 수는 있지만, 값을 관찰할 수 없음)

    (error를 값으로 받을 수 없고, error가 주입되면 fatalError가 발생)

    - 코드 예시 (Binder.swift)

        ```swift
        public struct Binder<Value>: ObserverType {
            public typealias Element = Value
        		// ... 내용생략
        }
        ```

- **Subscribe** : 구독한다라는 의미로써 사용, 한 대상에 대해서 Subscribe를 하면 그 대상의 상태가 변했을 때 (complete, error, next) 그 값을 받아와서 처리할 수 있는 개념.
- **Bind** : 내부적으로 subscribe를 사용함, 단순히 새로 생성되는 값을 넘겨줄 때 간편하게 쓰는 용도로 쓰이는 것으로 보임, 에러처리를 따로 해주지는 않는다.

    ```swift
    public func bind(onNext: @escaping (Element) -> Void) -> Disposable {
    	return self.subscribe(onNext: onNext, onError: { error in
    		rxFatalErrorInDebug("Binding error: \(error)")
    	}
    }
    ```

- **Drive** : 내부적으로 subscribe를 사용, 무조건 Main Scheduler(Main Thread)에서 동작, UI에 관련된 코드를 작성할 때 적합, Relay와 주로 같이 사용

    ```swift
    //Driver+Subscription.swift

    public func drive(
            onNext: ((Element) -> Void)? = nil,
            onCompleted: (() -> Void)? = nil,
            onDisposed: (() -> Void)? = nil
        ) -> Disposable {
            MainScheduler.ensureRunningOnMainThread(errorMessage: errorMessage)
            return self.asObservable().subscribe(onNext: onNext, onCompleted: onCompleted, onDisposed: onDisposed)
        }
    ```

    ⇒ 값을 단순히 사용하거나 저장할 때는 subscribe, bind / UI 관련 작업일 때는 drive 목적에 맞게 구분지어서 사용하는 것이 좋을 듯

- **Traits** : UI 작업 시 코드를 쉽고 직관적으로 작성해 사용할 수 있도록 도와주는 특별한 Observable 클래스 모음

<br />

## 3. RxCocoa 살짝 더 알아보기

- RxCocoa는 단방향성을 가지고 있다.
- Producer는 값을 생성하고, Consumer는 값을 처리하는 역할을 함
- 이벤트를 발생하는 producer가 처리하는 consumer에게 **bind(to:)** 시키는 것이 중요
    - producer는 값을 내놓는 녀석
    - consumer는 값을 사용하는 녀석 → 뭔가 UILabel이나 UITableView 등이 예시가 될 수 있을 것 같다.

![q2](https://user-images.githubusercontent.com/61109660/131636992-ffe7077c-a853-4eff-9fdb-6a1be09d04e5.png)


## 4. 그렇다면 Bind란...?

RxCocoa에서 어쨌든 서로의 이벤트를 연결짓고 값을 넘겨주려면 Bind라는 개념이 중요한 것 같은데 Bind란 무엇일까? 

**다음 편에 계속~**

<br />

## 참고자료

[[RxCocoa] 1. 맛보기](https://ios-development.tistory.com/137?category=909631)

[RxSwift 12) RxCocoa - 2/2](https://iospanda.tistory.com/entry/RxSwift-11-RxCocoa-22?category=751847)

[[RxSwift Book] Chapter 12: Beginning RxCocoa](https://jusung.github.io/RxSwift-Section12/)

[[RxSwift] bind, subscribe, drive](https://nsios.tistory.com/66)

[[RxCocoa] 2. 기본 개념](https://ios-development.tistory.com/143)

[RxSwift 6가 나왔다.](https://bonoogi.postype.com/post/8893866)
