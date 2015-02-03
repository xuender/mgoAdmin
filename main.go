package main
import (
  "./ma"
  "log"
  "github.com/go-martini/martini"
  "github.com/martini-contrib/render"
  "github.com/martini-contrib/sessions"
)

func main(){
  ma.LogDev()
  log.Println("start...")
  defer log.Println("close.")
  m := martini.Classic()
  m.Use(render.Renderer(render.Options{
    Layout: "layout",
    Delims: render.Delims{"{[{", "}]}"},
  }))
  store := sessions.NewCookieStore([]byte("mgoAdmin@xuender"))
  m.Use(sessions.Sessions("mgoAdmin", store))
	ma.Path(m, "/")
  m.NotFound(func(r render.Render) {
    r.HTML(404, "404", nil)
  })
  m.Run()
}
