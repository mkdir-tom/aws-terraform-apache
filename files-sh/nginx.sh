#!/bin/bash
sudo apt update -y
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx