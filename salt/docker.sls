python-apt:
  pkg.installed

git:
  pkg.installed

python-pip:
  pkg.installed

docker-py:
  pip.installed:
    - repo: git+https://github.com/dotcloud/docker-py.git
    - require:
      - pkg: python-pip

docker-dependencies:
   pkg.installed:
    - pkgs:
      - iptables
      - ca-certificates
      - lxc

docker_repo:
    pkgrepo.managed:
      - repo: 'deb http://get.docker.io/ubuntu docker main'
      - file: '/etc/apt/sources.list.d/docker.list'
      - key_url: salt://docker.pgp
      - require_in:
          - pkg: lxc-docker
      - require:
        - pkg: python-apt
      - require:
        - pkg: python-pip

lxc-docker:
  pkg.installed:
    - require:
      - pkg: docker-dependencies

docker:
  service.running
