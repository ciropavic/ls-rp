$(function () {

    var tyInts = '';

    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }
  
    display(false)


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
          console.log("btninit");
        //   console.log(  $("#1").text());
        var e = $("#1").attr("value");
        console.log(e);
        if( e != "" )
        {
            $("#1").show();
          $.post('https://ls-npcchatmanager/NextAlert', JSON.stringify({scid: e }));
        }
      });
      $("#2").click(function(){
        console.log("btninit");
      //   console.log(  $("#1").text());
      var e = $("#2").attr("value");
      console.log(e);
      if( e != "" )
      {
        $("#2").show();
        $.post('https://ls-npcchatmanager/NextAlert', JSON.stringify({scid: e }));
      }
    });
    $("#3").click(function(){
        console.log("btninit");
      //   console.log(  $("#1").text());
      var e = $("#3").attr("value");
      console.log(e);
      if( e != "" )
      {
          $("#3").show();
        $.post('https://ls-npcchatmanager/NextAlert', JSON.stringify({scid: e }));
      }
    });
    $("#4").click(function(){
        console.log("btninit");
      //   console.log(  $("#1").text());
      var e = $("#4").attr("value");
      console.log(e);
      if( e != "" )
      {
        $("#4").show();
        $.post('https://ls-npcchatmanager/NextAlert', JSON.stringify({scid: e }));
      }

    });
    }


  btnevent();

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)

            } else {
                display(false)
            }
        
        }

        if(event.data.action === 'scription')
        {
$("#1").hide();
$("#2").hide();
$("#3").hide();
$("#4").hide();
          $('#container').show();
          $(".name").text(event.data.name);
          $(".content-txt").text(event.data.content);
          write();
          nextText = event.data.nextscid;
        }
        if(event.data.action === 'buttonAdd')
        {
          $(`#${event.data.btnnumber}`).text(event.data.btncontent);
          $(`#${event.data.btnnumber}`).val(event.data.btnnextscid);
    $(`#${event.data.btnnumber}`).show();
          // $(".btn-list").apeend(`<button id ="">${event.data.btncontent}</button>`)
        }

    })
    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            console.log("to3e");
            $.post('https://ls-npcchatmanager/exit', JSON.stringify({}));
            return
            
        }
    };
    $("#next-btn").click(function () {
        $.post('https://ls-npcchatmanager/exit', JSON.stringify({}));
        return
    })
  
  })