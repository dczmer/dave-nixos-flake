FILE="$(date +%FT%T)_scrot.png"; cd ~/Pictures && scrot $@ $FILE -e "drawing $FILE"
