# RxCocoa의 바인딩

## RxCocoa 좀 더 알아보기

이 글에서는 `bind`, `binding`에 대해서 살펴보도록 하겠습니다.

`binder` `driver` 에 대해서 이해했다면 사실상 오늘 목적은 거의 이룬거나 다름없음!!

<br />

## Subscribe

구독하는 대상(옵저버블)의 변함에 따라서 방출하는 Next 값과 Error 값, Complete 값 받아와서 처리할 수 있도록 도와주는 개념이었죠!

RxSwift에서는 구독자를 추가할 때 subscribe 메소드를 이용했는데, RxCocoa는 더 쉬운 방법을 제공합니다.

밑에서 살펴볼 바인딩(Binding)개념인데 subscribe 메서드 대신에 bind 메서드를 사용해서 구현해볼거에요.

<br />

## Binding

`하나의 연결 작업이라고 생각하면 좋을 듯 하네요~`

`데이터를 UI에 표시하기 위한 방-법` 

바인딩에는 데이터 생산자와 데이터 소비자가 있는데요! 
간단하게 데이터 주는 사람이랑 데이터 받는 사람이라고 생각하면 되겠죠?? 👀

이 때 데이터의 흐름은 Uni-directional 입니다. 
생산자 쪽에서 소비자 쪽으로 한쪽으로만 데이터가 전달됩니다.

👉 간단하게 정리해보죠!

- 데이터 생산자 : 옵저버블 (Observable) + 옵저버블타입 (Observable Type)을 채용한 모든 형식
- 데이터 소비자 : UIComponent (Label과 ImageView와 같은)

<br />

### Binder (Subscribe 확장판)

**바인더는 UI 바인딩에 사용되는 특별한 옵저버**입니다. 데이터 소비자의 역할을 하게 되는데요. **옵저버**이기 때문에 옵저버블이 바인더에게 데이터 전달은 가능한데(값을 주입할 수는 있으나), 바인더는 옵저버블이 아니라서 구독자를 추가하지는 못해요!!(값을 관찰하지는 못함)

여기서 잠깐‼️ 중요한 키 포인트

- **Binder는 Error 이벤트를 받지 않습니다.**
    - 옵저버블은 Next, Completed, Error 이벤트를 방출하는데 Error를 받지 않는다는거죠! 조금만 생각해보면 그 이유를 알 수 있는데요?!
    - 자, 일단 Error이벤트가 발생되면 옵저버블이 어떻게 되나요??
    - 옵저버블 시퀀스가 종료가 되어버리죠..!!
    - UI의 경우 바뀐 결과나 값에 따라서 계속해서 업데이트가 되어야 하는데 종료가 되어버리면 더 이상 Next 이벤트를 받지 못해서 업데이트가 불가능하죠??

    **→ 그래서 Error 이벤트는 No No!!**

    바인딩이 성공하면 UI가 업데이트 됩니다~~ 대박 🙈

- **UI** 관련 작업은 **Main Thread** 에서 처리를 하게 되죠?

    ~~(혹시나,,, 모르면,,, 진짜로 안 돼ㅐㅐ)~~ 아니 모를 수도 있죠🙂 어쨌든 그렇습니다. 
    UI 관련해서 업데이트하는 작업은 **메인 스레드에서 처리가 진행됩니다.**

    **→ Binder는 Binding이 메인 스레드에서 진행되는 것을 보장해줍니다.**

    cf) Subscribe 사용했을때와 비교해보기

    ```swift
    let bag = DisposeBag()

    // 문제가 되고 있는 코드
    // UI 관련 코드는 메인 스레드에서 실행되어야 한다고!!
    textField.rx.text 
    	.subscribe(onNext: { [weak self] str in 
    		self?.textLabel.text = str // #1 
    	}) 
    	.disposed(by: bag)

    // 해결책1. GCD 사용하기 (스레드 지정)
    textField.rx.text 
    	.subscribe(onNext: { [weak self] str in 
    		DispatchQueue.main.async { 
    			self?.textLabel.text = str 
    		} 
    	}) 
    	.disposed(by: bag)

    // 해결책2. rx의 observeOn 메서드 사용 (메인 스레드에서 동작하도록)
    textField.rx.text
    	.observeOn(MainScheduler.instance)
    	.subscribe(onNext: { [weak self] str in
    		self?.textLabel.text = str
    	})
    	.disposed(by: bad)
    ```

    근데 RxCocoa에서는 위의 2가지 방법을 이용하지 않아요.. 더 간단한 방법이 있습니다!!

    바로 bind 메서드를 사용해서 바인딩하는 방법..!

    ```swift
    // binder는 항상 메인 스레드에서 바인딩을 진행한다고 했었죠?
    // 위에서처럼 스레드 지정하는 고민을 할 필요가 없어요...
    // 그냥 bind씁시다!!
    textField.rx.text
    	.bind(to: textLabel.rx.text) // 파라미터로 ObserverType을 받고 있어요.
    	.disposed(by: bag)
    ```

<br />

**솔직히 여기까지 왔을 때 기억나는거..**

- RxCocoa가 뭐였더라...? (이전 글)
- **Binding,, Binder,, bind 메서드,, 메인 스레드..? (Good👍)**
    - 이것만 기억나도 성공! 사용법만 익혀둡시다~
