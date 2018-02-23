iApp Service Deployment
=======================

This role enables you to deploy your own iApp Service Deployments. As a starting point, you should create an example deployment on a test system and export it over REST. The resulting Json file can be stored as a starting point. To be more flexible I created out of the json file a jinja2 file to integrate the deployment with some parameters, to get more flexibility.

In the template folder I stored the following examples of a jinja2 deployment:

appsvcs_http.j2
---------------
Simple http deployment with an optional second vip address.

Example playbook (http_iApp.yml):
```
###############################################################
# https deployment with optimizations and LAMP WAF protection #
###############################################################
#
# network:
# - SNAT
# - TCP full proxy
# - Additional IPv4/IPv6 address (optional)
#
# LB:
# - Method: least connections
# - Persistence: cookie, fallback is source address
#
# http feature:
# - X-Forwarded-For header
# - Default http monitor
---
  - hosts: "{{ target }}"
    gather_facts: False
    roles:
      - iAppService
    vars:
      - app_name: "http_app_22"
      - vip: "10.128.10.22"
      - vip_2: "2011:f5::10:128:10:22"
      - members:
        -
          ip: "10.10.10.211"
          port: "80"
        -
          ip: "10.10.10.212"
          port: "80"

## don't touch: ##
      - f5template: "appsvcs_integration_v2.0.004_waf"
      - j2template: "appsvcs_http"
...
```

appsvcs_https_waf.j2
--------------------
WAF deployment with the following options:
* https and optional redirect http virtual
* sorry page
* http analytics
* customizable http monitor

Example playbook (https_waf_iApp.yml):
```
###############################################################
# https deployment with optimizations and LAMP WAF protection #
###############################################################
#
# network:
# - SNAT
# - TCP full proxy
# - increased tcp buffer for larger packages
#
# SSL:
# - SSL offloading
#
# LB:
# - Method: least connections
# - Persistence: cookie, fallback is source address
#
# http feature:
# - X-forwarded-For header
# - http static caching
# - Internal connection reuse
# - port 80 redirect
# - sorry page
# - customizable http monitor
#
# WAF:
# - Blacklisting for LAMP
# - Log all requests


---
  - hosts: "{{ target }}"
    gather_facts: False
    roles:
      - iAppService
    vars:
      - app_name: "auction_26"
      - redirect: true
      - sorry: true
      - monitor_request_path: "/index.php"
      - monitor_response: "PHPAUCTION"
      - vip: "10.128.10.26"
      - members:
        -
          ip: "10.10.10.11"
          port: "80"

## don't touch: ##
      - f5template: "appsvcs_integration_v2.0.004_waf"
      - j2template: "appsvcs_https_waf"
...


appsvcs_scp.j2
--------------
SCP virtual deployment with long idle timeout, disabled nagle algorithm and connection limits per pool member.

Example playbook (https_waf_iApp.yml):
```
############################################
# scp deployment with longer tcp timeout   #
############################################
#
# iApp required: appsvcs_integration_v2.0.004_waf
#
# Feature:
# - ideltimeout = 3600s
# - nagle algorithm = disabled
# - Connection Limit per PoolMember
# - Load balancing: least connection ration
# - Ports static at 22
#
# vars:
#   - vip: <virtual server ip address>
#   - members:
#     -
#       ip: <pool member ip>
#       conn_limit: <max connection>
---
  - hosts: "{{ target }}"
    gather_facts: False
    roles:
      - iAppService
    vars:
      - app_name: "scp_server"
      - vip: "10.128.10.21"
      - members:
        -
          ip: "10.10.10.212"
          conn_limit: "20"
        -
          ip: "10.10.10.213"
          conn_limit: "20"

## don't touch: ##
      - f5template: "appsvcs_integration_v2.0.004_waf"
      - j2template: "appsvcs_scp"
...
```

License
-------
Apache V2.0

Author Information
------------------
Ralf Bruenig (r.bruenig@f5.com)
