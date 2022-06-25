cpufreq-set -g ondemand
cpufreq-set -d 1400000
cpufreq-set -f 1400000
sleep 0.1
cat /proc/cpuinfo | grep 'cpu MHz'