CODE_DIR ?= src
PARENT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)

FLUTTER_TARGET_VERSION = 3.10.5
PRODUCTION_TARGET = lib/main.dart
FLUTTER = fvm flutter

FLUTTER_CMD:= $(shell command -v flutter 2> /dev/null)
FVM := $(shell command -v fvm 2> /dev/null)
FVM_LIST := $(shell fvm list)

# -----------------------------Prerequisite verifications-----------------------------

all: ## Prerequisite checking: Flutter, Flutter Version Manager, target Flutter version.
	touch .env
ifndef FLUTTER_CMD
    $(error "Flutter is not available please install Flutter")
endif

ifndef FVM
	@echo fvm is not available. Activating Flutter Version Manager...
	flutter pub global activate fvm
	@echo fvm is now activated.
endif

ifneq (,$(findstring ${FLUTTER_TARGET_VERSION}, ${FVM_LIST}))
	@echo Flutter version ${FLUTTER_TARGET_VERSION} is available.
	fvm install ${FLUTTER_TARGET_VERSION}
	@echo Ready for building. Run [make help] for further information.
else
	@echo Flutter version ${FLUTTER_TARGET_VERSION} is not available. Installing...
	fvm install ${FLUTTER_TARGET_VERSION}
	@echo Ready for building. Run [make help] for further information.
endif

help: ## show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

# -----------------------------General Flutter commands-----------------------------
clean: all ## cleans the Flutter project
	${FLUTTER} clean

check_codestyle: all ## will make sure the project code style is according to Flutter standards
	${FLUTTER} analyze

check_format: check_codestyle ## will make sure the project code format is according to Flutter standards
	${FLUTTER} format --output=none --set-exit-if-changed .

run_tests: check_format ## performs a codestyle check followed by running the unit tests
	${FLUTTER} test

verify: check_format ## verifies if all tests pass and the codebase is in a good shape
	${FLUTTER} test

run_prod: ## runs the app on a connected device (iOS, Android, Simulator) pointing to prod environment
	${FLUTTER} run -t ${PRODUCTION_TARGET}

# -----------------------------Android build commands-----------------------------

build_android_apk_prod: run_tests ## builds an `apk` pointing to `prod` environment. Check README.md for more information.
	${FLUTTER} build apk -t ${PRODUCTION_TARGET} --release

build_android_apk_prod_debug: run_tests ## builds a `debug apk` pointing to `prod` environment. Check README.md for more information.
	${FLUTTER} build apk -t ${PRODUCTION_TARGET} --debug


build_android_bundle_prod: run_tests ## builds an application bundle, `aab`, pointing to `production` environment. Check README.md for more information.
	${FLUTTER} build appbundle -t ${PRODUCTION_TARGET}

# -----------------------------iOS build commands-----------------------------

build_ios_prod: run_tests ## builds an `ipa` pointing to `prod` environment. Check README.md for more information.
	${FLUTTER} build ipa -t ${PRODUCTION_TARGET}
	${FLUTTER} build ipa -t ${PRODUCTION_TARGET} --export-options-plist="build/ios/archive/Runner.xcarchive/Info.plist"
