FROM tsilenzio/base

MAINTAINER Taylor Silenzio <tsilenzio@gmail.com>

# Install nginx
RUN apt-get update -y && \
    apt-get install -y python-software-properties && \
    add-apt-repository ppa:nginx/stable && \
    apt-get update && apt-get install -y nginx

# Handle post installation
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add the nessary missing line to fastcgi_pararms
RUN echo "fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" >> /etc/nginx/fastcgi_params && \
	# Enable log redirection
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
	# Remove the older nginx configuration
    rm -f /etc/nginx/nginx.conf

# Install the nginx configuation
ADD conf/nginx.conf /etc/nginx/

# Enable the service
ADD service/ /etc/service/

EXPOSE 80

CMD ["/sbin/my_init"]