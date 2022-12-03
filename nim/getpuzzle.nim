import std/parsecfg
import cligen
import std/os
import strutils
import std/strformat
import std/httpclient


proc download(year: int, day: int, overwrite = false) : int =
    let config = loadConfig(joinPath(os.getAppDir(), "config.ini"))
    let cookie = config.getSectionValue("Cookies", $year)
    if cookie.isEmptyOrWhitespace():
        stderr.writeLine(&"No cookie for year {year}")
        return 1

    let inputRoot = config.getSectionValue("Paths", "input")
    if inputRoot.isEmptyOrWhitespace():
        stderr.writeLine(&"No path configured for storing the input.")
        return 1

    let inputPath = expandTilde(joinPath(inputRoot,$year))
    let inputFile = joinPath(inputPath, &"{day}.txt")
    if fileExists(inputFile) and not overwrite:
        echo &"File {inputFile} exists, skipping download"
        return 0


    var client = newHttpClient()
    client.headers["cookie"] = &"session={cookie}" 
    let input = client.getContent(&"https://adventofcode.com/{year}/day/{day}/input")

    createDir(inputPath)
    let f = open(joinPath(inputPath, &"{day}.txt"), fmWrite)
    f.write(input)
    defer: f.close()
    return 0

dispatch(download)