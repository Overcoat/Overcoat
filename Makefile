XC_WORKSPACE=Overcoat.xcworkspace
OSX_SCHEME_XCTOOL_FLAGS:=-workspace $(XC_WORKSPACE) -scheme Overcoat-OSX
IOS_SCHEME_XCTOOL_FLAGS:=-workspace $(XC_WORKSPACE) -scheme Overcoat-iOS -sdk iphonesimulator

test: test-osx test-ios

# Build Tests

install-pod:
	COCOAPODS_DISABLE_DETERMINISTIC_UUIDS=YES pod install

clean-osx:
	xctool $(OSX_SCHEME_XCTOOL_FLAGS) clean

clean-ios:
	xctool $(IOS_SCHEME_XCTOOL_FLAGS) clean

build-osx-tests:
	xctool $(OSX_SCHEME_XCTOOL_FLAGS) build-tests

build-ios-tests:
	xctool $(IOS_SCHEME_XCTOOL_FLAGS) build-tests

# Run Tests

run-osx-tests:
	xctool $(OSX_SCHEME_XCTOOL_FLAGS) run-tests

run-ios-tests:
	xctool $(IOS_SCHEME_XCTOOL_FLAGS) run-tests -test-sdk iphonesimulator

# Intetfaces

test-osx: install-pod clean-osx build-osx-tests run-osx-tests

test-ios: install-pod clean-ios build-ios-tests run-ios-tests
