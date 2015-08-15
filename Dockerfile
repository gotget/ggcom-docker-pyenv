# GGCOM - Docker - pyenv v201508140234
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
FROM		ubuntu:latest
MAINTAINER	GotGet, LLC <contact+docker@gotgetllc.com>

# Initial prerequisites for installing pyenv
USER		root
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

# Create a user and reciprocal environment variables
RUN			adduser --disabled-password --gecos "" python_user
USER		python_user

# Set environment variables
ENV			HOME			/home/python_user
ENV			PYENV_ROOT		$HOME/.pyenv
ENV			PATH			$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Install pyenv
WORKDIR		$HOME
RUN			curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

# Create source directory to work out of
RUN			mkdir -pv $HOME/src/

ADD			pycompiler.bash $HOME/src/pycompiler.bash
ADD			version $HOME/src/version
RUN			bash $HOME/src/pycompiler.bash $(cat $HOME/src/version)
################################################################################
USER		root

# Clean-up after ourselves
RUN			apt-get -y purge \
				build-essential \
				gcc \
				git \
				make \
				pkg-config
RUN			apt-get -y autoremove

# Delete specific targets
RUN			rm -rf $HOME/src/ $HOME/.cache/pip/ /tmp/*

# Delete all Git directories
RUN			find / -type d -name .git -print0 | xargs -0 rm -rf

# Delete all Python byte code
#RUN			find / -type f -name *.pyc -print0 | xargs -0 rm -rf # Holding off on this, for now.

# Return to home
WORKDIR		$HOME
################################################################################
ADD			init.bash /root/init.bash
RUN			chmod 750 /root/init.bash
ENTRYPOINT	[ "/bin/bash", "/root/init.bash" ]
################################################################################
