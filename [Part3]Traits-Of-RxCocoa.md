# RxCocoa의 Traits, 그 중에서 Drive?

이 글에서는 `driver` 에 대해서 살펴보도록 하겠습니다. 막 내용이 쏟아지느라 머리 속이 복잡하더라도 driver의 역할만 간단하게 살펴보도록 합시다. 

나중에는 자연스럽게 사용하면 되니까요~

<br />

## 1. Traits의 개념

`UI에 특화된 Observable` `Binder와는 반대..` `Driver만 기억해도 절반 성공`

<br />

### Point 1. UI 처리에 특화된 Observable

> Traits는 **UI 처리에 특화된 Observable 입니다.**

> Observable이기 때문에, **UI Binding에서 데이터 생산자 역할을 수행한다**

옵저버블이기 때문에, UI Binding에서 **데이터 생산자 역할**을 수행하겠죠? 기억 안나면 위에서 바인딩(Binding)개념 다시 보고 오기👀  

한마디로 **Binder와 반대되는 개념**이랍니다.

<br />

### Point 2. 메인 스레드에서 실행

Traits는 위에서 말했듯이 UI에 특화된 옵저버블이고, 모든 작업은 메인 스케쥴러(Main Scheduler)에서 실행이 됩니다. 

한마디로 **메인 스레드(Main Thread)** 에서 실행된다는 이야기에요!!

Wow~~?! 그러면 따로 스케쥴러를 지정할 필요가 없어요..!!!! Amazing?!

<br />

### Point 3 - Traits는 에러 이벤트를 전달하지 않는다.

여기서 잠깐, 잠깐만 짚고 넘어갈 이야기가 있어요.. 만약에 옵저버블 시퀀스가 에러 이벤트를 발생시킨다면? 

에러 이벤트로 종료된다면 연결되어 있는 UI는 어떻게 될까요?

**맞아요.. 더 이상 UI 업데이트가 일어나지 않겠죠? 중간에 에러 한 번 발생해버리면 더 이상 업데이트가 안되니까 정말로 큰일이에요..**

그래서 우리는 Traits를 사용하게 됩니다.
Traits는 **에러 이벤트를 전달하지 않아서** 위 문제는 걱정하지 않아도 됩니다!!!

<br />

### Point 4 - Traits는 새로운 시퀀스를 시작하지 않는다.

아, 그리고 원래 옵저버블을 구독하면 새로운 시퀀스가 시작이 되잖아요?? 
근데 Traits는 옵저버블임에도 불구하고 새로운 시퀀스가 시작되지 않아요..!

<br />

### Point 5 - Traits를 구독하는 모든 구독자는 동일한 시퀀스를 공유한다.

일반적인 Observable에서 share 연산자를 사용한 것과 동일

<img src = "https://user-images.githubusercontent.com/61109660/131637773-8f6bd344-f65d-46f8-9e73-a022bcaf904b.png" width = "" />

<br />

## 💥 여기서 잠깐

### Traits 잠깐 정리

- UI에 특화된 옵저버블
- 메인 스레드에서 실행
- 에러 이벤트 전달 ❌
- 새로운 시퀀스 시작 ❌
- 모든 구독자는 동일한 시퀀스 공유

솔직히 위에서 좋은 점만 이야기했기도 하고,, 사용하지 않을 이유가 딱히 없어요..!

그래서 적극적으로 활용하는 것을 추천한다고 합니다! (근데 필수는 아닙니다!)

<br />

## 2. Traits 종류

### 1. **Control Property**

Subject와 같이 프로퍼티에 새 값을 주입시킬 수 있고(ObserverType) 값의 변화도 관찰할 수 있는 타입(ObservableType)입니다.

컨트롤에 data를 binding 하기 위해 사용 (rx namespace 사용) ex. `.rx`

<img src = "https://user-images.githubusercontent.com/61109660/131638020-ff79edc0-c678-437d-94a9-07f67ce4cfb0.png" width = "" />


RxCocoa는 Extension으로 Cocoa의 View를 확장하고, 동일한 이름을 가진 속성을 추가합니다.

- 이런 속성들 대부분 Control Property 형식으로 선언되어 있어요..
- ControlPropertyType 프로토콜은 ObservableType과 ObserverType 프로토콜을 상속하고 있습니다.
- ControlProperty는 특별한 옵저버블이면서 동시에 특별한 옵저버입니다.

    → 여기서 Subject가 떠오르는 건... 나만...그런건가

- UI Binding에 사용되는데요.. 그래서 에러 이벤트를 전달 받지도 않고, 전달 하지도 않습니다.

- 예) UITextField+Rx.Swift의 text 프로퍼티는 ControlProperty

```swift
extension Reactive where Base: UITextField {
    /// Reactive wrapper for `text` property.
    public var text: ControlProperty<String?> {
        return value
    }
    //  이후 내용 생략
}
```

- ControlProperty는 ControlPropertyType를 따름

