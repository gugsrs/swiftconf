import Foundation

let filePath = "/CHANGES.rst"
let fileManager = FileManager.default
let path = fileManager.currentDirectoryPath + filePath
let pat = "\\s*([0-9]+\\.[0-9]+\\.[0-9]+)$"
let regex = try! NSRegularExpression(pattern: pat, options: [])
do {
	let contents = try NSString(contentsOfFile: path, encoding: String.Encoding.ascii.rawValue)
	let lines = contents.components(separatedBy: .newlines)
	for currentLine in lines {
		let results = regex.matches(in: currentLine, range: NSRange(location: 0, length: currentLine.count))
		if results.count > 0 {
			let version = results.compactMap {
				Range($0.range, in: currentLine).map { String(currentLine[$0]) }
			}[0]
			print(version)
			break
		}
	}
} catch {
	print("Error catched \(error)")
}
