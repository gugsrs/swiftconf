import Foundation

enum ErrorsToThrow: Error {
case commentLine
case invalidLine
}

struct swiftconf {
	public func EnvfileConfiguration() {
		let path =  ".env"
		var confs: [String:Any] = [:]
		do {
			let contents = try NSString(contentsOfFile: path, encoding: String.Encoding.ascii.rawValue)
			let lines = contents.components(separatedBy: .newlines)
			for line in lines {
				if line.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty {
                    continue
                }
				do {
					let res = try self.parseLine(line)
					confs[res.key] = res.value
				} catch ErrorsToThrow.commentLine {
					continue	
				}
			}
			print("\(confs)")
		} catch {
			print("Error catched")
		}
	}

	private func parseLine(_ line: String) throws -> (key: String, value: Any) {
		if line[line.startIndex] == "#" {
			throw ErrorsToThrow.commentLine
		}
		let key_value = line.components(separatedBy: "=")
		// PARSE KEY
		// PARSE VALUE
		return (key_value[0], key_value[1])
	}

	private func getEnvFilePath() -> String {
		let relativePath = "/.env"
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let filePath = currentPath + relativePath
        if fileManager.fileExists(atPath: filePath) {
            return filePath
        } else {
            return "Str"
        }
	}
}

swiftconf().EnvfileConfiguration()
