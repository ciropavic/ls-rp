var typingBool = false; 
    var typingIdx=0; 
    var typingTxt=""
    var tyInt;
    typings("시작");
    function typings(args)
    {
     typingTxt = args; // 타이핑될 텍스트를 가져온다 
  
    typingTxt=typingTxt.split(""); // 한글자씩 자른다. 
    if(typingBool==false){ // 타이핑이 진행되지 않았다면 
       typingBool=true; 
       
        tyInt = setInterval(typing,85); // 반복동작 
     } 
}
     function typing(){ 
       if(typingIdx<typingTxt.length){ // 타이핑될 텍스트 길이만큼 반복 
         $("#typing").append(typingTxt[typingIdx]); // 한글자씩 이어준다. 
         typingIdx++; 
       } else{
        clearInterval(tyInt); //끝나면 반복종료 
        typings("헬로반갑습니다 ");
        } 
     }  