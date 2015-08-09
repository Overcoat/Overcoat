test:
	# Call `make` directly to force `clean-pod`
	make test-ios-mantle1
	make test-ios-mantle2
	make test-osx-mantle1
	make test-osx-mantle2

# Command check

check-pod-install:
	which pod 1>/dev/null 2>&1 || (echo "\n\n>>> Please install cocoapods first. (https://cocoapods.org)\n" && exit 1)

check-xctool-install:
	which xctool 1>/dev/null 2>&1 || (echo "\n\n>>> Please install xctool first. (https://github.com/facebook/xctool)\n" && exit 1)

# Cocoapods, including Mantle setup

clean-pod:
	rm -rf Pods

install-osx-mantle1-pod install-ios-mantle1-pod install-osx-mantle2-pod install-ios-mantle2-pod: check-pod-install clean-pod

install-osx-mantle1-pod:
	OS_TYPE=OSX MANTLE=1.5 pod install 1>/dev/null

install-ios-mantle1-pod:
	OS_TYPE=iOS MANTLE=1.5 pod install 1>/dev/null

install-osx-mantle2-pod:
	OS_TYPE=OSX MANTLE=2.0 pod install 1>/dev/null

install-ios-mantle2-pod:
	OS_TYPE=iOS MANTLE=2.0 pod install 1>/dev/null


# Build tests

build-osx-tests build-ios-tests: check-xctool-install

build-osx-tests:
	xctool -workspace OvercoatApp.xcworkspace -scheme Overcoat-OSX build-tests 1>/dev/null

build-ios-tests:
	xctool -workspace OvercoatApp.xcworkspace -scheme Overcoat-iOS -sdk iphonesimulator build-tests 1>/dev/null

# Run tests

run-ios-tests run-osx-tests: check-xctool-install

run-ios-tests:
	xctool -workspace OvercoatApp.xcworkspace -scheme Overcoat-iOS -sdk iphonesimulator run-tests -test-sdk iphonesimulator

run-osx-tests:
	xctool -workspace OvercoatApp.xcworkspace -scheme Overcoat-OSX run-tests

# Tests

execute-ios-tests: build-ios-tests run-ios-tests

execute-osx-tests: build-osx-tests run-osx-tests

# Interfaces

test-ios-mantle1: install-ios-mantle1-pod execute-ios-tests

test-osx-mantle1: install-osx-mantle1-pod execute-osx-tests

test-ios-mantle2: install-ios-mantle2-pod execute-ios-tests

test-osx-mantle2: install-osx-mantle2-pod execute-osx-tests

test-ios: test-ios-mantle2

test-osx: test-osx-mantle2
