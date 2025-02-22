#!/bin/bash

# Reads the card ID or the folder name with audio files
# from the command line (see Usage).
# Then attempts to get the folder name from the card ID
# or play audio folder content directly
#
# Usage for card ID
# ./rfid_trigger_play.sh -i=1234567890
# or
# ./rfid_trigger_play.sh --cardid=1234567890
#
# For folder names:
# ./rfid_trigger_play.sh -d='foldername'
# or
# ./rfid_trigger_play.sh --dir='foldername'
#
# or for recursive play of sudfolders
# ./rfid_trigger_play.sh -d='foldername' -v=recursive

# ADD / EDIT RFID CARDS TO CONTROL THE PHONIEBOX
# All controls are assigned to RFID cards in this
# file:
# settings/rfid_trigger_play.conf
# Please consult this file for more information.
# Do NOT edit anything in this file.

# Set the date and time of now
NOW=`date +%Y-%m-%d.%H:%M:%S`

# The absolute path to the folder whjch contains all the scripts.
# Unless you are working with symlinks, leave the following line untouched.
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


###ICI ON CREE UN INDEX DES LANGUES PARLEES

#############################################################
# $DEBUG TRUE|FALSE
# Read debug logging configuration file
. $PATHDATA/../settings/debugLogging.conf

if [ "${DEBUG_rfid_trigger_play_sh}" == "TRUE" ]; then echo "########### SCRIPT rfid_trigger_play.sh ($NOW) ##" >> $PATHDATA/../logs/debug.log; fi

# create the configuration file from sample - if it does not exist
if [ ! -f $PATHDATA/../settings/rfid_trigger_play.conf ]; then
    cp $PATHDATA/../settings/rfid_trigger_play.conf.sample $PATHDATA/../settings/rfid_trigger_play.conf
    # change the read/write so that later this might also be editable through the web app
    sudo chown -R pi:www-data $PATHDATA/../settings/rfid_trigger_play.conf
    sudo chmod -R 775 $PATHDATA/../settings/rfid_trigger_play.conf
fi

###########################################################
# Read global configuration file (and create is not exists)
# create the global configuration file from single files - if it does not exist
if [ ! -f $PATHDATA/../settings/global.conf ]; then
    . inc.writeGlobalConfig.sh
fi
. $PATHDATA/../settings/global.conf
###########################################################

# Read configuration file
. $PATHDATA/../settings/rfid_trigger_play.conf

# Get args from command line (see Usage above)
# see following file for details:
. $PATHDATA/inc.readArgsFromCommandLine.sh

