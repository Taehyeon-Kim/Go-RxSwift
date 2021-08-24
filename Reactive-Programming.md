# Reactive Programming

김성일님의 [리액티브 프로그래밍이란?](https://dev-daddy.tistory.com/25) 글을 메인으로 참고하고 있습니다.

이 글은 개인적인 학습과 공유를 목적으로 작성된 글입니다.  
참고한 레퍼런스는 글의 하단에 기재해놓았으며 원문을 그대로 가져다 쓴 내용도 있으니 참고해주시기 바랍니다.

<br />

## 들어가기전에

RxSwift를 공부하려고 하시나요? 그럼 반응형 프로그래밍이란 무엇인지, Rx가 무엇인지 알아보고 시작하도록 하죠.   
글을 읽고나면 왜 RxSwift가 비동기 처리를 위한 API인지 이해가 조금은 가실거라고 생각합니다.

이번 글에서는 `Rx`, `Reactive Programming` 다음 키워드의 의미가 무엇인지만 알게 된다면 성공입니다. 그럼 가보도록 하죠.

<br />

## Reactive Programming(반응형 프로그래밍)으로의 여행

> **[Reactive programming != Rx](https://zeddios.tistory.com/303)**

### Rx

💬  - Rx는 Reactive programming을 가능하게 해주는 API입니다.

💬  - 그렇다면 RxSwift는 Swift에서 Reactive programming을 가능하게 해주는 API, Extension입니다.

<br />

### Reactive programming

간단하게 요약하면 `패러다임(Paradigm)` 입니다.

더 자세하게 [위키피디아](https://en.wikipedia.org/wiki/Reactive_programming)에 설명이 나와있습니다.

> **리액티브 프로그래밍**은 데이터 흐름(data flows)과 변화 전파에 중점을 둔 프로그래밍 패러다임(programming paradigm)이다.
> 이것은 프로그래밍 언어로 정적 또는 동적인 데이터 흐름을 쉽게 표현할 수 있어야하며, 데이터 흐름을 통해 하부 실행 모델이 자동으로 변화를 전파할 수 있는 것을 의미한다.

```
🗣 뜻이 굉장히 이해하기 어렵죠..? 머리가 빠질 것 같지만 그냥 이런게 있구나 하고 다음으로 넘어갑시다.
```
```
🙋🏻‍♂️ 패러다임이 뭐죠??
```
```
🧑🏻‍💻 **'어떤(`~~~이런`) 방식·방법으로 프로그래밍 하자'** 이런 의미래요!
```

<br />

### Functional programming

Reactive programming(반응형 프로그래밍)이 Functional programming(함수형 프로그래밍)을 활용합니다.

<br />

### I want to know Rx, more easily

```
➡️ 사실 아직까지도 잘 와닿지 않습니다.
```
```
➡️ 그러니까 Reactive Programming이 어떤 패러다임인지도 알겠고,   
Rx라는 것이 Reactive Programming을 가능하게 해주는 API인 것도 알았는데   
포인트 좀 알려주세요...😥
```

<br />

**😁  조금 더 이해해보도록 합시다~!**

<br />

## 반응형 프로그래밍이 왜 필요할까?

```
🗣
우리는 사용자 경험을 향상시키고 싶어합니다. 이 말인 즉슨 반응형 앱을 만들고 싶어합니다.
메인스레드가 멈추거나 느려지지 않도록 해서, 사용자들에게 부드러운 사용자 경험과 좋은 성능을 제공하고 싶어합니다.

그러니까 메인스레드를 자유롭게 유지하려면 무겁고 시간이 오래 걸리는 작업은 백그라운드에서 해야 해요. 
이러한 작업들을 서버가 수행하기를 원하는데 그래서 우리는 네트워크 운영을 위한 '비동기 작업'이 필요합니다.
```

> 정리해보면 **사용자 경험**을 향상시키기 위해서 **비동기 작업**이 필요한데 
이 때 **리액티브 프로그래밍**이 필요한 것이죠.

```
🧑🏻‍💻 정리를 잠깐 해보면, 비동기 작업을 좀 더 잘하기 위해 리액티브 프로그래밍이 필요한 거구나!?
```

<br />

## 반응형 프로그래밍을 더 알아보자

위에서 살펴보았던 반응형 프로그래밍의 설명을 간단한 키워드로 바꾸면 다음과 같이 이야기 할 수 있습니다.

> **RX = OBSERVABLE + OBSERVERS + SCHEDULERS**

### Observable

```
🗣
우선적으로 Observable은 공급자라고 생각합시다.
데이터를 처리하고 다른 구성요소에 전달하는 역할을 합니다.
```

- Observable은 데이터 스트림입니다.
- Observable은 하나의 스레드에서 다른 스레드로 전달할 데이터를 압축합니다.
- 주기적으로 또는 설정에 따라 생애주기동안 한 번만 데이터를 방출합니다.

### Observers

```
🗣
Observable과 대응시켜서 생각해보면 Observers는 소비자(구독자)라고 볼 수 있겠네요.
전달받은 데이터를 가지고 다양한 작업을 수행할 수 있습니다.
```

- Observers는 Observable에 의해 방출된 데이터 스트림을 소비합니다.
- Observers는 subscribeOn()메서드를 사용해서 Observable을 구독하고 Observable이 방출하는 데이터를 수신할 수 있습니다.
- Observable이 데이터를 방출할 때마다 등록된 모든 Observer는 onNext() 콜백으로 데이터를 수신합니다.
- onNext()콜백에서 JSON 응답 파싱이나 UI 업데이트와 같은 다양한 작업을 수행할 수 있습니다.
- Observable에서 에러가 발생하면, Observer는 onError()에서 에러를 수신합니다.

### Schedulers

Rx는 비동기 프로그래밍을 위한 것이고, 우리는 스레드 관리가 필요하다는 것을 기억해야합니다.
```
🗣
Schedulers는 Observable과 Observers에게 그들이 실행되어야 할 스레드를 알려주는 Rx의 구성요소입니다.
```
- observeOn() 메서드로 observers에게 관찰해야 할 스레드를 알려줄 수 있습니다.
- scheduleOn() 메서드로 observable이 실행해야 할 스레드를 알려줄 수 있습니다.

<br />

## 앱에서 Rx를 사용하는 간단한 3단계

모든 Rx에서 공통적으로 기억해야할 것은 3가지입니다.
`observable` `observer` `Thread` 

사실 뒤에서 자세하게 살펴볼 것이기 때문에 이 부분에서는 이러한 것이 있다라고만 생각하고 넘어가면 좋을 것 같습니다. 3가지 특징만 가볍게 보고 넘어가도록 합시다.

![gmd](https://user-images.githubusercontent.com/61109660/130628929-1daf3af5-da66-4c65-ab63-4ff8083fc279.png)

General Marble Diagram

### Step 1 : 데이터를 방출하는 observable 생성:

- Observable은 데이터를 방출하는 역할을 합니다.
- 다양한 연산자와 함께 사용합니다.

### Step 2 : 데이터를 소비하는 observer 생성:

- Observable(옵저버블)이 방출한 데이터를 소비하는 Observer를 생성합니다.
- 내부에서 데이터와 에러를 처리합니다.

### Step 3 : 동시성 관리:

- 동시성을 관리하는 스케줄러를 정의합니다.
- 백그라운드 스레드에서 작업을 실행할 지, 메인 스레드에서 작업을 실행할 지 결정합니다.

<br />

## 마무리 시간

정리를 간단하게 해보도록 해요.
내용이 조금 길었지만 아래의 내용이 전부랍니다.

- Reactive Programming은 하나의 패러다임이다.
- Reactive Programming은 비동기 작업을 처리하기 위해 필요하다.
- Rx는 Reactive Programming을 가능하게 해주는 API, Extension이다.
- Rx는 Observable, Observers, Schedulers 3가지로 이해할 수 있다.
- Observable은 데이터를 방출하는 역할, Observers는 Observable을 구독하고 Observable이 방출한 데이터를 수신, 처리하며 에러를 처리한다. Scheduler는 작업을 어떤 스레드에서 처리할 지 결정한다.

### 한 줄 요약 ~~(두 줄..?! ㅎㅎ)~~

반응형 프로그래밍은 비동기 작업을 처리하기 위한 하나의 방식이구나...
Rx는 그 때 사용하는 도구이구나...

<br />

## 레퍼런스

[https://medium.com/@kevalpatel2106/what-is-reactive-programming-da37c1611382](https://medium.com/@kevalpatel2106/what-is-reactive-programming-da37c1611382)

[https://dev-daddy.tistory.com/25](https://dev-daddy.tistory.com/25)

[https://zeddios.tistory.com/303](https://zeddios.tistory.com/303)

[https://www.raywenderlich.com/books/rxswift-reactive-programming-with-swift/v4.0/chapters/1-hello-rxswift](https://www.raywenderlich.com/books/rxswift-reactive-programming-with-swift/v4.0/chapters/1-hello-rxswift)
