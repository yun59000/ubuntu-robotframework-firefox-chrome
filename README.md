Ubuntu 19.10 Robotframework Chrome Firefox
===========================

Cette image Docker, basée sur Ubuntu 18.04, permet d'exécuter des tests robotframework avec Firefox et Chrome.

Requirements
------------

- robotframework 3.1.1
- robotframework-selenium2library 3.0.0
- robotframework-seleniumlibrary 3.3.1
- selenium 3.141.0

Usage
------------

Plusieurs configurations sont disponibles.  
Il est possible d'executer les test robotframework en éditant le fichier .gitlab-ci.yml

```yaml
functional-tests:
  stage: test
  image: dockerfactory-iva.si.francetelecom.fr/ubuntu-robotframework-firefox-chrome:master
  variables:
    PIP_INDEX_URL: "https://artifactory-iva.si.francetelecom.fr/artifactory/api/pypi/pythonproxy/simple"
    PIP_EXTRA_INDEX_URL: "https://artifactory-iva.si.francetelecom.fr/artifactory/api/pypi/pythondevops/simple"
  before_script:
    - pip3 install -r requirements.txt --index-url $PIP_INDEX_URL --extra-index-url $PIP_EXTRA_INDEX_URL || true
  script:
    - /bin/bash /opt/bin/entry_point.sh TestSuite/TestSuite_A
  tags:
    - rsc
    - docker
    - shared
```

Il est également possible de synchroniser les resultats des tests avec xray en éditant le fichier .gitlab-ci.yml

```yaml
stages:
  - test
  - xray

functional-tests:
  stage: test
  image: dockerfactory-iva.si.francetelecom.fr/ubuntu-robotframework-firefox-chrome:master
  variables:
    PIP_INDEX_URL: "https://artifactory-iva.si.francetelecom.fr/artifactory/api/pypi/pythonproxy/simple"
    PIP_EXTRA_INDEX_URL: "https://artifactory-iva.si.francetelecom.fr/artifactory/api/pypi/pythondevops/simple"
  before_script:
    - pip3 install -r requirements.txt --index-url $PIP_INDEX_URL --extra-index-url $PIP_EXTRA_INDEX_URL || true
  script:
    - /bin/bash /opt/bin/entry_point.sh TestSuite/TestSuite_A
  tags:
    - rsc
    - docker
    - shared
  allow_failure: true
  artifacts:
    untracked: true
    when: always

synchronisation-xray:
  stage: xray
  image: dockerfactory-iva.si.francetelecom.fr/ubuntu-connecteur-xray:master
  script:
    - java -jar /home/PlugIn_Update_Xray.jar $JIRA_URL $JIRA_LOGIN $JIRA_MDP $CLE_PROJET "Clé Test Plan" "Nom Test Plan" $(pwd)
  tags:
    - rsc
    - docker
    - shared
  dependencies:
    - functional-tests
  when: always
```

License
-------

GNU

Author Information
------------------

Yves RICHARD __richard.yves@gmail.com__  

