#!/bin/bash
Rscript cross-val.R > cross-val.log
sleep 5m
sudo shutdown -h now
