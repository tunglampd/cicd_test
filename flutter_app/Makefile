.PHONY: test lint

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
	