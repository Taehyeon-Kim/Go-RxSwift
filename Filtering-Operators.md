# 필터링 연산자 (Filtering Operators)

연산자(Operators)중 필터링 연산자(Filtering Operators)에 대해서 알아봅니다.

<br>

## 들어가기전에
```
자 RxSwift의 필터링 연산자에 대해서 알아보겠습니다~~~
여러분, 필터링이라는 단어를 보면 어떤 생각이 드시나요 👀
👉 '어떤 것을 거른다', '조건에 맞게 제한하고 싶다' 요런 느낌이 드시나요?

아직 느낌이 안 온다구요? 그럼 예시를 하나 들어보도록 하겠습니다.
우리가 검색을 할 때를 생각해보면 수많은 데이터 중에 내가 원하는 데이터만 얻기 위해서
검색어의 제한을 두거나, 스스로의 조건에 맞게 정보를 거르는 작업을 하죠??

필터링 연산자도 같습니다. 전달 받은 데이터, 스트림 등등에서 
원하는 데이터만 뽑아내고 싶을 때 사용하는 장치라고 생각하면 조금 나을 것 같은데요🤔

아직도 느낌이 안 오신다구요??? 괜찮습니다~!~!~! 지금 바로 알아보도록 할거니까요🥳
```

<br>

오늘은 아래 11가지 연산자에 대해서 알아볼거에요!

- [ ] ignoreElements
- [ ] elementAt
- [ ] filter
- [ ] skip
- [ ] skipWhile
- [ ] skipUntil
- [ ] take
- [ ] takeWhile
- [ ] takeUntil
- [ ] takeLast
- [ ] enumerated
- [ ] distinctUntilChanged

`takeLast`, `single`, `debounce`, `throttle` 요런 친구들도 있는데 얘네는 추가로 업데이트 해보겠습니다.  
우선은 위에 있는 친구들만 보아도 될 것 같아요🙂

<br>

## 필터링 연산자
연산자는 4가지 박자에 맞춰 정리해보겠습니다 ~~!!
1) 마블 다이어그램 (Marble Diagram)
   - 마블 다이어그램, Rx를 공부하면 마주쳐야만 하는 친구 / 이해가 안되면 이 표·그림을 보면 이해가 됩니다.
2) 간단한 설명
   - 설명 같은 경우는 제 의식의 흐름이나 다른 분의 설명을 참고해서 작성할거에요👍
3) 실행코드 
   - 솔직히 워낙 잘 만들어져있는 예시들이 많아서 대부분은 그대로 이용할 것 같고, 그렇지 않은 경우도...
4) 실행결과 ⭐️
   - **결과 같은 경우는 한 번 미리 예측해보고** 내가 생각한 내용이랑 같은지 생각해봅시다!!
   - **실제 코드는 프로젝트에 있으니 한 번 실행시켜보면서 코드 바꿔보기!!**

아이고,, 서론이 너무 길었다.. 바로 후다닥 가봅시다🙊

### 1. ignoreElements()
`다 무시해`, `종료 알림만 내보내`  
<img width="640" alt="ignoreElements c" src="https://user-images.githubusercontent.com/61109660/117568417-0f9a9180-b0fb-11eb-84a2-a320e73cc5ec.png">  

- **특징**
  - subscribe 하고 있는 라인에서 어떠한 데이터도 이벤트도 전달받지 못하고 무시된다.
  - .next이벤트를 무시한다.
  - 종료(.completed)나 에러(.error)와 같은 정지 이벤트만 허용된다.

- **간단요약**
  - 옵저버블에서 내보내는 항목에 대해서는 신경쓰지 않지만 **🐶 완료 될 때** 또는 **오류로 종료 될 때**의 알림을 받고 싶다면 사용 고고

- **실행코드**
  ```swift
  let strikes:[String] = ["X", "X", "X"]

  Observable.from(strikes)
      .ignoreElements()
      .subscribe(onNext: { _ in
      // print("(event) you're out!")
      }, onCompleted: {
      // print("(complete) you're out!")
      })
      .disposed(by: disposeBag)
  ```
- **실행결과**
  - onNext 이벤트와 onCompleted 이벤트에 있는 주석을 하나씩 풀고 생각해봅시다.
  ```
  1. onNext 이벤트의 프린트 문만 주석 풀었을 때
  // (... 아무 결과 없음...)
  
  2. onCompleted 이벤트의 프린트 문만 주석 풀었을 때
  // (complete) you're out!
  ```
  
 
