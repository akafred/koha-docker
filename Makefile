
all: reload provision

reload: halt up

halt:
	vagrant halt

up:
	vagrant up

# should run vagrant provison but that would take longer as it reinstalls(?) salt
provision:
	vagrant ssh -c 'sudo salt-call --log-level debug --local state.highstate'

clean:
	vagrant destroy --force

sublime:
	vagrant ssh -c 'subl "/vagrant" > subl.log 2> subl.err < /dev/null' &

geany:
	vagrant ssh -c 'geany > geany.log 2> geany.err < /dev/null' &

firefox:
	vagrant ssh -c 'firefox > firefox.log 2> firefox.err < /dev/null' &
