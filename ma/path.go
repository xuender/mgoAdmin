package ma
import (
  "github.com/go-martini/martini"
  "github.com/martini-contrib/render"
)

func Path(m *martini.ClassicMartini, p string) {
  m.Get(p, func(r render.Render) {
    r.HTML(200, "index", "")
  })
  m.Get("/database", DatabaseNames)
  m.Get("/collection", CollectionNames)
  m.Put("/use/:db", UseDb)
}

