package ma
import (
  "github.com/go-martini/martini"
  "github.com/martini-contrib/render"
	"github.com/martini-contrib/binding"
)

func Path(m *martini.ClassicMartini, p string) {
  m.Get(p, func(r render.Render) {
    r.HTML(200, "index", "")
  })
  m.Get("/database", DatabaseNames)
  m.Get("/collection/:db", CollectionNames)
  m.Post("/collection",binding.Bind(Query{}), CollectionQuery)
}

