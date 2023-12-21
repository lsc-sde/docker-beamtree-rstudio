# Custom RStudio notebook for LANDER
ARG OWNER=vvcb
ARG BASE_CONTAINER=crlander.azurecr.io/vvcb/beamtree-rstudio:0.1.0
FROM $BASE_CONTAINER

LABEL maintainer="vvcb"


# RUN mamba install --yes conda-build \
#     && conda skeleton cran r-encryptr \
#     && conda-build --dirty --no-activate --build-only r-encryptr \
#     && conda install  --no-deps --use-local r-encryptr \
#     && rm -Rf ./r-encryptr

COPY environment.yml environment.yml

RUN mamba env update --file ./environment.yml \
    && mamba clean --all -f -y \
    && rm ./environment.yml

COPY r-encryptr-0.1.3-r35h142f84f_0.tar.bz2 r-encryptr-0.1.3-r35h142f84f_0.tar.bz2

RUN mamba install r-encryptr-0.1.3-r35h142f84f_0.tar.bz2 \
    && mamba clean --all -f -y \
    && rm ./r-encryptr-0.1.3-r35h142f84f_0.tar.bz2 


USER root
# RUN apt update \
#     && apt install --yes gdebi-core \
#     && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb \
#     && dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb \
#     && wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-2022.07.1-554-amd64.deb \
#     && gdebi -n rstudio-server-2022.07.1-554-amd64.deb \
#     && rm rstudio-server-2022.07.1-554-amd64.deb
# Todo: Ensure this next layer is safe
# 2022-11-22 this step throws errors
# RUN chown -R ${NB_USER} /var/log/rstudio-server \
#     && chown -R ${NB_USER} /var/lib/rstudio-server \
#     && echo server-user=${NB_USER} > /etc/rstudio/rserver.conf
# ENV PATH=$PATH:/usr/lib/rstudio-server/bin
# ENV RSESSION_PROXY_RSTUDIO_1_4=True
RUN fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
# Switch back to normal user. Ensure this is always the last step.
USER ${NB_USER}