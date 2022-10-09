package main

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"

	"universe.dagger.io/docker"
)

dagger.#Plan & {
	client: {
		filesystem: {
			"./agent/": read: contents:  dagger.#FS
			".registry": read: contents: dagger.#Secret
		}
	}
	actions: {
		contents: client.filesystem."./agent/".read.contents

		agent: {
			tag:      "0.1.0"
			registry: core.#TrimSecret & {
				input: client.filesystem.".registry".read.contents
			}
			build: docker.#Build & {
				steps: [
					docker.#Dockerfile & {
						source: contents
					},
				]
			}
			push: docker.#Push & {
				image: build.output
				dest:  "shusann01116/jenkins-agent-dagger:\(tag)"
				auth: {
					username: "shusann01116"
					secret:   registry.output
				}
			}
		}
	}
}
