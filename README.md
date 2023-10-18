# PUD

## Performance and Usage Diagnosis (PUD) Enabler

### To install the chart with the release name `pude`:

Clone the repository to your machine.

Change the content of extraScrapeConfigs.yaml file with the correct configurations and targets that you want PUD to scrape.

Install Performance and Usage Diagnosis Enabler

```console
$ helm install pude ./performanceandusagediagnosis
```

To check if the installation was successful run:

```console
$ kubectl get pods
```

The result should show something like:

```console
NAME                                                              READY   STATUS             RESTARTS       AGE
pud-grafana-6ff6854bb5-fp9q2                                      1/1     Running            0              10m
pud-kube-state-metrics-5cdcb9bfd9-p7gmz                           1/1     Running            0              10m
pud-performanceandusagediagnosis-alertmanager-6f65b65767-w57v8    1/1     Running            0              10m
pud-performanceandusagediagnosis-prometheusesadapter-6866dp4c4x   1/1     Running            0              10m
pud-performanceandusagediagnosis-server-c6b6f76c6-sdkhz           2/2     Running            0              10m
pud-performanceandusagediagnosis-targetapi-676d6998f-h8bzd        1/1     Running            0              10m
```

### To access PUD's Prometheus server UI:

Check for the PUD's Prometheus server NodePort:

```console
$ kubectl get services
```

To see more info about the targets that PUD is scraping go to `Status > Targets`.

To explore the metrics currently available on PUD go to `Graph` page and search for your metric.

Select Table to view your metric as tabular data or Graph to view them as graph.

Use PromQL (Prometheus Query Language) in order to aggregate time series data in real time.

### To access PUD's scraping targets:

Check for the PUD's Target API NodePort:

```console
$ kubectl get services
```

Use `http://<IP>:<NodePort>/docs` in order to utilize target API's Swagger UI.

### To access PUD's Grafana Dashboard UI:

Port forward grafana's pod to port 3000:

```console
$ kubectl port-forward pud-grafana-6986754ffd-7gr62 3000
```

In PUD's Grafana login page use:

Username: admin

To find the current password enter: 

```console
$ kubectl get secret pude-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

To get kubernetes secrets and grafana's secret name witch in our case is `pude-grafana` enter:

```console
$ kubectl get secrets
```

To change your grafanas password enter:

```console
$ kubectl exec -it <grafanas pod name> grafana-cli admin reset-admin-password <your reset password>
```

### Add Prometheus data sourse PUD's Grafana:

- Go to `Settings > Add Data Source > Prometheus`.

To set Prometheus' URL under HTTP settings first find performance-and-usage-diagnosis-server clusterIP:

```console
$ kubectl get services
```

- Copy and Paste the IP in the URL field.

- `Save & Test`

### Import new Dashboards for PUD's Grafana:

- Go to `Dashboards > + Import`.

- Upload Dashboard's json file or choose one from grafana.com.

- `Load`
