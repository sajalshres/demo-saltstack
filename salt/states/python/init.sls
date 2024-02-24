{%- set osfamily = grains.get('os_family','') %}
{%- if osfamily|lower == 'redhat' %}
include:
  - .linux
{%- endif %}