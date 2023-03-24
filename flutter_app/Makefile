.PHONY: test

test:
	touch .env.android
	touch .env.ios
	flutter pub get
	flutter test --coverage --no-sound-null-safety -v