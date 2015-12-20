#!/bin/bash
for i in {1..10}; do wget -qO- http://192.168.100.100; echo; sleep 1; done