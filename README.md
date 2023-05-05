# keystore-generator

## Synopsis

Generates a client and server java keystore that is used to provide client SSL authentication for [Senzing API Server](https://github.com/Senzing/senzing-api-server) and [Senzing POC Server](https://github.com/Senzing/senzing-poc-server).

## Overview

The [keystore-generator.py](keystore-generator.py) python script is a "run-to-completion" job that generates a client and server java keystore in a stipulated folder.

The `senzing/kenstore-generator` Docker image is a wrapper for use in Docker formations (e.g. docker-compose, kubernetes).

To see all of the subcommands, run:

```console
$ ./keystore-generator.py
usage: keystore-generator.py [-h] {aws,sleep,version,docker-acceptance-test} ...

Initialize Senzing installation. For more information, see https://github.com/Senzing/keystore-generator

positional arguments: {aws,sleep,version,docker-acceptance-test}
Subcommands (SENZING_SUBCOMMAND):
    aws                 Create a keystore for AWS
    sleep               Do nothing but sleep. For Docker testing.
    version             Print version of program.
    docker-acceptance-test
                        For Docker acceptance testing.

optional arguments:
  -h, --help            show this help message and exit
```

### Contents

1. [Preamble](#preamble)
    1. [Legend](#legend)
1. [Expectations](#expectations)
1. [Demonstrate using Docker](#demonstrate-using-docker)
1. [Demonstrate using docker-compose](#demonstrate-using-docker-compose)
1. [Configuration](#configuration)
1. [License](#license)
1. [References](#references)

## Preamble

At [Senzing](http://senzing.com),
we strive to create GitHub documentation in a
"[don't make me think](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/dont-make-me-think.md)" style.
For the most part, instructions are copy and paste.
Whenever thinking is needed, it's marked with a "thinking" icon :thinking:.
Whenever customization is needed, it's marked with a "pencil" icon :pencil2:.
If the instructions are not clear, please let us know by opening a new
[Documentation issue](https://github.com/Senzing/keystore-generator/issues/new?template=documentation_request.md)
describing where we can improve.   Now on with the show...

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps there are some choices to be made.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 15 minutes to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/docker.md)

## Demonstrate using Docker

1. :pencil2: Specify the subcommand
   Example:

    ```console
    export SENZING_SUBCOMMAND=aws
    ```

1. Run Docker container.
   Example:

    ```console
    sudo --preserve-env docker run \
      --env SENZING_SUBCOMMAND \
      --rm \
      senzing/keystore-generator
    ```

## Demonstrate using docker-compose

1. :pencil2: Specify a new directory to hold demonstration artifacts on the local host.
   Example:

    ```console
    export SENZING_VOLUME=~/my-senzing
    ```

    1. :warning:
       **macOS** - [File sharing](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/share-directories-with-docker.md#macos)
       must be enabled for `SENZING_VOLUME`.
    1. :warning:
       **Windows** - [File sharing](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/share-directories-with-docker.md#windows)
       must be enabled for `SENZING_VOLUME`.

1. Set environment variables.
   Example:

    ```console
    export SENZING_ETC_DIR=${SENZING_VOLUME}/etc
    ```

1. Create directories.
   Example:

    ```console
    mkdir -p ${SENZING_ETC_DIR}
    ```

1. :pencil2: Specify environment...
   Example:

    ```console
    export SENZING_SUBCOMMAND=aws
    ```

1. Get versions of Docker images.
   Example:

    ```console
    curl -X GET \
        --output ${SENZING_VOLUME}/docker-versions-stable.sh \
        https://raw.githubusercontent.com/Senzing/knowledge-base/main/lists/docker-versions-stable.sh
    source ${SENZING_VOLUME}/docker-versions-stable.sh
    ```

1. Download `docker-compose.yaml` and Docker images.
   Example:

    ```console
    curl -X GET \
        --output ${SENZING_VOLUME}/docker-compose.yaml \
        "https://raw.githubusercontent.com/Senzing/keystore-generator/main/docker-compose.yaml"
    cd ${SENZING_VOLUME}
    sudo --preserve-env docker-compose pull
    ```

1. Bring up Senzing docker-compose stack.
   Example:

    ```console
    cd ${SENZING_VOLUME}
    sudo --preserve-env docker-compose up
    ```

1. Allow time for the components to be downloaded, start, and initialize.
    1. There will be errors in some Docker logs as they wait for dependent services to become available.
       `docker-compose` isn't the best at orchestrating Docker container dependencies.

## Configuration

Configuration values specified by environment variable or command line parameter.

- **[SENZING_DATABASE_URL](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_database_url)**
- **[SENZING_DEBUG](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_debug)**
- **[SENZING_ENGINE_CONFIGURATION_JSON](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_engine-configuration_json)**

## License

View
[license information](https://senzing.com/end-user-license-agreement/)
for the software container in this Docker image.
Note that this license does not permit further distribution.

This Docker image may also contain software from the
[Senzing GitHub community](https://github.com/Senzing/)
under the
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

Further, as with all Docker images,
this likely also contains other software which may be under other licenses
(such as Bash, etc. from the base distribution,
along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage,
it is the image user's responsibility to ensure that any use of this image complies
with any relevant licenses for all software contained within.

## References

1. [Development](docs/development.md)
1. [Errors](docs/errors.md)
1. [Examples](docs/examples.md)
1. Related artifacts:
    1. [DockerHub](https://hub.docker.com/r/senzing/keystore-generator)
    1. [Helm Chart](https://github.com/Senzing/charts/tree/main/charts/senzing-keystore-generator)
