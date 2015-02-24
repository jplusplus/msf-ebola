run:
	gulp serve

build:
	gulp

install:
	npm install
	./node_modules/.bin/bower install
	gulp wiredep

deploy:
	gulp deploy

full_deploy: crowdin_download
	git commit ./locale -m "Updated locale" || true
	git pull --rebase
	gulp deploy

zip: build
	(cd dist; zip -r ../msf-ebola.zip .)

crowdin_upload:
	crowdin-cli upload sources

crowdin_download:
	crowdin-cli download
