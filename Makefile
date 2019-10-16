clean:
	@rm -rf .build/

build:
	swift build

format:
	swiftlint autocorrect

test:
	swift test

release:
	git tag `swift Scripts/tag_version.swift`
	git push origin `swift Scripts/tag_version.swift`
