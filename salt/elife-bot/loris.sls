# most recent guide: https://stkenny.github.io/iiif/loris/2016/10/03/loris_install/
# 1. Requirements
# checkout git@github.com:loris-imageserver/loris.git
# elife:elife on /opt/loris
# git@github.com:loris-imageserver/loris.git
apache-packages:
    pkg.installed:
        - pkgs:
            - apache2
            - libapache2-mod-wsgi

apache-module-headers:
    apache_module.enabled:
        - name: headers
        - require:
            - apache-packages

apache-module-expires:
    apache_module.enabled:
        - name: expires
        - require:
            - apache-packages

apache-module-wsgi:
    apache_module.enabled:
        - name: wsgi
        - require:
            - apache-packages

apache-default-site:
    apache_site.disabled:
        - name: 000-default

apache-loris-site:
    file.managed:
        - name: /etc/apache2/sites-enabled/loris.conf
        - source: salt://elife-bot/config/etc-apache2-sites-enabled-loris.conf
        - require:
            - apache-packages

apache-ready:
    service.running:
        - name: apache2
        - enable: True
        - reload: True
        - require:
            - apache-module-expires
            - apache-module-headers
            - apache-module-wsgi
            - apache-default-site
            - apache-loris-site

loris-repository:
    git.latest:
        - name: git@github.com:loris-imageserver/loris.git
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - rev: v2.1.0-final
        - force_fetch: True
        - force_checkout: True
        - force_reset: True
        - target: /opt/loris

    file.directory:
        - name: /opt/loris
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - recurse:
            - user
            - group
        - require:
            - git: loris-repository

    virtualenv.managed:
        - name: /opt/loris/venv
        - user: {{ pillar.elife.deploy_user.username }}
        - python: /usr/bin/python2.7

loris-dependencies:
    pkg.installed:
        - pkgs:
            - libjpeg8
            - libjpeg8-dev
            - libfreetype6
            - libfreetype6-dev
            - zlib1g-dev
            - liblcms
            - liblcms-dev
            - liblcms-utils
            - libtiff4-dev

    cmd.run:
        - name: |
            echo "don't do anything for now"
            #venv/bin/pip install Werkzeug
            # my assumption:
            # needs to be recompiled after the libraries are installed
            #venv/bin/pip install --no-binary :all: Pillow
            # for some reason setup.py is not capable of installing it
            # by itself and crashes
            #venv/bin/pip install configobj
        - cwd: /opt/loris
        - user: {{ pillar.elife.deploy_user.username }}
        - require:
            - loris-repository
            - pkg: loris-dependencies

kakadu-library:
# 2. Loris dependencies
    cmd.run:
        - name: |
            wget http://kakadusoftware.com/wp-content/uploads/2014/06/KDU79_Demo_Apps_for_Linux-x86-64_170108.zip
            unzip -o KDU79_Demo_Apps_for_Linux-x86-64_170108.zip
        - cwd: /opt
        # check with: /usr/local/bin/kdu_expand -v

loris-user:
    user.present: 
        - name: loris
        - shell: /sbin/false
        - home: /var/www/loris2

loris-images-folder:
    file.directory:
        - name: /usr/local/share/images
        - user: loris

loris-image-examples:
    cmd.run:
        - name: cp -R tests/img/* /usr/local/share/images
        - cwd: /opt/loris
        - require:
            - loris-images-folder

# only runs on second time?
# has to be run multiple times, unclear what it's doing
# add requires, experiment
loris-setup:
    cmd.run:
        - name: |
            venv/bin/python setup.py install
            /etc/init.d/apache2 restart
        - env:
            - LD_LIBRARY_PATH: '/opt/KDU79_Demo_Apps_for_Linux-x86-64_170108'
        - user: root
        - cwd: /opt/loris
        - require:
            - apache-ready
            - loris-dependencies
            - loris-user
            - kakadu-library
        






