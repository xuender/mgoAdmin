package ma

import (
  "os"
  "log"
)

func LogFile(file string) {
  log.SetFlags(log.Lshortfile | log.LstdFlags)
  f, _ := os.OpenFile(file, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
  log.SetOutput(f)
}

func LogDev() {
  log.SetFlags(log.Lshortfile | log.LstdFlags)
}

