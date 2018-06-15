import Foundation

enum Errors: Error {
case commentLine
case invalidLine
case fileNotFound
}

extension String {
    func parentDirectory() -> String {
        let url = URL(fileURLWithPath: self)
        return url.deletingLastPathComponent().path
    }
}

struct swiftconf {
    public func EnvfileConfiguration() -> [String:Any] {
        var confs: [String:Any] = [:]
        guard let path = self.getEnvFilePath() else {
            return confs
        }
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
                } catch Errors.commentLine {
                    continue    
                }
            }
            return confs
        } catch {
            print("Error catched \(error)")
        }
        return confs
    }

    private func parseLine(_ line: String) throws -> (key: String, value: Any) {
        if line[line.startIndex] == "#" {
            throw Errors.commentLine
        }
        let key_value = line.components(separatedBy: "=")
        // PARSE KEY
        // PARSE VALUE
        return (key_value[0], key_value[1])
    }

    private func getEnvFilePath() -> String? {
        let filePath = "/.env"
        let root = "/"
        let fileManager = FileManager.default
        var currentPath = fileManager.currentDirectoryPath
        var path = currentPath + filePath
        while currentPath != root {
            if fileManager.fileExists(atPath: path) {
                return path
            } else {
                currentPath = currentPath.parentDirectory()
                path = currentPath + filePath
            }
        }
        return nil
    }
}

let confs = swiftconf().EnvfileConfiguration()
