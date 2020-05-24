#!/bin/bash

HERE=$1

if [[ -d ${HERE}/websockify ]]; then
    WEBSOCKIFY=${HERE}/websockify/run

    if [[ ! -x $WEBSOCKIFY ]]; then
        echo "The path ${HERE}/websockify exists, but $WEBSOCKIFY either does not exist or is not executable."
        echo "If you intended to use an installed websockify package, please remove ${HERE}/websockify."
        exit 1
    fi

    echo "Using local websockify at $WEBSOCKIFY"
else
    WEBSOCKIFY_FROMSYSTEM=$(which websockify 2>/dev/null)
    WEBSOCKIFY_FROMSNAP=${HERE}/../usr/bin/python2-websockify
    [ -f $WEBSOCKIFY_FROMSYSTEM ] && WEBSOCKIFY=$WEBSOCKIFY_FROMSYSTEM
    [ -f $WEBSOCKIFY_FROMSNAP ] && WEBSOCKIFY=$WEBSOCKIFY_FROMSNAP

    if [ ! -f "$WEBSOCKIFY" ]; then
        echo "No installed websockify, attempting to clone websockify..."
        WEBSOCKIFY=${HERE}/websockify/run
        git clone https://github.com/novnc/websockify ${HERE}/websockify

        if [[ ! -e $WEBSOCKIFY ]]; then
            echo "Unable to locate ${HERE}/websockify/run after downloading"
            exit 1
        fi

        echo "Using local websockify at $WEBSOCKIFY"
    else
        echo "Using installed websockify at $WEBSOCKIFY"
    fi
fi