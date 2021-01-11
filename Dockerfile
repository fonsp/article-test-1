FROM julia:1.5

ENV USER fonsi
ENV USER_HOME_DIR /home/${USER}
ENV JULIA_DEPOT_PATH ${USER_HOME_DIR}/.julia
ENV NOTEBOOK_DIR ${USER_HOME_DIR}/notebooks
ENV JULIA_NUM_THREADS 100

RUN useradd -m -d ${USER_HOME_DIR} ${USER} \
    && mkdir -p ${NOTEBOOK_DIR}

COPY startup.jl ${USER_HOME_DIR}/

RUN julia -e "using Pkg; Pkg.add([Pkg.PackageSpec(name=\"Pluto\", rev=\"9edb7b2\"), Pkg.PackageSpec(url=\"https://github.com/fonsp/PlutoBindServer.jl\", rev=\"4e06d39\")]); Pkg.instantiate(); Pkg.precompile();" \
    && chown -R ${USER} ${USER_HOME_DIR}
USER ${USER}

EXPOSE 3456
VOLUME ${NOTEBOOK_DIR}
WORKDIR ${NOTEBOOK_DIR}

CMD [ "julia", "/home/fonsi/bindserver.jl" ]