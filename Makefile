
all:
	sudo mkdir -p /home/dravaono/data/mariadb
	sudo mkdir -p /home/dravaono/data/wordpress
	sudo chown -R 1042:1042 /home/dravaono/data/mariadb
	sudo chown -R www-data:www-data /home/dravaono/data/wordpress
	sudo chmod -R 755 /home/dravaono/data/wordpress
	sudo chmod -R 755 /home/dravaono/data/mariadb
	cd srcs && docker compose up --build

clean:
	cd srcs && docker compose down
#	docker system prune -f --volumes
	sudo docker stop $$(sudo docker ps -qa) || true
	sudo docker rm $$(sudo docker ps -qa) || true
	sudo rm -rf /home/dravaono/data/mariadb
	sudo rm -rf /home/dravaono/data/wordpress
	sudo docker volume rm $$(sudo docker volume ls -q) || true
	sudo docker network rm $$(sudo docker network ls -q) 2>/dev/null || true

fclean:
	make clean
	echo "Removing all the containers, images and volumes"
	docker system prune -a -f --volumes
	docker network prune -f
	docker network rm $$(docker network ls -q) 2>/dev/null || true
	docker volume rm $$(docker volume ls -qf dangling=true) 2>/dev/null || true
	sudo rm -rf /home/dravaono/data/mariadb
	sudo rm -rf /home/dravaono/data/wordpress

re:
	make fclean
	make all