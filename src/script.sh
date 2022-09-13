#!/bin/bash

PORT1=50000
PORT2=50000

#./dataGenerator.sh cities types ../dataset 10 100

./server -p $PORT1 -q $PORT2 -t 10 &
sleep 1

./distributor -d ../dataset -s 7 -r 127.0.0.1 -p $PORT1 &
sleep 5

./client -r ../requestFile -q $PORT2 -s 127.0.0.1 -b 5




