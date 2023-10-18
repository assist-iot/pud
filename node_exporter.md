## Monitor Linux Servers Using Performance and Usage Diagnosis (PUD) Enabler

### Setup Node Exporter Binary

- Download the latest node exporter package.

```console
cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
```

- Unpack the tarball

```console
tar -xvf node_exporter-0.18.1.linux-amd64.tar.gz
```

- Move the node export binary to `/usr/local/bin`

```console
sudo mv node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/
```

### Create a Custom Node Exporter Service

- Create a node_exporter user to run the node exporter service.

```console
sudo useradd -rs /bin/false node_exporter
```

- Create a node_exporter service file under systemd.

```console
sudo nano /etc/systemd/system/node_exporter.service
```

- Add the following service file content to the service file and save it.

```console
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

- Reload the system daemon and star the node exporter service.

```console
sudo systemctl daemon-reload
sudo systemctl start node_exporter
```

- Check the node exporter status to make sure it is running in the active state.

```console
sudo systemctl status node_exporter
```

-  Enable the node exporter service to the system startup.

```console
sudo systemctl enable node_exporter
```

Now, node exporter would be exporting **metrics on port 9100**. 

You can see all the server metrics by visiting your server URL on `/metrics` as shown below.

```console
http://<server-IP>:9100/metrics
```
