package ma

import (
  "testing"
  . "github.com/smartystreets/goconvey/convey"
)

func TestConfig(t *testing.T) {
  Convey("Config Load file", t, func() {
    config := Config{}
    err := config.Load("config_test.yml")
    Convey("err", func(){
      So(err, ShouldBeNil)
    })
    Convey("address", func(){
      So(config.Address, ShouldEqual, "127.0.0.1")
    })
    Convey("white", func(){
      So(len(config.White), ShouldEqual, 2)
      So(config.White[0], ShouldEqual, "127.0.0.1")
    })
    Convey("users", func(){
      So(len(config.Users), ShouldEqual, 2)
      So(config.Users[0].Name, ShouldEqual, "root")
      So(config.Users[1].Name, ShouldEqual, "admin")
    })
  })
  Convey("Config Load err file", t, func() {
    config := Config{}
    err := config.Load("config_test1.yml")
    Convey("err", func(){
      So(err, ShouldNotBeNil)
    })
  })
  Convey("Config Save file", t, func() {
    config := Config{
      Address: "127.0.0.1",
      Users: []User{
        User{
          Name: "root",
          Password: "321",
        },
        User{
          Name: "admin",
          Password: "123",
        },
      },
      White: []string{"127.0.0.1", "192.168.1.1"},
    }
    err := config.Save("config_test.yml")
    Convey("err", func(){
      So(err, ShouldBeNil)
    })
  })
}