### 2. element(at: index) 👈 elementAt()
`특정 녀석만 원해`, `너 나와😠`  
<img width="640" alt="ignoreElements c" src="https://user-images.githubusercontent.com/61109660/117568858-b5e79680-b0fd-11eb-8b21-9953e60b416f.png">  

- **특징**
  - 특정 요소만 처리하고 싶을 때 사용한다.
  - 정수 인덱스를 파라미터로 받아서 하나의 요소만을 방출한다.
  - 요소 하나를 방출하는 시점에 Completed 된다.(될거야...)

- **간단요약**
  - **하나**만 뽑아내고 싶을 때 사용!! 인덱스 여러 개는 못 써요~

- **실행코드**
  ```swift
  let strikes:[String] = ["1X", "2X", "3X"]

  Observable.from(strikes)
      .element(at: 1)
      .subscribe(onNext : { n in
          print("\(n) You're out!")
      })
      .disposed(by: disposeBag)
  ```
- **실행결과**
  - 다음 예시에서는 1번째 원소는 스트림에 값이 넘어가는 것을 확인할 수 있다.
  ```
  2X You're out!
  ```
  
### 3. filter()
`조건을 통과한 녀석들만..`, `숙제 다한 녀석들만(?!) 집에 갈 수 있다😱`  
<img width="640" alt="filter" src="https://user-images.githubusercontent.com/61109660/117569020-79686a80-b0fe-11eb-89c8-26fae237ffd1.png">  

- **특징**
  - filter 연산자는 클로저를 파라미터로 받는다. 클로저에서 True 판정을 받은 값만 다음 스트림으로 넘겨줄거야.
  - True 일 때만 값을 내려보내고, False 일 때는 값을 내려보내지 않는다.

- **간단요약**
  - 내가 원하는 조건을 작성해서 데이터를 걸러주면 되겠죠??
  - 제가 생각했을 때 이 녀석을 정말 많이 볼 것 같은 느낌이 드네요..ㅎㅎ

- **실행코드**
  ```swift
  Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
      // True일때만 값을 밑으로 내려보내고, False일때는 내려보내지 않는다.
      .filter{ $0 % 2 == 0 }
      .subscribe(onNext: { n in
          print(n)
      })
      .disposed(by: disposeBag)
  ```
- **실행결과**
  - 짝수만 걸러지는 것을 확인할 수 있습니다~
  ```
  2
  4
  6
  8
  10
  ```

### 4. skip()
`선착순 3명은 제외하고 나머지 1명은 벌칙을 줄거야😏`
<img width="640" alt="filter" src="https://user-images.githubusercontent.com/61109660/117569392-78d0d380-b100-11eb-8b08-d9889415082f.png">  

- **특징**
  - 옵저버블이 내보낸 처음 n개의 항목을 무시한다.

- **간단요약**
   - 원하는 n개의 요소를 skip하고 싶을 때 사용하는 오퍼레이터
   - 선착순 3명 제외하고, 나머지 1명은 벌칙을 줄거야

- **실행코드**
  ```swift
  Observable.from(["사람1", "사람2", "사람3", "사람4"])
      .skip(3)
      .subscribe(onNext: {
          print("\($0)는 벌칙준비해라")
      })
      .disposed(by: disposeBag)
  ```
- **실행결과**
  - 앞에 3개의 요소는 무시하겠죠? <s>벌칙이라니 무시무시하다...</s>
  ```
  사람4는 벌칙준비해라 
  ```
  
### 5. skip(while: _) 👈 skipWhile()
`filter와 유사한 친구 ~!`  
<img width="640" alt="filter" src="https://user-images.githubusercontent.com/61109660/117569557-38258a00-b101-11eb-8afe-ace319a3167f.png">

- **특징**
  - 지정된 조건이 거짓이 될 때까지 옵저버블에서 내보낸 항목을 버린다.
  - 검사를 통과하지 못한 요소 이후부터는 T/F 관계없이 전부 전달한다.
  
- **간단요약**
   - 조건이 False 나왔어? 아 그럼 이제부터는 항목을 방출할거야!
   - filter와 유사한데, filter와 반대로 검사를 통과하지 못한 요소부터 전달! 
   - (정반대 개념은 아니에여) 정반대 개념은 take랑 비교해봅시다~

