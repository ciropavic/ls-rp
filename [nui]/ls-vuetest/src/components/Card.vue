<template>

  <div class="mains">
    <button class="next-btn">《</button>
    <button class="prev-btn">》</button>
    <div class="container">
      <div class="contant-header">
        <img src='https://www.pinclipart.com/picdir/big/525-5258420_mechanical-engineering-logos-clip-art-png-5-.png' class ='picture'>
        <h1>LS Car Rental Service</h1>
        <nav>
          <ul>
            <li>Sedan</li>
            <li>Coupe</li>
            <li>SUV</li>
            <li>BIKE</li>
          </ul>
        </nav>
      </div>
      <div class="contant-body">
       <header>
          <h1>Car Rental</h1>
        </header>
        <div class="images">
          <img src='https://cdn.pixabay.com/photo/2017/08/18/08/31/flowers-2654192_960_720.png' class='picture'>
        </div>
        <div class="title">
          <h3>2013 Fore Mustang</h3>
          <span>Confadfsa</span>
        </div>
        <div class="price">
          <div class="texts">
            <span>Best Price</span>
            <h4>$125/DAY</h4>
          </div>
          <div class="btn">
            <button>Rent!</button>
          </div>
        </div>
      </div>
    </div>
      </div>
     
</template>

<script>
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
*{
  margin: 0px;
  padding: 0px;
  box-sizing: border-box;
}

.mains{
  display: flex;
  height: 100vh;
  justify-content: space-between;
  align-items: center;
  
}
.prev-btn{
  order:3;
}

.container{
  height: 100%;
  display: flex;
  flex-direction: column;
  row-gap: 100px;
  justify-content:center;
}
.contant-header{
  margin-left: -70px;
  margin-right: -100px;

  width: 500px;
  height: 100px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  

}
.contant-header ul{
  border-radius: 20px;
 background-image: linear-gradient(to right, #ff6e7f, #bfe9ff);
  margin-top : 30px;
  width: 350px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: space-around;
}
.contant-header li {
  list-style: none;
  font-size: 18px;
  font-weight: bold;
  color: white;
  background: rgb(2,0,36);
  width: 60px;
  height: 30px;
  text-align: center;
  border-radius: 10px;
 background-image: linear-gradient(to right, #fc5c7d, #6a82fb);
}
.contant-header img{
  display: flex;
  margin-left: 150px;
  height: 100%;
  width : 100%;
}
.contant-header .picture{
  max-width:100%; 
  max-height:100%; 
  width:auto; 
  height:auto;

}
.contant-header h1{
  background: #55ffaa;
  background: -webkit-linear-gradient(left, #5eb294, #210e78);
  background:    -moz-linear-gradient(right, #5eb294, #210e78);
  background:      -o-linear-gradient(right, #5eb294, #210e78);
  background:         linear-gradient(to right, #5eb294, #210e78);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  font-weight: bold;
  font-size:45px;
}

.contant-body{
  display: flex;
  flex-direction: column;
  width: 350px;
  height: 50%;
  background-color: bisque;
   box-shadow: 1px 3px 3px rgba(0,0,0,0.5);
}
header{
  width: 100%;
  height: 50px;
  background-color: #3498db;
  display: flex;
  align-items: center;
  padding: 0 5px;
}
header h1{
  color: white;
  text-shadow:1px 1px 1px #000;
}
.images{
  background-color: aliceblue;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 250px;
}
.images .picture{
  max-width:100%; 
  max-height:100%; 
  width:auto; 
  height:auto;

}
.title{
  background-color: aliceblue;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100px;
}
.title span{
  font-weight: 1000;
}
.price{
  display: flex;
  height: 135px;
  justify-content: space-between;
  align-items: center;
  background-color: #ecf0f1;
}
.texts{
  display: flex;
  flex-direction: column;
  padding: 0 1em;
}
.texts h4 {
  font-size: 1.5em;
}
.texts span{
  color: red;
  text-shadow:0.5px 0.5px 0.5px #000;
  font-weight: 1000;
  font-size : 95%;
}
button{
  width : 80px;
  height: 80px;
  border: none;
  outline: none;
  background-color: #95a5a6;
  color: white;
  font-size: 1.5em;
  text-shadow:1px 1px 1px #000;
}
</style>