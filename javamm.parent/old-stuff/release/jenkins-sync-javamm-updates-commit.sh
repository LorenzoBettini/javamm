#! /bin/bash

rsync $@ -azv -c --delete -e ssh $HOME/p2.repositories/javamm/ lbettini,javamm@frs.sourceforge.net:/home/frs/project/javamm/updates/releases
