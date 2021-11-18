# fluentd-aggregator-geoip
Contains dockerfile to create a fluentd image wiht geoip plugin
The base image comes from  https://github.com/stevehipwell/fluentd-aggregator
The final image is for use within the helm chart at https://github.com/stevehipwell/helm-charts/blob/master/charts/fluentd-aggregator
and it will be tagged as useast.jfrog.lexisnexisrisk.com/accrnt-docker/fluentd-aggregator-geoip