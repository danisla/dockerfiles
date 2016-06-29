all: run
clean:
	-docker-compose kill
	-docker-compose down

run:
	docker-compose up -d desktop
	@while [[ ! `curl -sf http://localhost:6080` ]]; do sleep 5; done
	open http://localhost:6080
	read -p "Press ENTER after http://localhost:6080 loads in browser " IN
	docker-compose up -d wireshark