- **실행코드**
  ```swift
  Observable.of(2,2,3,4,4)
      // 짝수인지 검사하고, 홀수가 나온 순간부터는 전부 전달
      .skip(while: { $0 % 2 == 0 })
      .subscribe(onNext: {
          print($0)
      })
      .disposed(by: disposeBag)
  ```
- **실행결과**
  ```
  3
  4
  4
  ```
 
### 6. skip(until: _) 👈 skipUntil()
`takeUntil과 비교해봅시다~` `trigger triger~`  
<img width="640" alt="filter" src="https://user-images.githubusercontent.com/61109660/117569742-22649480-b102-11eb-9320-0873563c8249.png">

- **특징**
  - skipUntil 연산자는 옵저버블 파라미터로 받는다. 다른 옵저버블을 파라미터로 받는다는 말씀!
  - 다른 옵저버블이 next event를 전달하기 전까지 원본 옵저버블이 전달하는 이벤트를 전부 무시한다.

  
- **간단요약**
  - 다른 옵저버블이 전달하는 next event를 유심히 보고 있자.
  - 전달받기 전까지는 어떠한 항목도 내보낼 수 없어..!

- **실행코드**
  - 다른 옵저버블 파라미터로 받으려고 2개 생성하는거 보이시죠??
  ```swift
  // 옵저버블 2개 생성
  let subject = PublishSubject<String>()
  let trigger = PublishSubject<String>()

  subject
      .skip(until: trigger)
      .subscribe(onNext: {
          print($0)
      })
      .disposed(by: disposeBag)

  // 여기까지는 다 무시되겠져?
  subject.onNext("A")
  subject.onNext("B")

  // skip 종료!
  // 왜냐면 다른 옵저버블이 요소를 emit(방출)했기 때문!
  trigger.onNext("X")

  subject.onNext("C")
  ```
- **실행결과**
  ```
  C
  ```

### 7. take()
`skip과 반대로 생각하자` `이제부터는 이해 속도가 UP`  
<img width="640" alt="filter" src="https://user-images.githubusercontent.com/61109660/117569950-03b2cd80-b103-11eb-9334-36a925e6f9bc.png">

- **특징**
  - 처음 n개의 항목만 방출한다.
  - 나머지 항목은 무시한다.

  
- **간단요약**
  - 앞에 원하는 요소 n개만 방출하고 싶을때!
  - 앞에 몇 명 나와라~

- **실행코드**
  ```swift
  Observable.from(["은영", "지원", "태현", "혜령"])
      .take(2)
      .subscribe(onNext: {
          print("\($0) ✋")
      })
      .disposed(by: disposeBag)
  ```
- **실행결과**
  - 이름 빌려주셔서 감사합니다🙇🏻‍♂️ (원하시면 익명처리할게요!)
  ```
  은영 ✋
  지원 ✋
  ```
  
### 7. take(while: _) 👈 takeWhile() 
<img width="640" alt="filter" src="https://user-images.githubusercontent.com/61109660/117569950-03b2cd80-b103-11eb-9334-36a925e6f9bc.png">

- **특징**
  - 처음 n개의 항목만 방출한다.
  - 나머지 항목은 무시한다.

  
- **간단요약**
  - 앞에 원하는 요소 n개만 방출하고 싶을때!
  - 앞에 몇 명 나와라~

- **실행코드**
  ```swift
  Observable.from(["은영", "지원", "태현", "혜령"])
      .take(2)
      .subscribe(onNext: {
          print("\($0) ✋")
      })
      .disposed(by: disposeBag)
  ```
- **실행결과**
  - 이름 빌려주셔서 감사합니다🙇🏻‍♂️ (원하시면 익명처리할게요!)
  ```
  은영 ✋
  지원 ✋
  ```

### 8. take(until: _) 👈 takeUntil() 
<img width="640" alt="filter" src="https://user-images.githubusercontent.com/61109660/117570327-999b2800-b104-11eb-858f-d2bc579ac8f1.png">

- **특징**
  - takeUntil도 skipUntil 연산자처럼 옵저버블 파라미터로 받는다. 다른 옵저버블을 파라미터로 받는다는 말씀22
  - 다른 옵저버블이 next event를 전달하기 전까지 원본 옵저버블이 전달하는 이벤트를 수행(방출)하고
  - 이벤트 받는 순간부터 방출을 멈춘다. 무시한다!!!
  
