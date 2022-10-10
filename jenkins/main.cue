package jenkins

import (
	"strings"
	"dagger.io/dagger"
	"dagger.io/dagger/core"

	"universe.dagger.io/docker"
)

#Build: {
	contents:   core.#FS
	dockerfile: *"Dockerfile" | string

	docker.#Build & {
		steps: [
			docker.#Dockerfile & {
				source: contents
				"dockerfile": path: dockerfile
			},
		]
	}
}

#Push: {
	target:    string
	tag:       string
	image:     docker.#Image
	AUTH_USR:  string
	AUTH_CRED: dagger.#Secret

	for k, v in ["latest", tag] {
		"tag-\(v)": docker.#Push & {
			dest: strings.Join([AUTH_USR, "/", target, ":", v], "")
			auth: {
				username: AUTH_USR
				secret:   AUTH_CRED
			}
			"image": image
		}
	}
}
