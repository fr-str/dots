cat <<EOF > /etc/default/cpufrequtils
GOVERNOR="ondemand"
MAX_SPEED="1400MHz"
EOF
sudo /etc/init.d/cpufrequtils restart
sleep 0.7
cat /proc/cpuinfo | grep 'cpu MHz'
