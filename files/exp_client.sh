timeout $1 python2 ~/AStream/dist/client/dash_client.py -m http://server/media/BigBuckBunny/4sec/BigBuckBunny_4s.mpd -p \'$2\'
mv ASTREAM_LOGS/*.csv ~/$2.csv
rm -r TEMP_*
rm -r ASTREAM_LOGS
rm BigBuckBunny_4s.mpd