#!/bin/bash
touch seenUrls.txt
touch urlpage.html
cat urlList.txt | while read -s url; do
case $url in
 http*)
     touch urlpage.html
     echo -n "" > urlpage.html
         wget -q -O urlpage.html  $url || echo "$url FAILED"
        if ! grep -q "$url"* seenUrls.txt ; then
            echo "$url INIT"
            echo "$url $(md5sum urlpage.html | awk '{print $1}')" >> seenUrls.txt
        else
            cat seenUrls.txt | while read -s urlc; do
                website=$(echo "$urlc " | awk '{print $1}')
                if [ "$website" == "$url" ] ; then
                    old=$(echo "$urlc" | awk '{print $2}')
                    refreshed=$(echo "$(md5sum urlpage.html | awk '{print $1}')")
                    if [ "$refreshed" != "$old" ] ; then
                        echo "$website"
                    fi
                fi
            done
        fi    
esac
 
done