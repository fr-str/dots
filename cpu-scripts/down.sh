#!/bin/bash
for i in {0..5};do
    cpufreq-set -c $i -g ondemand
    cpufreq-set -c $i -u 1400000
    cpufreq-set -c $i -d 1400000
    cpufreq-set -c $i -f 1400000
done
sleep 0.1
cat /proc/cpuinfo | grep 'cpu MHz'