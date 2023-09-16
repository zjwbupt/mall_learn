.PHONY: run-mysql

run-mysql:
	@docker run --platform linux/amd64 -p 3306:3306 --name mysql \
	-e MYSQL_ROOT_PASSWORD=root  \
	-d mysql:5.7

nginx:
	docker run -p 80:80 --name nginx \
    -v ~/mydata/nginx/html:/usr/share/nginx/html \
    -v ~/mydata/nginx/logs:/var/log/nginx  \
    -v ~/mydata/nginx/conf:/etc/nginx \
    -d nginx:1.22

mq:
	docker run -p 5672:5672 -p 15672:15672 --name rabbitmq \
	-v ~/mydata/rabbitmq/data:/var/lib/rabbitmq \
	-d rabbitmq:3.9-management

es:
	docker run -p 9200:9200 -p 9300:9300 --name elasticsearch \
    -e "discovery.type=single-node" \
    -e "cluster.name=elasticsearch" \
    -e "ES_JAVA_OPTS=-Xms512m -Xmx1024m" \
    -v ~/mydata/elasticsearch/data:/usr/share/elasticsearch/data \
    -d elasticsearch:7.17.3

log:
	docker run --name logstash -p 4560:4560 -p 4561:4561 -p 4562:4562 -p 4563:4563 \
    --link elasticsearch:es \
    -v ~/mydata/logstash/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
    -d logstash:7.17.3


kibana:
	docker run --name kibana -p 5601:5601 \
    --link elasticsearch:es \
    -e "elasticsearch.hosts=https://es:9200" \
    -d kibana:7.17.3

mongo:
	docker run -p 27017:27017 --name mongo \
	-v ~/mydata/mongo/db:/data/db \
	-d mongo:4


minio:
	docker run -p 9090:9000 -p 9001:9001 --name minio \
    -v ~/mydata/minio/data:/data \
    -e MINIO_ROOT_USER=minioadmin \
    -e MINIO_ROOT_PASSWORD=minioadmin \
    -d minio/minio server /data --console-address ":9001"

redis:
	docker run -p 6379:6379 --name redis \
    -v ~/mydata/redis/data:/data \
    -d redis:7 redis-server --appendonly yes
