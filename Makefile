export GO_EXTLINK_ENABLED=0
export CGO_ENABLED=0

all: build

build:
	go clean; rm -rf pkg; go build --ldflags '-extldflags "-static"'

build_all: build_darwin build_amd64 build_power8 build_arm64 build_windows

build_darwin:
	go clean; rm -rf pkg k8s_info_darwin; GOOS=darwin go build --ldflags '-extldflags "-static"'
	mv k8s_info k8s_info_darwin

build_amd64:
	go clean; rm -rf pkg k8s_info_amd64; GOOS=linux go build --ldflags '-extldflags "-static"'
	mv k8s_info k8s_info_amd64

build_power8:
	go clean; rm -rf pkg k8s_info_power8; GOARCH=ppc64le GOOS=linux CGO_ENABLED=0 go build -o k8s_info ${flags}
	mv k8s_info k8s_info_power8

build_arm64:
	go clean; rm -rf pkg k8s_info_arm64; GOARCH=arm64 GOOS=linux CGO_ENABLED=0 go build -o k8s_info ${flags}
	mv k8s_info k8s_info_arm64

build_windows:
	go clean; rm -rf pkg k8s_info_windows; GOARCH=amd64 GOOS=windows CGO_ENABLED=0 go build -o k8s_info ${flags}
	mv k8s_info k8s_info_windows

install:
	go install

clean:
	go clean; rm -rf pkg

test : test1

test1:
	cd test; go test
