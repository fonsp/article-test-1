FROM julia:1.5
ENV JULIA_NUM_THREADS 100


RUN pwd
RUN ls -lha
RUN echo "I hate Docker"

ENV USER fonsi
ENV USER_HOME_DIR /home/${USER}
ENV JULIA_DEPOT_PATH ${USER_HOME_DIR}/.julia
ENV REPO_DIR ${USER_HOME_DIR}/project

RUN useradd -m -d ${USER_HOME_DIR} ${USER} \
    && mkdir -p ${REPO_DIR}

COPY . ${REPO_DIR}/

RUN julia -e "using Pkg; Pkg.add([Pkg.PackageSpec(name=\"Pluto\", rev=\"9edb7b2\"), Pkg.PackageSpec(url=\"https://github.com/fonsp/PlutoBindServer.jl\", rev=\"cabea1c\")]); Pkg.instantiate(); Pkg.precompile();" \
    && chown -R ${USER} ${USER_HOME_DIR}
USER ${USER}

EXPOSE 3456
WORKDIR ${REPO_DIR}

RUN pwd
RUN ls -lha

CMD [ "julia", "bindserver.jl" ]