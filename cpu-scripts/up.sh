#!/bin/bash
for i in {0..5};do
    cpufreq-set -c $i -g performance
    cpufreq-set -c $i -u 4000000
    cpufreq-set -c $i -d 4000000
    cpufreq-set -c $i -f 4000000
done
sleep 0.1
cat /proc/cpuinfo | grep 'cpu MHz'