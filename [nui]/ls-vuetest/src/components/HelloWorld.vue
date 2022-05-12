<template>
  <div>
      <div id = "card">
          <div id = "header">
            <p> Car Rental</p>
          </div>
        <div id="img">
            <img src='https://cdn.pixabay.com/photo/2017/08/18/08/31/flowers-2654192_960_720.png' id='picture'>
        </div>
        <div id ="info">
          2013 Ford Mustang
          <br>
          description
        </div>
    </div>
    
  </div>
</template>

<script>
// export default {
//   names: 'hello-world',
//   value: 'hello-world',
//   props: {
//     name: {
//       type: String,
//       required: true,
//     },
//   },
// };
export default{
  data(){
    return {
      value: "테스트입니다."
    }
  },
  methods:{

  }
}

</script>

<style scoped>
/* *{
  box-sizing: border-box;
} */
#card{
  width:300px;
  height: 500px;
  text-align: center;
  background-color: gray ;

}
#header {
  width : 100%;
  height: 65px;
  background-color: #39A4D8

}
#header p{
  font-size: 20px;
  font-weight: 1000;
    text-align: left;
  color: white;
  text-shadow:1px 1px 1px #000;
   /* border: 1px solid blue;*/
  position: relative;
   top : 50%; 
   margin-left: 10px;
   transform:translateY(-70%);
}
#img {
  background-color: white;
  width: 100%;
  height: 200px;
}
#picture{
  max-width:100%; 
  max-height:100%; 
  width:auto; 
  height:auto;
}
#info{
  width: 100%;
  height: 80px;
  background: ghostwhite;
  font-size: 18px;
  font-weight: 1000;
}

</style>
