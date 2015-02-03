package ma

type Msg struct {
	Ok bool `json:"ok"`
	Err string `json:"err,omitempty"`
	Data interface{} `json:"data,omitempty"`
}

