build:
	swift build

test:
	swift test

release:
	git tag `swift Scripts/tag_version.swift`
	git push origin `swift Scripts/tag_version.swift`
