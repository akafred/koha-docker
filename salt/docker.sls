install_docker:
  pkg.installed:
    - pkgs:
      - docker.io
  file.symlink:
   - name: /usr/local/bin/docker
   - target: /usr/bin/docker.io
