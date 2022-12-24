db:
	docker-compose up -d --build
dd:
	docker-compose down
du:
	docker-compose up -d
d-web:
	docker-compose exec regex_backend_web bash
d-firebase:
	docker-compose exec regex_backend_firebase bash
