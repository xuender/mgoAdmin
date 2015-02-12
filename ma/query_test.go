package ma

import (
  "testing"
	"gopkg.in/mgo.v2/bson"
  . "github.com/smartystreets/goconvey/convey"
)
func TestQueryReadName(t *testing.T) {
  Convey("query read names", t, func() {
    m := bson.M{"_id":"1", "name":"test", "text":"123" }
    Convey("read", func(){
      s := readName(m)
      So(len(s), ShouldEqual, 3)
    })
  })
}