##################################################################
# Check if we got the card ID or the audio folder from the prompt.
# Sloppy error check, because we assume the best.
if [ "$CARDID" ]; then
    # we got the card ID
    # If you want to see the CARDID printed, uncomment the following line
    # echo CARDID = $CARDID

    # Add info into the log, making it easer to monitor cards
    echo "Card ID '$CARDID' was used at '$NOW'." > $PATHDATA/../shared/latestID.txt
    echo "$CARDID" > $PATHDATA/../settings/Latest_RFID
    if [ "${DEBUG_rfid_trigger_play_sh}" == "TRUE" ]; then echo "Card ID '$CARDID' was used" >> $PATHDATA/../logs/debug.log; fi

    # If the input is of 'special' use, don't treat it like a trigger to play audio.
    # Special uses are for example volume changes, skipping, muting sound.

    case $CARDID in
        $CMDSHUFFLE)
            # toggles shuffle mode  (random on/off)
            $PATHDATA/playout_controls.sh -c=playershuffle
            ;;
        $CMDMAXVOL30)
            # limit volume to 30%
            $PATHDATA/playout_controls.sh -c=setmaxvolume -v=30
            ;;
        $CMDMAXVOL50)
            # limit volume to 50%
            $PATHDATA/playout_controls.sh -c=setmaxvolume -v=50
            ;;
        $CMDMAXVOL75)
            # limit volume to 75%
            $PATHDATA/playout_controls.sh -c=setmaxvolume -v=75
            ;;
        $CMDMAXVOL80)
            # limit volume to 80%
            $PATHDATA/playout_controls.sh -c=setmaxvolume -v=80
            ;;
        $CMDMAXVOL85)
            # limit volume to 85%
            $PATHDATA/playout_controls.sh -c=setmaxvolume -v=85
            ;;
        $CMDMAXVOL90)
            # limit volume to 90%
            $PATHDATA/playout_controls.sh -c=setmaxvolume -v=90
            ;;
        $CMDMAXVOL95)
            # limit volume to 95%
            $PATHDATA/playout_controls.sh -c=setmaxvolume -v=95
            ;;
        $CMDMAXVOL100)
            # limit volume to 100%
            $PATHDATA/playout_controls.sh -c=setmaxvolume -v=100
            ;;
        $CMDMUTE)
            # amixer sset 'PCM' 0%
            $PATHDATA/playout_controls.sh -c=mute
            ;;
        $CMDVOL30)
            # amixer sset 'PCM' 30%
            $PATHDATA/playout_controls.sh -c=setvolume -v=30
            ;;
        $CMDVOL50)
            # amixer sset 'PCM' 50%
            $PATHDATA/playout_controls.sh -c=setvolume -v=50
            ;;
        $CMDVOL75)
            # amixer sset 'PCM' 75%
            $PATHDATA/playout_controls.sh -c=setvolume -v=75
            ;;
        $CMDVOL80)
            # amixer sset 'PCM' 80%
            $PATHDATA/playout_controls.sh -c=setvolume -v=80
            ;;
        $CMDVOL85)
            # amixer sset 'PCM' 85%
            $PATHDATA/playout_controls.sh -c=setvolume -v=85
            ;;
        $CMDVOL90)
            # amixer sset 'PCM' 90%
            $PATHDATA/playout_controls.sh -c=setvolume -v=90
            ;;
        $CMDVOL95)
            # amixer sset 'PCM' 95%
            $PATHDATA/playout_controls.sh -c=setvolume -v=95
            ;;
        $CMDVOL100)
            # amixer sset 'PCM' 100%
            $PATHDATA/playout_controls.sh -c=setvolume -v=100
            ;;
        $CMDVOLUP)
            # increase volume by x% set in Audio_Volume_Change_Step
            $PATHDATA/playout_controls.sh -c=volumeup
            ;;
        $CMDVOLDOWN)
            # decrease volume by x% set in Audio_Volume_Change_Step
            $PATHDATA/playout_controls.sh -c=volumedown
            ;;
        $CMDSWITCHAUDIOIFACE)
            # switch between primary/secondary audio iFaces
            $PATHDATA/playout_controls.sh -c=switchaudioiface
	    ;;
        $CMDSTOP)
            # kill all running audio players
            $PATHDATA/playout_controls.sh -c=playerstop
            ;;
        $CMDSHUTDOWN)
            # shutdown the RPi nicely
            # sudo halt
            $PATHDATA/playout_controls.sh -c=shutdown
            ;;
        $CMDREBOOT)
            # shutdown the RPi nicely
            # sudo reboot
            $PATHDATA/playout_controls.sh -c=reboot
            ;;
        $CMDNEXT)
            # play next track in playlist
            $PATHDATA/playout_controls.sh -c=playernext
            ;;
        $CMDPREV)
            # play previous track in playlist
            # echo "prev" | nc.openbsd -w 1 localhost 4212
            sudo $PATHDATA/playout_controls.sh -c=playerprev
            #/usr/bin/sudo /home/pi/RPi-Jukebox-RFID/scripts/playout_controls.sh -c=playerprev
            ;;
        $CMDRANDCARD)
            # activate a random card
            $PATHDATA/playout_controls.sh -c=randomcard
            ;;
        $CMDRANDFOLD)
            # play a random folder
            $PATHDATA/playout_controls.sh -c=randomfolder
            ;;
        $CMDRANDTRACK)
            # jump to a random track in playlist (no shuffle mode required)
            $PATHDATA/playout_controls.sh -c=randomtrack
            ;;
        $CMDREWIND)
            # play the first track in playlist
            sudo $PATHDATA/playout_controls.sh -c=playerrewind
            ;;
        $CMDSEEKFORW)
            # jump 15 seconds ahead
            $PATHDATA/playout_controls.sh -c=playerseek -v=+15
            ;;
        $CMDSEEKBACK)
            # jump 15 seconds back
            $PATHDATA/playout_controls.sh -c=playerseek -v=-15
            ;;
        $CMDPAUSE)
            # pause current track
            # echo "pause" | nc.openbsd -w 1 localhost 4212
            $PATHDATA/playout_controls.sh -c=playerpause
            ;;
        $CMDPLAY)
            # play / resume current track
            # echo "play" | nc.openbsd -w 1 localhost 4212
            $PATHDATA/playout_controls.sh -c=playerplay
            ;;
        $STOPAFTER5)
            # stop player after -v minutes
            $PATHDATA/playout_controls.sh -c=playerstopafter -v=5
            ;;
        $STOPAFTER15)
            # stop player after -v minutes
            $PATHDATA/playout_controls.sh -c=playerstopafter -v=15
            ;;
        $STOPAFTER30)
            # stop player after -v minutes
            $PATHDATA/playout_controls.sh -c=playerstopafter -v=30
            ;;
        $STOPAFTER60)
            # stop player after -v minutes
            $PATHDATA/playout_controls.sh -c=playerstopafter -v=60
            ;;
        $SHUTDOWNAFTER5)
            # shutdown after -v minutes
            $PATHDATA/playout_controls.sh -c=shutdownafter -v=5
            ;;
        $SHUTDOWNAFTER15)
            # shutdown after -v minutes
            $PATHDATA/playout_controls.sh -c=shutdownafter -v=15
            ;;
        $SHUTDOWNAFTER30)
            # shutdown after -v minutes
            $PATHDATA/playout_controls.sh -c=shutdownafter -v=30
            ;;
        $SHUTDOWNAFTER60)
            # shutdown after -v minutes
            $PATHDATA/playout_controls.sh -c=shutdownafter -v=60
            ;;
		$SHUTDOWNVOLUMEREDUCTION10)
			# reduce volume until shutdown in -v minutes
			$PATHDATA/playout_controls.sh -c=shutdownvolumereduction -v=10
			;;
		$SHUTDOWNVOLUMEREDUCTION15)
			# reduce volume until shutdown in -v minutes
			$PATHDATA/playout_controls.sh -c=shutdownvolumereduction -v=15
			;;
		$SHUTDOWNVOLUMEREDUCTION30)
			# reduce volume until shutdown in -v minutes
			$PATHDATA/playout_controls.sh -c=shutdownvolumereduction -v=30
			;;
		$SHUTDOWNVOLUMEREDUCTION60)
			# reduce volume until shutdown in -v minutes
			$PATHDATA/playout_controls.sh -c=shutdownvolumereduction -v=60
			;;
        $ENABLEWIFI)
            $PATHDATA/playout_controls.sh -c=enablewifi
            ;;
        $DISABLEWIFI)
            $PATHDATA/playout_controls.sh -c=disablewifi
            ;;
        $TOGGLEWIFI)
            $PATHDATA/playout_controls.sh -c=togglewifi
            ;;
        $CMDPLAYCUSTOMPLS)
            $PATHDATA/playout_controls.sh -c=playlistaddplay -v="PhonieCustomPLS" -d="PhonieCustomPLS"
            ;;
        $RECORDSTART600)
            #start recorder for -v seconds
            $PATHDATA/playout_controls.sh -c=recordstart -v=600
            ;;
        $RECORDSTART60)
            #start recorder for -v seconds
            $PATHDATA/playout_controls.sh -c=recordstart -v=60
            ;;
        $RECORDSTART10)
            #start recorder for -v seconds
            $PATHDATA/playout_controls.sh -c=recordstart -v=10
            ;;
        $RECORDSTOP)
            $PATHDATA/playout_controls.sh -c=recordstop
            ;;
        $RECORDPLAYBACKLATEST)
            $PATHDATA/playout_controls.sh -c=recordplaylatest
            ;;
        $CMDREADWIFIIP)
            $PATHDATA/playout_controls.sh -c=readwifiipoverspeaker
            ;;
        $CMDBLUETOOTHTOGGLE)
            $PATHDATA/playout_controls.sh -c=bluetoothtoggle -v=toggle
            ;;
        *)

            # We checked if the card was a special command, seems it wasn't.
            # Now we expect it to be a trigger for one or more audio file(s).
            # Let's look at the ID, write a bit of log information and then try to play audio.

            # Look for human readable shortcut in folder 'shortcuts'
            # check if CARDID has a text file by the same name - which would contain the human readable folder name
            if [ -f $PATHDATA/../shared/shortcuts/$CARDID ]


            then
              FOLDERORCMD=`cat $PATHDATA/../shared/shortcuts/$CARDID`


                 #printf '%s\n' "${LANGUESARRAY[@]}" | grep -q -P '^$(FOLDERORCMD)$';

             if [[ "$FOLDERORCMD" != *".mp3"* ]]; then



                #WE DETECTED A  LANGUAGE STRING SO WE NEED TO CHANGE THE FOLDER VARIABLE
                echo "DETECTED A LANGUAGE"
                export DOSSIER=$FOLDERORCMD;
                echo "$DOSSIER">${PATHDATA}/../shared/CHOIX_LANGUES.txt
                echo "DOSSIER"
                echo $DOSSIER
              else
                echo "DETECTED A FILE TO PLAY/MP"
                echo "DOSSIER"
                #echo $DOSSIER
                DOSSIER=$(cat ${PATHDATA}/../shared/CHOIX_LANGUES.txt)
                echo $DOSSIER
                echo "{FOLDERORCMD}"
                echo "${FOLDERORCMD}"
                echo "${PATHDATA}/../shared/audiofolders/${DOSSIER}/$FOLDERORCMD"
                #RESULT=$(cat ${PATHDATA}/../shared/audiofolders/${DOSSIER}/$FOLDERORCMD)
                RESULT=${PATHDATA}/../shared/audiofolders/${DOSSIER}/$FOLDERORCMD
                echo "RESULT"
                echo $RESULT
                fichierA_Lire=$RESULT
                 #WE DETECTED A COMMAND STRING SO WE REPLACE THE WILDCARD WITH THE LANGUAGE STRING
                #fichierA_Lire=$($RESULT | sed -e "s/$(DOSSIER)/LANGAGE/g")
                mpg123 -a d plughw:0,0 $RESULT;
              fi
fi
esac
fi

#WHERE WE NEED TO INTERVENE#
