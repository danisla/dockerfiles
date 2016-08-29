REPO := danisla/traefik
TAG := master-$(shell date +"%Y%m%d")

all: traefik
	docker build -t $(REPO):$(TAG) .

traefik-master:
	git clone https://github.com/containous/traefik.git $@

traefik: traefik-master
	cd $< && make binary && cp dist/traefik ../
