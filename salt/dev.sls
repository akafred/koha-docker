installdev:
  pkg.installed:
    - pkgs:
      - libvte9
      - lxterminal
      - geany

/home/vagrant/projects:
  file.symlink:
    - target: /vagrant/projects
    - user: vagrant
    - group: vagrant
