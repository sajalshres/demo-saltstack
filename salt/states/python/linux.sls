# Import server utilities python default values
{% import_yaml "python/defaults.yaml" as defaults %}

# Merge pillar data with default values for Python configuration
{% set args = salt['pillar.get']('serverutilities:python', default=defaults.serverutilities.python, merge=True) %}

# Ensure version is in string format and remove dots for package naming
{% set version_raw = args.version | string %}
{% if version_raw is match("^\d+\.\d+$") %}
  {% set version = version_raw | replace('.', '') %}
{% else %}
  {% do salt['log.error']('Python version format is incorrect. Should be X.Y, got: ' ~ version_raw) %}
  {% set version = 'default' %}
{% endif %}

# Install Python and pip modules
Install Python:
    pkg.installed:
        - pkgs:
            - python{{ version }}
            - python{{ version }}-pip

# Install pip modules if supplied
{% if args.get('requirements', []) %}

Install Python pip modules:
    pip.installed:
    - pkgs: {{ args.requirements }}
    - bin_env: /usr/bin/python{{ args.version }}
    - require:
        - Install Python

{% endif %}
