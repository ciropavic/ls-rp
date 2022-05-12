$(function () {
  window.onload = function(onl) {
  //#region typing
  
  function typeinit()
  {
    // 타이핑될 텍스트를 가져온다 
    var typingTxt = $(".content-txt").text(); 

    typingTxt=typingTxt.split(""); // 한글자씩 자른다. 
    
    if(typingBool==false){ 
      
      // 타이핑이 진행되지 않았다면 
       typingBool=true;   
       tyInts = setInterval(function(){
        typing(typingTxt,this);
       },60); // 반복동작 
    } 
  }
  
 
       
  function typing(typingTxt,tyInt){ 
    if(typingIdx<typingTxt.length){ 
      // 타이핑될 텍스트 길이만큼 반복 
      $(".content").append(typingTxt[typingIdx]);
      // 한글자씩 이어준다. 
      typingIdx++; 
     } else{ 
       //끝나면 반복종료 
      clearInterval(tyInt); 
     } 
  }  


  function write()
  {
    $(".content").text("");
    console.log(  $(".content-txt").text());
    clearInterval(tyInts); 
    var typingTxt = $(".content-txt").text(); 
    typingTxt=typingTxt.split(""); // 한글자씩 자른다. 

    typingIdx = 0;
    typingBool = false;
    typeinit();
  }
//#endregion
  var nextText = '';

  function btnevent()
  {
    $("#1").click(function(){
      var e = $("#1").attr("value");
      if( e != "" )
      {
        $.post('https://ls-npcchatmanager/NextAlert', JSON.stringify({scid: e }));
      }
    });
  }
  window.addEventListener('message',(event)=> {

    if(event.data.action === 'open')
    {
      $('#container').show();
    }
    if(event.data.action === 'close')
    {
      $('#container').hide();
    }
    
    if(event.data.action === 'scription')
    {
      $('#container').show();
      $(".name").text(event.data.name);
      $(".content-txt").text(event.data.content);
      write();
      nextText = event.data.nextscid;
    }
    if(event.data.action === 'buttonAdd')
    {
      $(`#${event.data.btnnumber}`).text($event.data.btncontent);
      $(`#${event.data.btnnumber}`).val($event.data.btnnextscid);

      // $(".btn-list").apeend(`<button id ="">${event.data.btncontent}</button>`)
    }

  })
}
})