package skills

import (
	"embed"
	"io/fs"
)

//go:embed findo/*
var embeddedSkills embed.FS

func EmbeddedSkills() (fs.FS, error) {
	return fs.Sub(embeddedSkills, ".")
}
