package ma

import (
	"log"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"github.com/go-martini/martini"
  "github.com/martini-contrib/render"
)

var dbSession *mgo.Session

func DbOpen(ip string) (err error) {
	dbSession, err = mgo.Dial(ip)
	if err != nil {
		log.Fatal("Database connection failed.")
		panic("Database connection failed.")
	}
	dbSession.SetMode(mgo.Monotonic, true)
	return
}

func init(){
  config := ConfigLoad()
  DbOpen(config.Address)
}

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
    dbDB := dbSession.DB(params["db"])
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

func CollectionQuery(params martini.Params, query Query, r render.Render) {
  ret := Msg{}
  dbDB := dbSession.DB(params["db"])
  err := query.Run(dbDB)
  ret.Ok = err == nil
  if ret.Ok{
    ret.Data = query
  }else{
    ret.Err = err.Error()
  }
  r.JSON(200, ret)
}

func CollectionUpdate(params martini.Params, msg Msg, r render.Render) {
  log.Println(msg)
  dbDB := dbSession.DB(params["db"])
  c := dbDB.C(params["collection"])
  data := msg.Data.(map[string]interface{})
  id := bson.ObjectIdHex(data["_id"].(string))
  delete(data,"_id")
  log.Println(id)
  err := c.UpdateId(id, data)
  log.Println(err)
  msg.Ok = err == nil
  if !msg.Ok{
    msg.Err = err.Error()
  }
  msg.Data = nil
  r.JSON(200, msg)
}

