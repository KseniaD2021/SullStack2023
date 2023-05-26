BREW := /usr/local/bin/brew
ROOT_DIRECTORY=.

all: bootstrap

## bootstrap: Bootstrap project dependencies for development
init: homebrew icon
	mint bootstrap

## bootstrap: Bootstrap project dependencies for development
bootstrap: homebrew hook
	mint bootstrap

## test: Launch unit tests
test: gems
	bundle exec fastlane test

## homebrew: Bootstrap Homebrew dependencies
homebrew: 
	brew bundle check || brew bundle

## fmt: Launch swift files code formatter
fmt:
	mint run swiftformat swiftformat SchoolStore --quiet --conflictmarkers ignore

## lint: Launch swift files linter check
lint:
	mint run swiftlint --path SchoolStore

## swiftgen: Trigger code generation from assets with swiftgen tool
swiftgen:
	@echo "Generate resources locally"
	mint run swiftgen

## icon: Update application icon from the AppIcon1024.png file
icon:
	mint run Nonchalant/AppIcon appicon AppIcon1024.png --output-path SchoolStore/Resources/Assets.xcassets/AppIcon.appiconset

## clean: Clean up project files
clean:
	git clean -Xfd

## help: Prints help message
help:
	@echo Usage: n
	@sed -n 's/^##//p'  | column -t -s ':' |  sed -e 's/^/ /' | sort

:
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | ruby

.PHONY: all init help bootstrap test lint fmt homebrew swiftgen icon clean 