docker exec jenkins sudo service apache2 start
docker exec mongo1 systemctl start sshd
docker exec mongo1 systemctl start systemd-user-sessions
docker exec mongo2 systemctl start sshd
docker exec mongo2 systemctl start systemd-user-sessions
docker exec mongo3 systemctl start sshd
docker exec mongo3 systemctl start systemd-user-sessions