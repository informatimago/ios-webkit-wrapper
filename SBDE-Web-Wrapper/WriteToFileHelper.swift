//
//  WriteToFileHelper.swift
//  WebkitWraper
//
//

import UIKit
struct Platform {

    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }

}

let urlKey = "lastUsedUrlLocation"
let emailKey = "lastUsedEmailAddress"

let defaultEmailAddress = "ben@sbde.fr"
let defaultURLString = "http://www.sbde.fr/"

// let defaultURLString = "http://demos.bardesscloud.com/hub/stream/8b04d423-1e7e-4bd1-bedc-9a7ffb1240aa"
// let defaultURLString = "https://sense-demo.qlik.com/sense/app/372cbc85-f7fb-4db6-a620-9a5367845dce/sheet/JzJMza/state/analysis"
// let defaultURLString = "https://sense-demo.qlik.com/hub"


class WriteToFileHelper: NSObject {
    static let instance = WriteToFileHelper()



   static func writeToFile(text:String) {
        let file = "Console.log" //this is the file. we will write to and read from it

        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory: NSString = paths[0] as! NSString
        let logPath: String = documentsDirectory.appendingPathComponent("Console.log") as String

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let url = URL(fileURLWithPath: logPath)

            let path = dir.appendingPathComponent(file)

            var text2 = ""
            //reading
            do {
                text2 = try String(contentsOf: url, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}

            //writing
            do {
                text2 = text2.appending(text)
                text2 = text2.appending(" \n \n ")

                try text2.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}

        }
    }

    static func redirectConsoleLogToDocumentFolder() {
        if Platform.isSimulator {
            return
        }
        // Instance of a private filemanager
        let myFileManger = FileManager.default

        // the path of the documnts directory of the app
        let documentDirectory: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        // maximum number of logfiles
        let maxNumberOfLogFiles: Int = 10

        // look if the max number of files already exist
        var logFilePath : String = documentDirectory.appending("/Console.log")
        var FlagOldFileNoProblem: Bool = true
        if myFileManger.fileExists(atPath: logFilePath) == true {

            // yes, max number of files reached, so delete the oldest one
            do {
                try myFileManger.removeItem(atPath: logFilePath)

            } catch let error as NSError {

                // something went wrong
                print("ERROR deleting old logFile \(maxNumberOfLogFiles): \(error.description)")
                FlagOldFileNoProblem = false
            }
        }

        // test, if there was a problem with the old file
        if FlagOldFileNoProblem == true {

            // look, if an old file exists, if so, rename it with an index higher than before
            logFilePath = documentDirectory.appending("/Console.log")
            if myFileManger.fileExists(atPath: logFilePath) == true {

                // there is an old file
                let logFilePathNew = documentDirectory.appending("/WayAndSeeConsole.log")
                do {

                    // rename it
                    try myFileManger.moveItem(atPath: logFilePath, toPath: logFilePathNew)

                } catch let error as NSError {

                    // something went wrong
                    print("ERROR renaming logFile: \(error.description)")
                    FlagOldFileNoProblem = false
                }
            }
        }

        // test, if there was a problem with the old files
        if FlagOldFileNoProblem == true {

            // No problem so far, so try to delete the old file
            logFilePath = documentDirectory.appending("/Console0.log")
            if myFileManger.fileExists(atPath: logFilePath) == true {

                // yes, it exists, so delete it
                do {
                    try myFileManger.removeItem(atPath: logFilePath)

                } catch let error as NSError {

                    // something went wrong
                    print("ERROR deleting old logFile 0: \(error.description)")
                }
            }
        }

        // even if there was a problem with the files so far, we redirect
        logFilePath = documentDirectory.appending("/Console.log")

        if (isatty(STDIN_FILENO) == 0) {
            freopen(logFilePath, "a+", stderr)
            freopen(logFilePath, "a+", stdin)
            freopen(logFilePath, "a+", stdout)
            //                displayDebugString("test", StringToAdd: "stderr, stdin, stdout redirected to \"\(logFilePath)\"")
        } else {
            //                displayDebugString("test with error", StringToAdd: "stderr, stdin, stdout NOT redirected, STDIN_FILENO = \(STDIN_FILENO)")
        }
    }

   static func loadEmail() -> String? {
        let pref = UserDefaults.standard
        return pref.value(forKey: emailKey) as! String?
    }

    static func saveEmail(_ emailAddress:String) {
        let pref = UserDefaults.standard
        pref.setValue(emailAddress, forKey: emailKey)
        pref.synchronize()
    }

    static func loadUrl() -> String? {
         let pref = UserDefaults.standard
         return pref.value(forKey: urlKey) as! String?
     }

     static func saveURL(_ url:String) {
         let pref = UserDefaults.standard
         pref.setValue(url, forKey: urlKey)
         pref.synchronize()
     }

}
