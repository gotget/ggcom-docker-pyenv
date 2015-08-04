# GGCOM - Docker - pyenv v201508041108
# Louis T. Getterman IV (@LTGIV)
# www.GotGetLLC.com | www.opensour.cc/ggcom/docker/pyenv
#
# Example usage:
#
# Build
# $] docker build --tag=python .
#
# Run
# $] docker run python --version
# $] docker run --volume="HOST/PATH/PROJECT:/opt/PROJECT" python "/opt/PROJECT/run.py"
#
# Thanks:
#
# Setting up pyenv in docker
# https://gist.github.com/jprjr/7667947
#
################################################################################
FROM		ubuntu:14.04.2
MAINTAINER	GotGet, LLC <contact+docker@gotgetllc.com>

ENV			DEBIAN_FRONTEND	noninteractive

RUN			apt-get -y update && apt-get -y install \
				apt-transport-https \
				curl \
				gcc \
				git-core \
				libbz2-dev \
				libreadline-dev \
				libsqlite3-dev \
				libssl-dev \
				make \
				zlib1g-dev

RUN			adduser --disabled-password --gecos "" python_user

WORKDIR		/home/python_user
USER		python_user

ENV			HOME			/home/python_user
ENV			PYENV_ROOT		$HOME/.pyenv
ENV			PATH			$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN			curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

ADD			pycompiler.bash $HOME/pycompiler.bash
ADD			version $HOME/version
RUN			bash $HOME/pycompiler.bash $(cat $HOME/version)
RUN			rm -rf $HOME/pycompiler.bash $HOME/version

RUN			pyenv rehash

RUN			pip install --upgrade pip

ENTRYPOINT ["python"]
################################################################################
