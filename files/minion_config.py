# -*- coding: utf-8 -*-
'''
Minion specific pillars from configuration file
'''

from __future__ import absolute_import

# Import libs
import logging
import yaml
from salt.utils import fopen
import os.path

# Set up logging
log = logging.getLogger(__name__)

DEFAULT_CLUSTER_ID = "UNKNOWN"
env_maps = {    'DEV2':'DEV2',
                'QA2':'QA2',
           }

def include_pillar_file(pillar_file_path, pillar_data):
    if os.path.isfile(pillar_file_path):
      try:
         with fopen(pillar_file_path, 'r') as cluster_config:
            pillar_data.update(yaml.safe_load(cluster_config))
      except Exception:
         log.critical('Failed to load yaml from {0}.'.format(pillar_file_path))
    return pillar_data


def ext_pillar(minion_id,
               pillar,
               config_file='/srv/salt/ext/pillar/minions.conf'):
               #config_file='/etc/salt/minions.conf'):
    '''
    Load the yaml config and return minion specific configurations.
    '''

    try:
        with fopen(config_file, 'r') as config:
            all_dict = yaml.safe_load(config)
    except Exception:
        log.critical('Failed to load yaml from {0}.'.format(config_file))
        return {}

    pillar_dict = all_dict.get(minion_id, {})
    

    env_name = pillar_dict['env']
    try:
        std_env_name = env_maps[env_name.upper()]
    except Exception:
        std_env_name = env_name
        log.critical('Failed to get std env name, so assigning env. name')
    pillar_dict['stdenv'] = std_env_name

    cluster_id = pillar_dict.get('cluster',DEFAULT_CLUSTER_ID).lower()
    machine_id = minion_id.lower()

    saltenv = __opts__.get('environment','base')
    if not saltenv:
        saltenv = 'base'
    pillar_roots = __opts__['pillar_roots'][saltenv]

    # Look for node specific and cluster specific pillar files in all pillar roots
    for pillar_root in pillar_roots:
        pillar_dict = include_pillar_file('{0}/environments/{1}.sls'.format(pillar_root, env_name), pillar_dict)
        pillar_dict = include_pillar_file('{0}/clusters/{1}.sls'.format(pillar_root, cluster_id), pillar_dict)
        pillar_dict = include_pillar_file('{0}/machines/{1}.sls'.format(pillar_root, machine_id), pillar_dict)

    return pillar_dict

