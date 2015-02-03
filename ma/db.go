package ma

import (
	"log"
	"gopkg.in/mgo.v2"
	"github.com/go-martini/martini"
  "github.com/martini-contrib/render"
)

//const (
//  MGO = iota
//)
var dbSession *mgo.Session
var dbDB *mgo.Database

// 打开数据库
func DbOpen(ip, name string) (err error) {
	dbSession, err = mgo.Dial(ip)
	if err != nil {
		log.Fatal("数据库连接失败")
		panic("数据库连接失败")
	}
	dbSession.SetMode(mgo.Monotonic, true)
	dbDB = dbSession.DB(name)
  names, _ := dbDB.CollectionNames()
  log.Println(names)
	return
}

func init(){
  //TODO
  DbOpen("127.0.0.1", "test")
}
// 关闭数据库
func DbClose() {
	dbSession.Close()
}

func UseDb(params martini.Params, r render.Render){
  dbDB = dbSession.DB(params["db"])
  ret := Msg{}
  ret.Ok = true
  r.JSON(200, ret)
}
func DatabaseNames(r render.Render){
  ret := Msg{}
  ret.Ok = dbSession != nil
  if ret.Ok{
    names , err := dbSession.DatabaseNames()
    if err == nil{
      ret.Data = names
    }else{
      ret.Ok = false
      ret.Err = err.Error()
    }
  }else{
    ret.Err = "db is not connect"
  }
  r.JSON(200, ret)
}
func CollectionNames(r render.Render) {
  ret := Msg{}
  ret.Ok = dbDB != nil
  if ret.Ok{
    names , err := dbDB.CollectionNames()
    if err == nil{
      ret.Data = names
    }else{
      ret.Ok = false
      ret.Err = err.Error()
    }
  }else{
    ret.Err = "db is not connect"
  }
  r.JSON(200, ret)
}

