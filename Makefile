XC_WORKSPACE=Overcoat.xcworkspace
XCODE_PROJ=Overcoat.xcodeproj

OSX_SCHEME_XCTOOL_FLAGS:=-workspace $(XC_WORKSPACE) -scheme OvercoatTests-OSX -sdk macosx
IOS_SCHEME_XCTOOL_FLAGS:=-workspace $(XC_WORKSPACE) -scheme OvercoatTests-iOS -sdk iphonesimulator
TVOS_SCHEME_XCTOOL_FLAGS:=-workspace $(XC_WORKSPACE) -scheme OvercoatTests-tvOS -sdk appletvsimulator

CARTHAGE_PLATFORMS=Mac,iOS
CARTHAGE_FLAGS:=--platform $(CARTHAGE_PLATFORMS)

test: install-pod clean build-tests run-tests

test-osx: install-pod clean build-tests-osx run-tests-osx

test-ios: install-pod clean build-tests-ios run-tests-ios

test-tvos: install-pod clean build-tests-tvos run-tests-tvos

# Build Tests

clean:
	xcodebuild -project $(XCODE_PROJ) -alltargets clean

install-pod:
	COCOAPODS_DISABLE_DETERMINISTIC_UUIDS=YES pod install

build-tests-osx:
	xctool $(OSX_SCHEME_XCTOOL_FLAGS) build-tests

build-tests-ios:
	xctool $(IOS_SCHEME_XCTOOL_FLAGS) build-tests

build-tests-tvos:
	xctool $(TVOS_SCHEME_XCTOOL_FLAGS) build-tests

# Run Tests

run-tests-osx:
	xctool $(OSX_SCHEME_XCTOOL_FLAGS) run-tests

run-tests-ios:
	xctool $(IOS_SCHEME_XCTOOL_FLAGS) run-tests -test-sdk iphonesimulator

run-tests-tvos:
	xctool $(TVOS_SCHEME_XCTOOL_FLAGS) run-tests -test-sdk appletvsimulator

# Intetfaces

build-tests: build-tests-osx build-tests-ios build-tests-tvos

run-tests: run-tests-osx run-tests-ios run-tests-tvos

# Distribution

test-carthage:
	rm -rf Pods/
	carthage update $(CARTHAGE_FLAGS)
	carthage build --no-skip-current $(CARTHAGE_FLAGS) --verbose

test-pod:
	pod spec lint Overcoat.podspec --verbose --allow-warnings --no-clean --fail-fast

distribute-pod: test
	pod trunk push --allow-warnings

distribute-carthage: test
