# Create EC2 Instance
resource "aws_instance" "openvpn" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install awscli",
      "sudo apt-get -y install software-properties-common",
      "sudo add-apt-repository -y ppa:certbot/certbot",
      "sudo apt-get -y update",
      "sudo apt-get -y install certbot",
      "sudo service openvpnas stop",
      "sudo certbot certonly --standalone --non-interactive --agree-tos --email ${var.lets_encrypt_email} --domains ${var.openvpn_public_hostname} --pre-hook 'sudo service openvpnas stop' --post-hook 'sudo service openvpnas start'",
      "sudo ln -s -f /etc/letsencrypt/live/${var.openvpn_public_hostname}/cert.pem /usr/local/openvpn_as/etc/web-ssl/server.crt",
      "sudo ln -s -f /etc/letsencrypt/live/${var.openvpn_public_hostname}/privkey.pem /usr/local/openvpn_as/etc/web-ssl/server.key",
      "sudo service openvpnas start",
      "chmod u+x /home/openvpnas/backup.sh",
      "chmod u+x /home/openvpnas/restore.sh",
      "{ sudo crontab -l; echo '0 15 * * * certbot renew'; } | sudo crontab -"
      "{ sudo crontab -l; echo '0 16 * * * /home/openvpnas/backup.sh'; } | sudo crontab -"
    ]
  }

  tags {
    Name = "OpenVPN Access Server"
  }
}