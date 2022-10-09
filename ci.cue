package main

import (
	"dagger.io/dagger"

	"github.com/shusann01116/jenkins-dind-dagger/jenkins"
)

dagger.#Plan & {
	client: {
		filesystem: {
			"./Jenkins/": read: contents: dagger.#FS
		}
		env: {
			DOCKERHUB_CRED_USR:  string
			DOCKERHUB_CRED_PSW: dagger.#Secret
		}
	}
	actions: {
		contents: client.filesystem."./Jenkins/".read.contents

		"jenkins": {
			agent: {
				tag:   "v0.1.0"
				build: jenkins.#Build & {
					"contents": contents
					dockerfile: "./agent/Dockerfile"
				}

				push: jenkins.#Push & {
					target:    "dagger-jenkins-agent"
					"tag":     tag
					image:     build.output
					AUTH_USR:  client.env.DOCKERHUB_USR
					AUTH_CRED: client.env.DOCKERHUB_CRED
				}
			}

			controller: {
				tag:   "v0.1.0"
				build: jenkins.#Build & {
					"contents": contents
					dockerfile: "./controller/Dockerfile"
				}

				push: jenkins.#Push & {
					target:    "dagger-jenkins-controller"
					"tag":     tag
					image:     build.output
					AUTH_USR:  client.env.DOCKERHUB_USR
					AUTH_CRED: client.env.DOCKERHUB_CRED
				}
			}
		}
	}
}
