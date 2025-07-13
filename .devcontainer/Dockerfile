ARG SWIFT_VERSION=6.1.0

FROM swift:${SWIFT_VERSION}

ARG USERNAME=vscode
ARG GROUPNAME=vscode
ARG UID=2000
ARG GID=2000

RUN groupadd -g $GID $GROUPNAME
RUN useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

USER vscode
WORKDIR /home/vscode/app