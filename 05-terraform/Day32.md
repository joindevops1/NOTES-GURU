# Monitoring with ELK

- Incident ticket for tracking: p1, p2, p3, p4
- p1 and p2 are critical as they affect the business
- p3 is on low priority that needs to be handled for e.g. in a day
- p4 is on the lowest priority

## Golden Principles

1. latency --> time for response, should be always low
2. traffic --> how many users are accessing our system
3. Errors --> 500, 503 these are from server side
4. Saturation --> benchmark, how many users can access with out any errors

## ELK

- Elasticsearch, Logstash and Kibana
- Elasticsearch is a distributed database and used for searching mechanism for e.g. Google Search suggestions
- From Elasticsearch, we have logstash and Kibana
- To view the data that is present in the Elasticsearch database, we use **Kibana** which is a UI that connects to the database
- **Logstash** is used for filtering the data that is coming from agents i.e. from other components in the roboshop project such as catalogue, cart etc
- For NGiNX, we can use: `/var/log/nginx/access.log` to access the logs generated by NGiNX

### Filebeat

- **Filebeat** can access the log files and forward it to elasticsearch
- Filebeat is also known as **agents**
- Elasticsearch needs high memory and more virtual cpu's, therefore we could use t3.large
- Also, as it stores and analyses the logs we need atleast 30GB of harddisk space
- Elasticsearch server is developed on Java
- Each component in Elasticsearch has its configuration inside `/etc/<component>/<component>.yaml`
- Kibana log files are present at `/var/log/kibana/kibana.log` location
- Kibana dashboard can be accessed using **port 5601**
- Logstash runs on **port 5044**
- On each component which we wish to push the log files to Elasticsearch, should have **filebeat** package installed

### View Logs on Kibana

- Menu -> Management -> Stack Management -> Data -> Index Management
- To view the log file in Kibana, Kibana -> Index Patterns
  - Create Index pattern
  - Name: filebeat*
  - Timestamp field: @timestamp
- Once the index pattern is created:
  - Menu -> Discover
- But the data is in unstructured format and **to apply filters on the unstructured data, we need logstash**
- NGiNX stores the time taken for the whole response to process inside: `$request_time`
- The NGiNX log format can be viewed in: `/etc/nginx/nginx.conf` and can modify according to our need so that only necessary information is sent to Elasticsearch for futher analysis
- Before installing Logstash, we should stop filebeat package on the components so that it will not send data to Elasticsearch
- Once Logstash is installed, we should change the configuration of filebeat inside `/var/log/filebeat/filebeat.yaml` so that it forwards the data to Logstash for processing and filtering and Logstash forwards the data to Elasticsearch as key-value pairs
- We can have lot of filters as Elasticsearch and Logstash are big tools and out-of-which we use `grok` for parsing the unstructured data into fields

### Example filters

```text
55.3.244.1 GET /index.html 15824 0.043

%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}

# How the data is stored in Elasticseach
client: 55.3.244.1
method: GET
request: /index.html
bytes: 15824
duration: 0.043
```

- We can get the variables such as IP, WORD, URIPATHPARAM, NUMBER etc from the Logstash website
- Prometheus and Grafana are used for metrics export whereas Elk is used logfiles export