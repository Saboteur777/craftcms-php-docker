release: release7.4 release8.1
release7.4: build7.4 push7.4
release8.1: build8.1 push8.1
build: build7.4 build8.1
push: push7.4 push8.1

build7.4:
	docker build -t webmenedzser/craftcms-php:7.4 ./7.4/
build8.1:
	docker build -t webmenedzser/craftcms-php:8.1 ./8.1/
push7.4:
	docker push webmenedzser/craftcms-php:7.4
push8.1:
	docker push webmenedzser/craftcms-php:8.1
