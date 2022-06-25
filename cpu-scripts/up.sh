cat <<EOF > /etc/default/cpufrequtils
GOVERNOR="performance"
MAX_SPEED="4000MHz"
EOF
sudo /etc/init.d/cpufrequtils restart
sleep 0.1
cat /proc/cpuinfo | grep 'cpu MHz'
