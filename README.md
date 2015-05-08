## Generic Docker image for Apache HTTP server based on CentOS

This image is generic, thus you can obviously re-use it within your non-related EEA projects.

### Tags
 - latest
 - centos6

### How to use this image
        $ docker run -it --rm -p 80:80 eeacms/httpd
        
### Server configuration
Build a Dockerfile with something similar:

        FROM eeacms/httpd
        
        ADD your-file.conf /etc/httpd/conf/httpd.conf
