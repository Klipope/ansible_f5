iApp Template Deployment
========================

This role is about the deployment of iApp templates towards the BIG-IP. I copied different versions of the Service Integration iApp Templates in the files folder. In the playbook you can refer to them for the deployment on the BIG-IP.

In appsvcs_integration_v2.0.004_waf.tmpl I compiled two examples of a Security Policy for demonstration. I exported the Security Policy from v12.1.2. Therefor you should use a BIG-IP with the same version as target system.

Here is the example playbook to use this role (iAppTemplate.yml):
```
---
  - hosts: "{{ target }}"
    gather_facts: False
    roles:
      - iAppTemplate
    vars:
      - f5template: "appsvcs_integration_v2.0.004_waf"
...
```


License
-------
Apache V2.0

Author Information
------------------
Ralf Bruenig (r.bruenig@f5.com)
