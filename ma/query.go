package ma

import (
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
)

type Query struct {
  Db          string          `json:"db,omitempty"`
  Collection  string          `json:"collection,omitempty"`
	// start 1
  Page        int             `json:"page,omitempty"`
  // page size
	Limit       int             `json:"limit,omitempty"`
	Count       int             `json:"count,omitempty"`
	Sorting     []string        `json:"sorting,omitempty"`
	Filter      map[string]interface{}  `json:"filter,omitempty"`
  Results     []interface{}     `json:"results,omitempty"`
  Names       []string        `json:"names,omitempty"`
}

func readName(i interface{}) []string {
  ret := []string{"ca", "uid"}
  return ret
}
func (q *Query) Run(db *mgo.Database) error {
	m := bson.M{}
  qu := db.C(q.Collection).Find(m)
  count, err := qu.Count()
  if err != nil{
    return err
  }
  q.Count = count
	err = qu.Sort(q.Sort("_id")).Skip(q.Skip()).Limit(q.Limit).All(&q.Results)
  if len(q.Results) > 0 {
    q.Names = readName(q.Results[0])
  }
  return err
}
func (q *Query) Skip() int {
	return (q.Page - 1) * q.Limit
}
func (q *Query) Sort(def string) string {
	if len(q.Sorting) == 0 {
		return def
	}
	return q.Sorting[0]
}

//func (p *Query) query(i interface{}, sort string, list interface{},
//	m bson.M) (count int, err error) {
//	for k, v := range p.Filter {
//		switch v.(type) {
//		case string:
//			if v.(string) != "" {
//				m[k] = bson.RegEx{Pattern: v.(string), Options: "i"}
//			}
//		case int:
//			m[k] = v.(int)
//		case uint:
//			m[k] = v.(uint)
//		case float64:
//			m[k] = v.(float64)
//		case bool:
//			m[k] = v.(bool)
//		}
//	}
//	o, err := findObj(i)
//	if err != nil {
//		return
//	}
//	q := dbDB.C(o.Name).Find(m)
//	count, err = q.Count()
//	if err == nil && count > 0 {
//		err = q.Sort(p.Sort(sort)).Skip(p.Skip()).Limit(p.Limit()).All(list)
//	}
//	return
//}
//
//// 查找条件
//func (p *Query) QueryM(i interface{}, sort string, list interface{},
//	in map[string]interface{}) (int, error) {
//	m := bson.M{}
//	for k, v := range in {
//		m[k] = v
//	}
//	return p.query(i, sort, list, m)
//}
