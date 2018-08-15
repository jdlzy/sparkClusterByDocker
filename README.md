# sparkClusterByDocker
基于Docker的spark集群



# spark
这是一个基于 debian:stretch 的Spark容器，基于standalone模式进行应用部署,需要使用docker-compose.yml来定义集群配置，或者以此作为一个更加复杂集群的基础


## 例子

先跑一下SpariPi的例子

	docker run --rm -it -p 4040:4040 gettyimages/spark bin/run-example SparkPi 10

在AWS上执行spark-shell:

	docker run  --rm -it -e "AWS_ACCESS_KEY_ID=TYOURKEY" -e "AWS_SECRET_ACCESS_KEY=TYOURSECRET" -p 4040:4040 gettyimages/spark bin/spark-shell


使用PySpark

    echo -e "import pyspark\n\nprint(pyspark.SparkContext().parallelize(range(0, 10)).count())" > count.py
    docker run --rm -it -p 4040:4040 -v $(pwd)/count.py:/count.py gettyimages/spark bin/spark-submit /count.py

## docker-compose例子

使用docker-compose创建一个简单的standalone模式集群：

	docker-compose up

可以通过Docker_host:8080来查看SparkUI
运行pyspark，需要进入容器：

	docker exec -it dockerspark_master_1 /bin/bash
	bin/pyspark
	#执行SparkPi
	dockerexec -it dockerspark_master_1 /bin/bash
	bin/run-example SparkPi 10
