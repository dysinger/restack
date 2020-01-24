FROM alpine:3.11 as build

RUN apk add --update \
    ocaml ocaml-compiler-libs ocaml-ocamldoc ocaml-findlib opam \
    make m4 musl-dev
ENV OPAMYES=1
RUN opam init --auto-setup --disable-sandboxing
RUN eval $(opam env) && opam install opam-depext
RUN eval $(opam env) && opam depext  mirage mirage-unix
RUN eval $(opam env) && opam install mirage mirage-unix

ADD ./ /src
WORKDIR /src
RUN eval $(opam env) && mirage configure -t unix && make depend && make
WORKDIR /

FROM alpine:3.11 as docker
RUN apk add --update gmp
COPY --from=build /src/_build/main.native /bin/server
ENTRYPOINT /bin/server --port 8080
EXPOSE 8080

FROM build as firecracker
RUN apk add e2fsprogs
ADD https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin \
    /vmlinux.bin
ADD https://firectl-release.s3.amazonaws.com/firectl-v0.1.0 \
    /usr/local/bin/firectl
ADD https://github.com/firecracker-microvm/firecracker/releases/download/v0.20.0/firecracker-v0.20.0-x86_64 \
    /usr/local/bin/firecracker
RUN chmod 755 /usr/local/bin/*
VOLUME /drop
