
// 모든 article 요소들을 변수 item에 저장
const items = document.querySelectorAll("article");
// console.log(items); : 변수를 불러오고 불러와졌는지 확인하기

const aside = document.querySelector("aside");
// console.log("aside");

const close = aside.querySelector("span");
// console.log("span");

// items를 반복문으로 돌리기
for(let el of items) {
    // 현재 반복이 돌고 있는 article요소에 mouseenter 이벤트 발생시
    el.addEventListener("mouseenter", e => {
        // 자식인 video 요소 재생
        e.currentTarget.querySelector("video").play();
    });

    // 현재 반복이 돌고 있는 article 요소에 mouseleve 이벤트 발생시
    el.addEventListener("mouseleave", e => {
        // 자식인 video 요소 일시정지
        e.currentTarget.querySelector("video").pause();
    });

    // article 요소에 click 발생시
    el.addEventListener("click", e => {
        // 제목과 본문의 내용 그리고 video 요소의 src값을 변수에 저장
        let tit = e.currentTarget.querySelector("h2").innerText;
        let txt = e.currentTarget.querySelector("p").innerText;
        let vidSrc = e.currentTarget.querySelector("video").getAttribute("src");
        console.log(`title: ${tit}, p의 내용: ${txt}, video의 경로: ${vidSrc}`);

        // aside 요소 안쪽의 콘텐츠에 위의 변수 내용을 적용
        aside.querySelector("h1").innerText = tit;
        aside.querySelector("p").innerText = txt;
        aside.querySelector("video").setAttribute("src", vidSrc);
        
        //  aside 요소 안쪽의 동영상ㅇ르 재생하고 aside 요소에 class=on을 붙여 팝업 패널 활성화
        aside.querySelector("video").play();
        aside.classList.add("on");
    });


    // close 버튼 클릭 시
    close.addEventListener("click", () => {
        //  aside 요소에 클래스 on을 제거해 비활성화하고 안쪽의 영상을 일시정지
        aside.classList.remove("on");
        aside.querySelector("video").pause();
    });

    
}

