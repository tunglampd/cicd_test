.PHONY: test lint config

test:
	touch .env.android
	touch .env.ios
	flutter pub get
	flutter test --coverage --no-sound-null-safety -v

lint:
	touch .env.android
	touch .env.ios
	flutter pub get
	flutter analyze --write=linter-report.txt

config:
	cd scripts && pip install -r requirements.txt
	cd scripts && python config.py --env=$(ENV) \
		--google_application_credentials=$(GOOGLE_APPLICATION_CREDENTIALS) \
		--android_package_name=$(ANDROID_PACKAGE_NAME) \
		--ios_bundle_id=$(IOS_BUNDLE_ID)
