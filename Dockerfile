# 3.7.6-slim ; We're pinning to a digest in order
FROM python:3.8.6-slim@sha256:8dab48a48334878a58fd7898e636eb1f964b8bba1ca79f29f9c9ceddd9b3d198 AS requirements_and_package_caching_image

# Setup Docker initial values
# Python path to execute the estimators
ENV PYTHONPATH=/usr/src/app

# Install all dependencies, cmake and git needed for h3 - Put all the execution
# In one layer
RUN apt-get update && apt-get -y install cmake git build-essential curl \
    autoconf automake libtool python-dev libsasl2-dev gcc pkg-config python3-tk tk && \
    # Add update for pip to have the latest package DB
    python -m pip install --upgrade pip

# Add Poetry install
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
ENV POETRY=/root/.poetry/bin/poetry

# Setup the Execution Dir and Estimator name
WORKDIR /usr/src/app

# ENV PYTHONPATH=${PYTHONPATH}:/usr/src/app/corelib/src
COPY . /usr/src/app

# Execute Poetry
RUN $POETRY config virtualenvs.create false && $POETRY install

# Expose port and setup Entrypoint for Docker Image
EXPOSE 8080 8888

RUN apt-get -y install htop