
REPO := danisla/seaweedfs
TAG := v0.70

SEAWEEDFS_URL := https://github.com/chrislusf/seaweedfs/releases/download/v0.70/go_0.70_linux_amd64.tar.gz
ARCHIVE := $(notdir $(SEAWEEDFS_URL))
BIN := weed

all: image

$(ARCHIVE):
	curl -L $(SEAWEEDFS_URL) > $@

$(BIN): $(ARCHIVE)
	tar zxvf $< --strip-components=1

image: $(BIN)
	docker build -t $(REPO):$(TAG) .

push:
	docker push $(REPO):$(TAG)

test:
	docker run -it --rm $(REPO):$(TAG)
