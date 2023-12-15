import DebugLogger

@Logger
class DebugLogger {
    let test = "This is test string"
    func logError() {
        log(issue: "array was empty")
    }
}

let debugLogger = DebugLogger()
debugLogger.logError()