- **간단요약**
  - 다른 옵저버블이 야! 나 이벤트 방출할거야!! 너 하던거 멈춰 이느낌~~!!

- **실행코드**
  ```swift
  // 옵저버블 2개 생성
  let subject = PublishSubject<String>()
  let trigger = PublishSubject<String>()

  subject
      .take(until: trigger)
      .subscribe(onNext: {
          print($0)
      })
      .disposed(by: disposeBag)

  // 여기까지는 다 출력되겠죠!>!
  subject.onNext("A")
  subject.onNext("B")
  subject.onNext("B")
  subject.onNext("C")

  // take 종료!
  // 왜냐면 다른 옵저버블이 요소를 emit(방출)했기 때문!
  trigger.onNext("X")

  subject.onNext("C")
  ```
- **실행결과**
  ```
  A
  B
  B
  C
  ```

### 10. enumerated()
`엥.. 공식홈페이지에 없어..?`  
요 친구는 마블 다이어그램이 없습니다!! 왜냐구요! 그냥 인덱스를 함께 알고 싶을 때 사용하는 간단한 친구거든요!!!! <s>(화낸거아님)</s>

- **특징**
  - 방출된 요소의 값과 함께 인덱스도 알고 싶을 때 사용한다.
  - 기존 Swift의 enumerated 메소드와 유사하게, Observable에서 나오는 각 요소의 index와 값을 포함하는 튜플을 생성하게 된다.
  
- **간단요약**
  - 사실 파이썬을 했다면 익숙한 친구! 하지만 그렇지 않을 수 있으니..
  - [a,b,c,d,e]의 배열이 있을 때 요소의 값 뿐만 아니라 인덱스도 같이 참조하고 싶을 때!!
  - 알고리즘 문제 풀 때는 그런 경우가 보이는데,, 실제 코드에서는 어떻게 쓰일 수 있을지 궁금하긴 한다..!

- **실행코드**
  - 중요한 것은 값을 알고 싶을 때는 .element (.value 아니에여)
  - 인덱스를 알고 싶을 때는 .index
  ```swift
  Observable.of(2,2,4,4,6,6)
      .enumerated()
      .take(while: { index, value in
          value % 2 == 0 && index < 3
      })
      .map { $0.index }
      .subscribe(onNext: {
          print($0)
      })
      .disposed(by: disposeBag)
  ```
- **실행결과**
  - 오,, take(while: _)이랑 같이 쓰이고 있어요
  - 짝수이면서, 인덱스가 3 미만인 녀석들까지! 출력
  ```
  0
  1
  2
  ```
  
### 11. distinctUntilChanged()
`중복을 막겠다~` `아.. 얘는 마블다이어그램 있다ㅎㅎ`  
<img width="330" alt="filter" src="https://user-images.githubusercontent.com/61109660/117570667-1975c200-b106-11eb-8a2a-c57196aebce9.png">
<img width="330" alt="filter" src="https://user-images.githubusercontent.com/61109660/117570680-301c1900-b106-11eb-9f8d-cffd86118f5e.png">  

사실 얘는 오른쪽 그림이 이해하기 더 좋아서 다른 곳에서 가져왔습니다.  
[그림 출처](https://github.com/fimuxd/RxSwift/blob/master/Lectures/05_Filtering%20Operators/Ch5.%20FilteringOperators.md)는 클릭해주세요!

- **특징**
  - 동일한 항목이 연속적으로 방출되지 않도록 필터링해주는 연산자
  - 연달아 이어지는, 중복되는 값을 막아주는 역할을 한다.
  - 파라미터가 없다!
  
- **간단요약**
  - 자동으로 중복제거도 해주고 좋은 친구죠?
  - [a,b,c,d,e]의 배열이 있을 때 요소의 값 뿐만 아니라 인덱스도 같이 참조하고 싶을 때!!
  - 알고리즘 문제 풀 때는 그런 경우가 보이는데,, 실제 코드에서는 어떻게 쓰일 수 있을지 궁금하긴 한다..!

- **실행코드**
  ```swift
  Observable.of("A", "A", "B", "B", "C", "C", "A")
      // 중복제거
      .distinctUntilChanged()
      .subscribe(onNext: {
          print($0)
      })
      .disposed(by: disposeBag)
  ```
- **실행결과**
  - 앞에 있는 A랑 뒤에 있는 A랑은 별개
  - 단순히 연속되는 요소들만 필터링해준다.
  ```
  A
  B
  C
  A
  ```
