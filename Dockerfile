# syntax=docker/dockerfile:experimental
# Let's get cutting edge.

FROM golang:1.13 as builder
ENV GOBIN=/go/bin
ENV CGO_ENABLED=0
ENV GOOS=linux

# The private dependency we use won't be listed in the Module registry.
ENV GOPRIVATE="github.com/russellrollins"

WORKDIR /go/src/github.com/russellrollins/circle-buildkit-ssh

# Configure our system to fetch from GitHub w/ SSH properly
RUN git config --system url."ssh://git@github.com/".insteadOf "https://github.com/"
RUN mkdir -p -m 0600 ~/.ssh \
    && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Improve build hit rate
COPY go.mod go.mod
COPY go.sum go.sum

# Download Go modules from public/private registry using forwarded SSH agent and SSH
# config mounted from the build command. These mounts are the magic here.
RUN --mount=type=ssh --mount=type=secret,id=ssh.config --mount=type=secret,id=ssh.key \
    GIT_SSH_COMMAND="ssh -o \"ControlMaster auto\" -F \"/run/secrets/ssh.config\"" \
    go mod download

COPY . ./
RUN go build -o doer

FROM alpine:3.9
RUN apk add --no-cache ca-certificates curl

# Grab the doer binary from the builder image
COPY --from=builder /go/src/github.com/russellrollins/circle-buildkit-ssh/doer .

CMD ["./doer"]
