FROM      ubuntu
MAINTAINER Olexander Kutsenko <olexander.kutsenko@gmail.com>

#install
RUN apt-get update -y
RUN apt-get install git git-core vim nano mc nginx screen curl unzip -y
RUN apt-get install -y php5 php5-fpm php5-cli php5-common php5-intl php5-json php5-mysql php5-gd php5-imagick php5-curl php5-mcrypt php5-dev php5-xdebug

#php
RUN sudo rm /etc/php5/fpm/php.ini
RUN cp configs/php.ini /etc/php5/fpm/php.ini
RUN cp configs/20-xdebug.ini /etc/php5/fpm/conf.d/
RUN cp configs/www.conf /etc/php5/fpm/pool.d/www.conf

#MySQL
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN sudo apt-get  install -y mysql-server mysql-client

#nginx
RUN cp configs/website /etc/nginx/sites-available/website
RUN ln -s /etc/nginx/sites-available/website /etc/nginx/sites-enabled/website
RUN sudo rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

# SSH service
RUN sudo apt-get install -y openssh-server openssh-client
RUN sudo mkdir /var/run/sshd
RUN echo 'root:passwd' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#configs bash start
RUN cp configs/autorun.sh /root/autostart.sh
RUN chmod +x /root/autostart.sh
RUN cp configs/bash.bashrc /etc/bash.bashrc

#composer
RUN cd ~
RUN curl -sS https://getcomposer.org/installer | php
RUN sudo mv composer.phar /usr/bin/composer


 
