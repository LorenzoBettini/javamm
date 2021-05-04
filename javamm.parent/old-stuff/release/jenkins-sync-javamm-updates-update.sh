#! /bin/bash

rsync $@ -azv -c -e ssh --delete lbettini,javamm@frs.sourceforge.net:/home/frs/project/javamm/updates/releases/ $HOME/p2.repositories/javamm/
