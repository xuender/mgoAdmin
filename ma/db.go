package ma

import (
	"log"
	"gopkg.in/mgo.v2"
	"github.com/go-martini/martini"
  "github.com/martini-contrib/render"
)

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
func CollectionNames(params martini.Params, r render.Render) {
  ret := Msg{}
  ret.Ok = dbSession != nil
  if ret.Ok{
    dbDB = dbSession.DB(params["db"])
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
func CollectionQuery(query Query, r render.Render) {
  ret := Msg{}
  dbDB = dbSession.DB("family")
  err := query.Run(dbDB)
  ret.Ok = err == nil
  if ret.Ok{
    ret.Data = query
  }else{
    ret.Err = err.Error()
  }
  r.JSON(200, ret)
}

