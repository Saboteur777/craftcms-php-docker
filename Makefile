release: release7.4 release8.1 release8.2
release7.4: build7.4 push7.4
release8.1: build8.1 push8.1
release8.2: build8.2 push8.2
build: build7.4 build8.1 build8.2
push: push7.4 push8.1 push8.2

build7.4:
	docker build -t webmenedzser/craftcms-php:7.4 ./7.4/
build8.1:
	docker build -t webmenedzser/craftcms-php:8.1 ./8.1/
build8.2:
	docker build -t webmenedzser/craftcms-php:8.2 ./8.2/
push7.4:
	docker push webmenedzser/craftcms-php:7.4
push8.1:
	docker push webmenedzser/craftcms-php:8.1
push8.2:
	docker push webmenedzser/craftcms-php:8.2
