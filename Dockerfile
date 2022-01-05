FROM python:3.8.12-slim-bullseye

ARG with_models=false

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
  && apt-get -qqq install --no-install-recommends -y libicu-dev pkg-config libxml2-dev libxslt-dev gcc g++ git \
  && apt-get clean \
  && rm -rf /var/lib/apt

RUN pip install --upgrade pip
RUN pip install ctranslate2==2.10.1

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
