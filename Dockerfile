#install docker

#build container from the directory of this Dockerfile:  sudo docker build -rm --tag="creyoco" .  
#run1: docker run -d creyoco  python3.4 manage.py run_autobahn & python3.4 manage.py runserver 0.0.0.0:8000


#to stop all container: docker stop $(docker ps -a -q)
#to remove all container: docker rm $(docker ps -a -q)

FROM 	ubuntu:14.04
MAINTAINER medienzentrum

RUN		echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe' > /etc/apt/sources.list
RUN 	apt-get update
RUN 	apt-get install -y python3-pip build-essential git default-jre libjpeg-dev
RUN 	pip3 install virtualenv
RUN		virtualenv  creyocoenv
RUN 	cd creyocoenv
RUN		. /creyocoenv/bin/activate

# install our code
RUN		rm -rf /home/creyoco
RUN 	git clone https://github.com/TUM-MZ/creyoco.git /home/creyoco/
RUN 	pip3 install -r /home/creyoco/pip-requirements.txt
RUN 	pip3 install -I pillow

EXPOSE 	8000
EXPOSE 	8080
WORKDIR /home/creyoco/
RUN 	python3.4 manage.py syncdb --noinput
RUN		python3.4 manage.py migrate exeapp --noinput
RUN		python3.4 manage.py createsuperuser --username='vagrant' --email='v@v.org' --noinput
RUN		python3.4 manage.py collectstatic --noinput

CMD 	python3.4 manage.py run_autobahn & python3.4 manage.py runserver 0.0.0.0:8000

