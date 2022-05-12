Config = {}

Config.Scription = {
  --scid,name,scription,nextScription,buttonNum(0없음, 1~N 있음)
  {"vehicle_rent_Greetings01","Ronald_Pools","안녕하세요.","vehicle_rent_Greetings02",1},
  {"vehicle_rent_Greetings02","Ronald_Pools","반갑습니다.","vehicle_rent_Greetings03",2},
  {"vehicle_rent_Greetings03","Ronald_Pools","대화를 종료 합니다.",'',0}
}

Config.SelectButton = {
  -- Btn Key Number , content ,next event name ,open nui? (''-> no, "name" -> on )
  {1,"네","vehicle_rent_Greetings02",''},
  {1,"그래요","vehicle_rent_Greetings02",''},
  {2,"저도요.","vehicle_rent_Greetings03",''},
  {2,"반가워요.","vehicle_rent_Greetings03",''},
  {2,"반가워요2.","vehicle_rent_Greetings03",''},
  {2,"반가워요3.","vehicle_rent_Greetings01",''},
}