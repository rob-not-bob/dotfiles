if application "iTerm" is running then 
  tell application "iTerm"
    create window with default profile
  end tell
else
  tell application "iTerm" to activate
end if
