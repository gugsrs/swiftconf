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

public struct swiftconf {
    var confs: [String:Any] = [:]

    init() {
        self.EnvfileConfiguration()
    }

    init(withPath path: String) {
        self.EnvfileConfiguration()
    }

    public mutating func EnvfileConfiguration() {
        guard let path = self.getEnvFilePath() else {
            return
        }
        do {
            let contents = try NSString(contentsOfFile: path, encoding: String.Encoding.ascii.rawValue)
            let lines = contents.components(separatedBy: .newlines)
            for currentLine in lines {
                let line = currentLine.trimmingCharacters(in: .whitespacesAndNewlines)
                if line.isEmpty {
                    continue
                }
                do {
                    let res = try self.parseLine(line)
                    self.confs[res.key] = res.value
                } catch Errors.commentLine {
                    continue    
                }
            }
        } catch {
            print("Error catched \(error)")
        }
    }

    func parseLine(_ line: String) throws -> (key: String, value: Any) {
        if line[line.startIndex] == "#" {
            throw Errors.commentLine
        }
        let splittedLine = line.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
        let key = splittedLine[0]
        var value = String(splittedLine[1])
        if value.isEmpty {
            return (String(key), value)
        }
        value = self.valueParser(value)
        value = value.replacingOccurrences(of: "\'", with: "")
        if value.first! == "\"" {
            value = String(value.dropFirst())
        }
        if value.last! == "\"" {
            value = String(value.dropLast())
        }
        return(String(key), value)
    }

    func getEnvFilePath() -> String? {
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

    func valueParser(_ value: String) -> String {
        var is_quoted = false
        var new = ""
        for c in value {
            if c == "#" && is_quoted == false {
                break
            }
            if c == "\"" && is_quoted == false{
                is_quoted=true
            } else if c == "\"" && is_quoted == true {
                is_quoted = false
            }
            new.append(c)
        }
        new = new.trimmingCharacters(in: .whitespacesAndNewlines)
        return new
    }

    func get(_ name: String) -> Any? {
        return self.confs[name]
    }
}

let config = swiftconf().get
