local kp =
  (import 'kube-prometheus/kube-prometheus.libsonnet') + 
  (import 'kube-prometheus/kube-prometheus-kops.libsonnet') +
  (import 'kube-prometheus/kube-prometheus-insecure-kubelet.libsonnet') +  
  {
    _config+:: {
      namespace: 'monitoring',
      jobs: {
        Kubelet: $._config.kubeletSelector,
        KubeAPI: $._config.kubeApiserverSelector,
        KubeStateMetrics: $._config.kubeStateMetricsSelector,
        NodeExporter: $._config.nodeExporterSelector,
        Alertmanager: $._config.alertmanagerSelector,
        Prometheus: $._config.prometheusSelector,
        PrometheusOperator: $._config.prometheusOperatorSelector,
      },
      grafana+:: {
        config: { // http://docs.grafana.org/installation/configuration/
          sections: {
            "auth.anonymous": {enabled: true},
          },
        },
        datasources: [{
          name: 'prometheus',
          type: 'prometheus',
          access: 'proxy',
          orgId: 1,
          url: 'http://prometheus-k8s.' + $._config.namespace + '.svc:9090/prometheus',
          version: 1,
          editable: false,
        }],
      },
    },
  };

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
