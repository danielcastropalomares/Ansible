After installation:

# Send netflow data drom switch, router or firewall to IP elastiflow and port 2055 UDP.
# Now acces to elastiflow via http://IP:5601, and create a new index : Management -> Index Patterns -> Create new index Patterns
# Select "elastiflow-*" and timestamp
# Finally import the dashboard from the github of the elastiflow "https://github.com/robcowart/elastiflow.git".
# For import dashboard: Management -> Saves objects -> Import 
# BET PATIENT! The kibana and logstash it's started after 10-15 minutes 

You can check the state of services with the next commands:

kibana:

netstat -nltp | grep 5601
ps aux | grep kibana
/var/log/kibana/kibana.stdout or kibana.stderr

logstash:
ps aux | grep logstash
/var/log/logstash/logstash-plain.log
netstat -nlup | grep 2055

elastisearch
netstat -nltp | grep 9200
