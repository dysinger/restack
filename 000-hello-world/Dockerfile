FROM debian:10 as build

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade
RUN apt-get -y install apt-transport-https curl gnupg wget
RUN update-ca-certificates

ARG OCAML=4.08.1
ENV OPAMYES=1
RUN apt-get -y install \
    bzip2 g++ git make m4 pkg-config rsync unzip xz-utils mercurial darcs
RUN curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh \
  | sed 's/read BINDIR/BINDIR=\/usr\/local\/bin/g' | bash
RUN opam init --compiler=${OCAML} --auto-setup --disable-sandboxing

RUN eval $(opam env) && opam install mirage mirage-unix opam-depext
ADD ./ /src
WORKDIR /src
RUN eval $(opam env) && mirage configure -t unix
RUN eval $(opam env) && make depend
RUN eval $(opam env) && make

FROM debian:10 as deploy
COPY --from=build /src/_build/main.native /bin/hello
ENTRYPOINT /bin/hello
