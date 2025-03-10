
// 웹 브라우저 콘솔에 id tiele을 갖는 태그 찾아서 출력
const title = document.querySelector("#title");
console.log(title);


// 링크 클릭 이벤트 연결하기
const link = document.querySelector("a");
// link.addEventListener("click", ()=> {
//     console.log("링크를 클릭했습니다");
// });

// 링크를 클릭해도 작동되지 않고 consol.log만 작동되도록 preventDefault()
link.addEventListener("click", (e)=>{
    e.preventDefault();
    console.log("링크를 클릭했습니다.");
});


// HTML 요소에 마우스 이벤트 연결
const box = document.querySelector("#box")
box.addEventListener("mouseenter", ()=>{
    box.style.backgroundColor = "hotpink";
});

box.addEventListener("mouseleave", ()=>{
    box.style.backgroundColor = 'aqua';
})


// 반복되는 요소에 이벤트 한꺼번에 연결
// 
const list = document.querySelectorAll(".list li");
for(let el of list){
    el.addEventListener("click", e => {
        e.preventDefault();
        const linkText = e.target.innerText;
        console.log(linkText);
    });
}


// 클릭 이벤트가 발생할 경우 숫자 증가/감소
const btnPlus = document.querySelector(".btnPlus");
const btnMinus = document.querySelector(".btnMinus");
let num = 0; // 제어할 숫자값을 0으로 초기화

// btnPlus를 클릭할 때
btnPlus.addEventListener("click", e=>{
    e.preventDefault();
    num++; // num값을 1씩 증가
    console.log(`num: ${num}`);
});

// btnMinus를 클릭할 때
btnMinus.addEventListener("click", e=>{
    e.preventDefault();
    num--; // num값을 1씩 감소
    console.log(`num: ${num}`);
});



// // 버튼을 클릭하면 좌우로 회전하는 박스 만들기
const btnLeft = document.querySelector(".btnLeft");
const btnRight = document.querySelector(".btnRight");
const box2 = document.querySelector("#box2");
const deg = 45; // 회전할 각도
let num2 = 0; // 증가시킬 값을 0으로 초기화

// btnLeft를 클릭할 때
btnLeft.addEventListener("click", e => {
    e.preventDefault();
    num2--;
    console.log(`num2: ${num2}`);
    // rotate(클릭 횟수 * deg)deg) = 돌아가는 각도 계산
    box2.style.transform = `rotate(${num2 * deg}deg)`;
});

// btnRight를 클릭할 때
btnRight.addEventListener("click", e => {
    e.preventDefault();
    num2++;
    console.log(`num2: ${num2}`);
    box2.style.transform = `rotate(${num2 * deg}deg)`;
});



// 브라우저 객체 모델
// JSP 언어 사양에 포함되지 않고 웹 브라우저에서 제공하는 객체(object : 포장지 혹은 묶음)
// 변수 : const, console 등
// document - form, cookie, links/anchors, images, ...

// window : 웹 브라우저 열릴 때마다 생성되는 최상위 관리 객체
// document : 웹 브라우저에 표시되는  html  문서 정보가 포함된 객체
// location : 웹 브라우저에 현재 표시된 페이지에 대한  URL 정보가 포함된 객체
// history : 웹 브라우저에 저장된 방문 기록이 포함된 객체
// navigator : 웹 브라우저 정보가 포함된 객체
// screen : 뤱 브라우저에 화면 정보가 포함된 객체
