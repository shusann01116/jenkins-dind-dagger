package main

import (
	"dagger.io/dagger"

	"universe.dagger.io/docker"
)

dagger.#Plan & {
	client: {
		filesystem: {
			"./Jenkins/agent/": read: contents: dagger.#FS
		}
		env: {
			DOCKERHUB_USR:  string
			DOCKERHUB_CRED: dagger.#Secret
		}
	}
	actions: {
		contents: client.filesystem."./Jenkins/agent/".read.contents

		agent: {
			tag:   "v0.1.0"
			build: docker.#Build & {
				steps: [
					docker.#Dockerfile & {
						source: contents
					},
				]
			}
			push: docker.#Push & {
				image: build.output
				dest:  "\(client.env.DOCKERHUB_USR)/jenkins-agent-dagger:\(tag)"
				auth: {
					username: client.env.DOCKERHUB_USR
					secret:   client.env.DOCKERHUB_CRED
				}
			}
		}
	}
}
