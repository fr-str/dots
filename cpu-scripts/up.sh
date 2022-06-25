cpufreq-set -g performance
cpufreq-set -d 4000000
cpufreq-set -f 4000000
sleep 0.1
cat /proc/cpuinfo | grep 'cpu MHz'