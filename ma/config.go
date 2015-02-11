package ma

import (
  "io/ioutil"
  "gopkg.in/yaml.v2"
)

type User struct {
  Name        string
  Password    string
}

type Config struct {
  Address     string
  Users       []User
  White       []string
}

func (c *Config) Load(configFilePath string) error{
  contents, err := ioutil.ReadFile(configFilePath)
  if err == nil{
    yaml.Unmarshal(contents, c)
  }
  return err
}

func (c *Config) Save(configFilePath string) error{
  buf, err := yaml.Marshal(c)
  if err != nil {
    return err
  }
  return ioutil.WriteFile(configFilePath, buf, 0600)
}

const configName = "ma_config.yml"

func ConfigLoad() (config Config){
  err := config.Load(configName)
  if err != nil{
    config.Address = "127.0.0.1"
    config.White = []string{"127.0.0.1"}
    config.Save(configName)
  }
  return
}

