# iww_frontend

SW사관학교 정글 7기 나만의 무기 만들기 DoWith 프론트엔드


[내용 더 자세히 확인하기!](http://bit.ly/do_with)

<img
  src="https://github.com/tomoyo519/tomoyo519.github.io/assets/75294638/1a3ad8f1-cdf5-46be-847e-876cc2859b39"
  width="200"
  height="200"
/>


### INTRO

![KakaoTalk_20231211_142148447](https://github.com/tomoyo519/tomoyo519.github.io/assets/75294638/3d4e2a51-eb0c-46c1-8c6a-15b2f06a59e7)


### Do-With

by Team 얘외처리되죠(It works.. why?)

![%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7_2023-12-07_01 48_1](https://github.com/tomoyo519/tomoyo519.github.io/assets/75294638/1117a47d-3966-4410-9249-3d23f11a41e4)


### PROJECT

할일 관리, 나만의 펫과 더 재밌게 해봐요!

    갓생 살기위해 할일 앱으을 정리해본적이 있으신가요?
    하지만 동기가 부족해서, 알람을 무시하게 되서 등의 이유로 할일 관리 앱을 지속적으로 사용하기란 어렵습니다.
    동기부여를 위해 두윗은 크게 세 가지의 기능이 있습니다!

<aside>

1️⃣ 공통의 할일을 달성하는 그룹에 가입하여

사진으로 서로 할일을 확인해줄 수 있습니다.

</aside>

<aside>

2️⃣ 할일을 완료해서 받은 경험치로 펫이 진화를 할수도 있고, 일정 시간 할일을 완료하지 않으면 펫이 죽음에 이르를 수 있어 할일 완료에 대한 책임감을 줄 수 있습니다.

</aside>

<aside>

3️⃣ 할일을 완료해서 받은 캐시로 아이템을 구매해서

마이룸을 꾸밀 수 있고 다른 펫을 구매해서

육성할 수도 있습니다

</aside>


![c9d299aa-6aef-4762-8cba-a02a283cf596](https://github.com/tomoyo519/tomoyo519.github.io/assets/75294638/74bf2dd5-387f-4b26-bea3-4f91d3f79e8e)


### ARCHITECTURE


<img width="553" alt="%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-12-19_20 39 19" src="https://github.com/tomoyo519/tomoyo519.github.io/assets/75294638/abc3d61c-f01a-4041-8d5b-7e3b294c75cc">


### VIEWPOINT DESIGN


[피그마에서 확인하기!](https://www.figma.com/file/TbIxjCTQzHCiIh9fgxObid/Do-With?type=design&node-id=0-1&mode=design&t=CICQ1CpN22jOAKLX-0)



### TECHNICAL CHALLENGE



1️⃣ 3D 모델 렌더링 속도 개선

펫과 아이템을 배치할 수 있는 마이룸 에서 렌더링 속도를 개선

- MVVM 패턴을 사용하고 있었는데 동일한 클래스의 특정 변수만 주입받도록 변경
- 불필요한 리렌더링을 막아 렌더링 로딩 시간을 약 40% 단축시킴




2️⃣ 사진 렌더링 속도 개선


할일 확인을 받은 구성원들의 사진을 보여주어야 하는 기능에서 100장 을 렌더링 했을때  약 30초 소요되어 개선이 필요함을 인지함

- 이미지 업로드 용량을 제한함
- 사진을 압축해서 보관함
- 사진 렌더링 속도 6배 빨라짐



![Screenshot_20231215_010931_(1)](https://github.com/tomoyo519/tomoyo519.github.io/assets/75294638/8b5ca324-74a7-446e-b421-28adcd3163d0)

