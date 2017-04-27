#!/bin/bash
Rscript gibbs_model.R > gibbs_model.log
sleep 15m
sudo shutdown -h now
