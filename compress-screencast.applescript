#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Compress Screencast
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗜️

# Documentation:
# @raycast.description Compresses a screencast video file using the H.265 video codec and AAC audio codec.
# @raycast.author alex925
# @raycast.authorURL https://raycast.com/alex925

tell application "Finder"
    set selectedFiles to selection
    if (count of selectedFiles) is 0 then
        return "Please select a file"
    else if (count of selectedFiles) > 1 then
        return "You can select only one file"
    end if

    set selectedFile to item 1 of selectedFiles
    set inputFilePath to POSIX path of (selectedFile as alias)

    -- Getting the name and path to the folder to save the output file
    set fileName to name of selectedFile
    set fileExtension to name extension of selectedFile
    set fileDirectory to POSIX path of (container of selectedFile as alias)

    set outputFileName to (text 1 thru -((count fileExtension) + 2) of fileName) & "-compressed.mp4"
    set outputFilePath to fileDirectory & outputFileName

    set logFileName to (text 1 thru -((count fileExtension) + 2) of outputFileName) & ".log"
    set logFilePath to fileDirectory & logFileName

    # -c:a - audio codec
    # -b:a - audio bitrate (quality)
    set ffmpegCommand to "ffmpeg " & ¬
        "-i " & quoted form of inputFilePath & " " & ¬
        "-c:v libx265 " & ¬
        "-threads 4 " & ¬
        "-c:a aac " & ¬
        "-b:a 128k " & ¬
        "-progress pipe:1 " & ¬
        quoted form of outputFilePath & " > " & quoted form of logFilePath & " 2>&1"

    do shell script ffmpegCommand

    return "File compressed: " & outputFilePath
end tell
