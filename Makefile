XC_WORKSPACE=Overcoat.xcworkspace
XCODE_PROJ=Overcoat.xcodeproj
OSX_SCHEME_XCTOOL_FLAGS:=-workspace $(XC_WORKSPACE) -scheme OvercoatTests-OSX -sdk macosx
IOS_SCHEME_XCTOOL_FLAGS:=-workspace $(XC_WORKSPACE) -scheme OvercoatTests-iOS -sdk iphonesimulator

test: install-pod clean build-tests run-tests

test-osx: install-pod clean build-tests-osx run-tests-osx

test-ios: install-pod clean build-tests-ios run-tests-ios

# Build Tests

clean:
	xcodebuild -project $(XCODE_PROJ) -alltargets clean

install-pod:
	COCOAPODS_DISABLE_DETERMINISTIC_UUIDS=YES pod install

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

build-tests: build-tests-osx build-tests-ios

run-tests: run-tests-osx run-tests-ios
