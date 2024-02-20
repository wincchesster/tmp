#!bin/bash

  echo "Port ${ssh_port}" >> /etc/ssh/sshd_config
  systemctl restart ssh