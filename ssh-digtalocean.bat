@echo off
ssh -o StrictHostKeyChecking=no -i C:\Users\ronon\.ssh\paykey_deploy root@46.101.95.200 %*
