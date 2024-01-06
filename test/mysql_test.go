package test

import (
	"fmt"
	"testing"

	"github.com/xiao-linxin/x-gorm-zero/gormc/config/mysql"
	"github.com/zeromicro/go-zero/core/conf"
)

type Conf struct {
	Mysql mysql.Mysql
}

func TestConnMysql(t *testing.T) {
	var c Conf

	conf.MustLoad("./myconf.yaml", &c)

	fmt.Printf("%+v\n", c)

	_, err := mysql.Connect(c.Mysql)
	if err != nil {
		t.Fatal(err)
	}
}
