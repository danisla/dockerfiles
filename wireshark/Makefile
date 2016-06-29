APP_NAME=app

all: run
clean:
	-docker-compose kill
	-docker-compose down

run:
	APP_NAME=$(APP_NAME) docker-compose up -d desktop
	@while [[ ! `curl -sf http://localhost:6080` ]]; do sleep 5; done
	open http://localhost:6080
	read -p "Press ENTER after http://localhost:6080 loads in browser " IN
	APP_NAME=$(APP_NAME) docker-compose up -d wireshark
