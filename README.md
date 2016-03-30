#docker-node

Dockerfile for build and run webapp installed on Node.js + Redis + Mongodb

#How it works?

	docker build -t tomori/node .
	
	docker run -d -v ./data:/data -p 10090:10090 -t -i tomori/node // 10090 is your exposed port
	
	docker ps // get CONTAINER ID
	
	docker attach <CONTAINER ID>
	
	supervisord // run redis and mongod
	
	<do what your want...>