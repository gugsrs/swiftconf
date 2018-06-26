build:
	swift build

test:
	swift test

release:
	git tag `swift tag_version.swift`
	git push origin `swift tag_version.swift`
