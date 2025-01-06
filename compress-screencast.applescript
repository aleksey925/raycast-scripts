#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Compress Screencast
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗜️

# Documentation:
# @raycast.description Compresses a screencast video file.
# @raycast.author alex925
# @raycast.authorURL https://raycast.com/alex925

# https://unix.stackexchange.com/questions/28803/how-can-i-reduce-a-videos-size-with-ffmpeg

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

    # 0-51: 0 is lossless, 51 is the worst quality; 23-28 is a reasonable range
    set videoQualityRate to 28

    set ffmpegCommand to "ffmpeg " & ¬
        "-i " & quoted form of inputFilePath & " " & ¬
        "-vcodec libx264 " & ¬
        "-crf " & videoQualityRate & " " & ¬
        "-progress pipe:1 " & ¬
        quoted form of outputFilePath & " > " & quoted form of logFilePath & " 2>&1"

    do shell script ffmpegCommand

    return "File compressed: " & outputFilePath
end tell
