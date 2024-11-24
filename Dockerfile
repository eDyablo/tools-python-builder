ARG CONTAINER_IMAGE_REGISTRY

FROM ${CONTAINER_IMAGE_REGISTRY:+${CONTAINER_IMAGE_REGISTRY}/}alpine:3.20.3

RUN apk add --no-cache --update \
  binutils=2.42-r0 \
  py3-pip=24.0-r2

ENV VIRTUAL_ENV=/opt/venv

RUN python -m venv ${VIRTUAL_ENV}

ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

RUN pip install --upgrade pip==24.3.1

RUN pip install \
  pyinstaller==6.11.1 \
  toml==0.10.2

WORKDIR /var/workspace

COPY get_project_dependencies.py .

ONBUILD WORKDIR /var/workspace

ONBUILD ARG SRC_DIR_PATH=.

ONBUILD COPY ${SRC_DIR_PATH} .

ONBUILD RUN pip install $(python get_project_dependencies.py)

ONBUILD ARG MAIN_SCRIPT_PATH

ONBUILD RUN pyinstaller --onefile ${MAIN_SCRIPT_PATH}
