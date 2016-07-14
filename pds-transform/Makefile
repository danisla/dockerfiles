lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
REPO=danisla/pds-transform
TAG=v1.3.0

all: build

build:
	docker build -t $(REPO):$(TAG) .

push:
	docker push $(REPO):$(TAG)

docs:
	docker run -d --name pds_transform_docs --entrypoint=darkhttpd -p 8080:8080 danisla/pds-transform:v1.3.0 /transform/doc --port 8080
	open http://localhost:8080

shell:
	docker run -it --rm --entrypoint=sh -v $(PWD):/host -w /host danisla/pds-transform:v1.3.0

%.xml: %.LBL
	docker run -it --rm --entrypoint=sh -v $(PWD):/host danisla/pds-transform:v1.3.0 -c "transform /host/$^ -f pds4-label -a -o $$(dirname /host/$^)"

%.csv: %.xml
	$(eval XML_OUT := $(basename $(dir $@)$(shell echo "$(notdir $@)" | tr [:upper:] [:lower:])).xml)
	docker run -it --rm --entrypoint=sh -v $(PWD):/host danisla/pds-transform:v1.3.0 -c "transform /host/$(XML_OUT) -f csv -a -o $(dir /host/$@)"
