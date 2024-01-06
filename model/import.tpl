import (
	"context"
	"fmt"
	"time"
	"database/sql"

	. "github.com/xiao-linxin/x-gorm-zero/gormc/sql"
	"github.com/xiao-linxin/x-gorm-zero/gormc"
	"github.com/zeromicro/go-zero/core/stores/cache"
	"gorm.io/gorm"
)

// avoid unused err
var _ = time.Second