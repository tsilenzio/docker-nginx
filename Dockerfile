FROM tsilenzio/base

MAINTAINER Taylor Silenzio <tsilenzio@gmail.com>

# Add the config files
ADD conf.d/* /tmp/

# Enable the service
ADD service/ /etc/service/

# Update package manager repositories
RUN add-apt-repository ppa:nginx/stable \
    && apt-get update \
    # Install Nginx
    && apt-get install -y nginx \
    # Enable log redirection
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    # Install configuration files
    && rm -f /etc/nginx/nginx.conf \
    && mv /tmp/nginx.conf /etc/nginx/nginx.conf \
    && chown root:root /etc/nginx/nginx.conf \
    && rm -f /etc/nginx/fastcgi.conf \
    && mv /tmp/fastcgi.conf /etc/nginx/fastcgi.conf \
    && chown root:root /etc/nginx/fastcgi.conf \
    && rm -f /etc/nginx/fastcgi_params \
    && mv /tmp/fastcgi_params /etc/nginx/fastcgi_params \
    && chown root:root /etc/nginx/fastcgi_params \
    # Handle post installation clean-up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

CMD ["/sbin/my_init"]