```swift
public struct ControlProperty<PropertyType> : ControlPropertyType {
// 이후 내용 생략
}
```

- ControlPropertyType은 ObservableType과 ObserverType을 따름을 확인

```swift
public protocol ControlPropertyType : ObservableType, ObserverType {
    /// - returns: `ControlProperty` interface
    func asControlProperty() -> ControlProperty<Element>
}
```

### 2. **Control Event**

- 컨트롤의 이벤트를 수신하기 위해 사용됩니다.

  ![q6](https://user-images.githubusercontent.com/61109660/131638153-4a7e4201-e93d-4d56-ac20-f779661ef864.png)

- UI Control을 상속한 Control들은 다양한 이벤트를 전달합니다.

  <img src = "https://user-images.githubusercontent.com/61109660/131638249-30af2b77-e0b1-459a-83e7-cc408a519e5a.png"  width = "400" />

  UIControl은 Target-Action 메커니즘을 사용하여 사용자 상호 작용을 앱에 보고합니다. 
  
  우리가 흔히 쓰는  [addTarget(_:action:for:)](https://developer.apple.com/documentation/uikit/uicontrol/1618259-addtarget) 은 Target-Action 메커니즘이며 UIControl 과 앱의 상호작용을 연결합니다.

- ControlProperty와 달리 Observable의 역할은 수행하지만 Observer의 역할은 수행하지 못합니다.
- 에러 이벤트 전달하지 않구요, Completed 이벤트는 Control이 해제되기 직전에 전달합니다!
- 메인 스케쥴러에서 이벤트 전달합니다.

**기본 예제** : UIButton의 tap 이벤트가 클릭되었을 때 ViewModel의 controlTap 의 이벤트로 DataBinding 하는 과정입니다. (예시 같은 경우 MVVM 패턴의 ViewModel을 사용하고 있음)

```swift
controlEventButton.rx.tap
	.bind(to: viewModel.controlTap)
	.disposed(by: disposeBag)
```

- UIButton+Rx.swift

```swift
extension Reactive where Base: UIButton {
    
    /// Reactive wrapper for `TouchUpInside` control event.
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}
```

### 3. **⭐️ ⭐️ ⭐️  Driver**

사실 요거 사용하려고 여기까지 온거거든요...😩😩😩😩😩😩

RxCocoa가 제공하는 Traits 중에서 가장 핵심적인 것이라고 봐도 과언이 아닙니다.

Driver는 데이터를 UI에 바인딩하는 직관적이고 효율적인 방법을 제공합니다!

[몇 가지 특징]을 가지는데,

- 에러 이벤트를 전달하지 않아요 → 오류로 인해서 UI 처리가 중단되지 않겠죠?
- 항상 메인 스케쥴러에서 작업을 수행해요 → 이벤트는 항상 메인 스케쥴러에서 전달되고, 이어지는 작업도 메인 스케쥴러에서 처리합니다.

**예시 코드**

```swift
// subcribe -> bind -> drive (Driver)

viewModel.output.isLoading 
	.asDriver() // 드라이버 타입으로 만들어줘야 drive를 사용할 수 있음
	.drive(onNext: { [weak self] in 
		self?.indicatorView.isHidden = !$0 
	}) 
	.disposed(by: disposeBag)

viewModel.output.isLoading 
	.observeOn(MainScheduler.instance) 
	.subscribe(onNext: { [weak self] in 
		self?.indicatorView.isHidden = !$0 
	}) 
.disposed(by: disposeBag)

Observable.just("hello")
	.catchErrorJustReturn("") // error 처리 
	.observeOn(MainScheduler.instance) // 스케줄러 지정
	.subscribe(onNext: { str in
		textLabel.text = str
	})
	.disposed(by: disposeBag)
	
```

drive를 사용하려면 asDriver() 메서드를 통해서 옵저버블을 Driver 타입으로 만들어주어야 합니다!

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

또한, 사용하기 위해서는 Relay 형태여야 한다고 합니다. Subject를 wrapping한 것이 Relay라서 Subject 또한 asDriver를 가지고 있기는 하지만 Subject의 경우에는 에러를 전달하는 경우도 있기 때문에 에러가 없는 Driver 형태와 맞지 않습니다! 그렇기 때문에 Relay를 사용하는 것이 좋겠죠.

### 4. **Signal**

- Driver와 거의 동일한데, 한 가지 다른 점은 자원을 공유하지 않는다는거에요!
- share(replay:1) 사용하지 않아요..!
- 새로운 구독자에게 마지막 요소를 보내주지 않아요!
- Signal은 event모델링에 유용하고, Driver는 state모델링에 더 적합

시그널 같은 경우는 경우에 맞게 사용을 해봐야 이해가 될 것 같네요...

<br />

## 레퍼런스

[[RxSwift Book] Chapter 12: Beginning RxCocoa](https://jusung.github.io/RxSwift-Section12/)

[RxCocoa Binder? ControlEvent?](https://hucet.tistory.com/21)
