all: ls
ls:
	docker image ls
build_gateway:
	docker build -t api-gateway ./api-gateway

build_auth:
	docker build -t auth-service ./auth-service

build_comment:
	docker build -t comment-service ./comment-service

build_notification:
	docker build -t notification-service ./notification-service

build_post:
	docker build -t post-service ./post-service

build_profile:
	docker build -t profile-service ./profile-service

build_all: build_gateway build_auth build_comment build_notification build_post build_profile 


rm_gateway:
	docker image rm api-gateway

rm_auth:
	docker image rm auth-service

rm_comment:
	docker image rm comment-service 

rm_notification:
	docker image rm notification-service

rm_post:
	docker image rm post-service

rm_profile:
	docker image rm profile-service