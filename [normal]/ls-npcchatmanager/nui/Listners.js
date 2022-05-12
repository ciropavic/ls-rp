$(function(){
  window.onload = function(e) {
      window.addEventListener("message",(event)=>{
          var item = event.data;
          if(item !== undefined && item.type === "ui"){
              if(item.display === true){
                  $('#container').show();
              }else{
                  $('#container').hide();
              }
          }
      })
  }
      function display(bool) {
          if (bool) {
              $("#container").show();
          } else {
              $("#container").hide();
          }
      }
  
      display(false)
  
})



$(document).keydown(function(event) {
  if ( event.keyCode == 27 || event.which == 27 ) {
      $.post('http://ls-npcchatmanager/exit', JSON.stringify({}));
          return
  }
});