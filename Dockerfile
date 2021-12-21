FROM python:3.8.12-slim-bullseye

ARG with_models=false

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
  && apt-get -qqq install --no-install-recommends -y libicu-dev pkg-config libxml2-dev libxslt-dev gcc g++ python3-pyqt5 \
  && apt-get clean \
  && rm -rf /var/lib/apt

RUN pip install --upgrade pip
RUN pip install PyQt5==5.15.6

COPY . .

# check for offline build
RUN if [ "$with_models" = "true" ]; then  \
        # install only the dependencies first
        pip install -e .;  \
        # initialize the language models
        ./install_models.py;  \
    fi

# Install package from source code
RUN pip install . \
  && pip cache purge

EXPOSE 5000
ENTRYPOINT [ "libretranslate", "--host", "0.0.0.0" ]
