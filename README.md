# Terraform Module for Deploying JMeter

Deploys and configures JMeter an EC2 instance running CentOS 7.

## Usage

After instance startup, monitor the output of the following for cloud-init completion before running Jmeter:

```
sudo journalctl --no-pager -f | grep cloud-init
```

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This project was started in 2019 by [David Alger](https://davidalger.com/).
