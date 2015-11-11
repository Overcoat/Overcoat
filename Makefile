XC_WORKSPACE=Overcoat.xcworkspace
OSX_SCHEME_XCTOOL_FLAGS:=-workspace $(XC_WORKSPACE) -scheme Overcoat-OSX -sdk macosx
IOS_SCHEME_XCTOOL_FLAGS:=-workspace $(XC_WORKSPACE) -scheme Overcoat-iOS -sdk iphonesimulator

test: test-osx test-ios

# Build Tests

install-pod:
	COCOAPODS_DISABLE_DETERMINISTIC_UUIDS=YES pod install

clean-osx:
	xctool $(OSX_SCHEME_XCTOOL_FLAGS) clean

clean-ios:
	xctool $(IOS_SCHEME_XCTOOL_FLAGS) clean

build-tests-osx:
	xctool $(OSX_SCHEME_XCTOOL_FLAGS) build-tests

build-tests-ios:
	xctool $(IOS_SCHEME_XCTOOL_FLAGS) build-tests

# Run Tests

run-tests-osx:
	xctool $(OSX_SCHEME_XCTOOL_FLAGS) run-tests

run-tests-ios:
	xctool $(IOS_SCHEME_XCTOOL_FLAGS) run-tests -test-sdk iphonesimulator

# Intetfaces

test-osx: install-pod clean-osx build-tests-osx run-tests-osx

test-ios: install-pod clean-ios build-tests-ios run-tests-ios

clean: clean-osx clean-ios

build-tests: build-tests-osx build-tests-ios

run-tests: run-tests-osx run-tests-ios
