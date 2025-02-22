package {{.pkg}}
{{if .withCache}}
import (
    . "github.com/xiao-linxin/x-gorm-zero/gormc/sql"
	"github.com/zeromicro/go-zero/core/stores/cache"
	"gorm.io/gorm"
	{{ if or (.gormCreatedAt) (.gormUpdatedAt) }} "time" {{ end }}
)
{{else}}
import (
    . "github.com/xiao-linxin/x-gorm-zero/gormc/sql"
	"gorm.io/gorm"
	{{ if or (.gormCreatedAt) (.gormUpdatedAt) }} "time" {{ end }}
)
{{end}}

// avoid unused err
var _ = InitField
var _ {{.upperStartCamelObject}}Model = (*custom{{.upperStartCamelObject}}Model)(nil)

type (
	// {{.upperStartCamelObject}}Model is an interface to be customized, add more methods here,
	// and implement the added methods in custom{{.upperStartCamelObject}}Model.
	{{.upperStartCamelObject}}Model interface {
		{{.lowerStartCamelObject}}Model
		custom{{.upperStartCamelObject}}LogicModel
	}

    custom{{.upperStartCamelObject}}LogicModel interface {
        WithSession(tx *gorm.DB) {{.upperStartCamelObject}}Model
    }

	custom{{.upperStartCamelObject}}Model struct {
		*default{{.upperStartCamelObject}}Model
	}

)

{{ if .withCache }}
func (c custom{{.upperStartCamelObject}}Model) WithSession(tx *gorm.DB) {{.upperStartCamelObject}}Model {
    newModel := *c.default{{.upperStartCamelObject}}Model
    c.default{{.upperStartCamelObject}}Model = &newModel
	c.CachedConn = c.CachedConn.WithSession(tx)
	return c
}
{{ else }}
func (c custom{{.upperStartCamelObject}}Model) WithSession(tx *gorm.DB) {{.upperStartCamelObject}}Model {
    newModel := *c.default{{.upperStartCamelObject}}Model
    c.default{{.upperStartCamelObject}}Model = &newModel
	c.conn = tx
	return c
}
{{ end }}

{{ if or (.gormCreatedAt) (.gormUpdatedAt) }}
// BeforeCreate hook create time
func (s *{{.upperStartCamelObject}}) BeforeCreate(tx *gorm.DB) error {
	now := time.Now()
	{{ if .gormCreatedAt }}s.CreatedAt = now{{ end }}
	{{ if .gormUpdatedAt}}s.UpdatedAt = now{{ end }}
	return nil
}
{{ end }}
{{ if .gormUpdatedAt}}
// BeforeUpdate hook update time
func (s *{{.upperStartCamelObject}}) BeforeUpdate(tx *gorm.DB) error {
	s.UpdatedAt = time.Now()
	return nil
}
{{ end }}
// New{{.upperStartCamelObject}}Model returns a model for the database table.
func New{{.upperStartCamelObject}}Model(conn *gorm.DB{{if .withCache}}, c cache.CacheConf, opts ...cache.Option{{end}}) {{.upperStartCamelObject}}Model {
	return &custom{{.upperStartCamelObject}}Model{
		default{{.upperStartCamelObject}}Model: new{{.upperStartCamelObject}}Model(conn{{if .withCache}}, c, opts...{{end}}),
	}
}

func (m *default{{.upperStartCamelObject}}Model) customCacheKeys(data *{{.upperStartCamelObject}}) []string {
    if data == nil {
        return []string{}
    }
	return []string{}
}
