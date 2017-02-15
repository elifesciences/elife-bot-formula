# download Jetty and decompress it in /opt/jetty
jetty-installation:
    cmd.run:
        - name: |
            wget -c http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.1.v20170120/jetty-distribution-9.4.1.v20170120.tar.gz
            tar xvzf jetty-distribution-9.4.1.v20170120.tar.gz
            mkdir -p jetty
            mv jetty-distribution-9.4.1.v20170120/* jetty
            rm -r jetty-distribution-9.4.1.v20170120/
        - cwd: /opt

    file.managed:
        - name: /etc/init/jetty.conf
        - source: salt://elife-bot/config/etc-init-jetty.conf
        - template: jinja
        - require:
            - cmd: jetty-installation

    service.running:
        - name: jetty
        - restart: True
        - require:
            - file: jetty-installation

# download digilib, decompress it in /opt/jetty/webapps
digilib-installation:
    # resolved https://downloads.sourceforge.net/project/digilib/releases/2.5/digilib-webapp-2.5.1-srv3.war?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fdigilib%2Ffiles%2F&ts=1487167351
    cmd.run:
        - name: |
            mkdir -p digilib
            rm -f digilib-webapp-2.5.1-srv3.war*
            wget -o digilib-webapp-2.5.1-srv3.war https://netix.dl.sourceforge.net/project/digilib/releases/2.5/digilib-webapp-2.5.1-srv3.war
            unzip digilib-webapp-2.5.1-srv3.war -d digilib
            mkdir -p /opt/jetty/webapps/digilib
            mv digilib/* /opt/jetty/webapps/digilib
        - require:
            - jetty-installation

digilib-ready:
    cmd.run:
        - name: |
            curl -v http://localhost:8080/digilib
        - require:
            - digilib-installation

# TODO: unless conditions to speed up idempotence
# TODO: file.managed on digilib-config.xml, to specify with pillar the directory
