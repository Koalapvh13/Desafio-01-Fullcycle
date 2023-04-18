FROM golang:1.20 AS builder

WORKDIR /usr/src/app

ENV CGO_ENABLED=0

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod ./
RUN go mod download && go mod verify

ENV GOOS=linux

COPY . .
RUN go build -v -o ./fullcycle


FROM scratch AS prod
WORKDIR /app
COPY --from=builder /usr/src/app/fullcycle .
# RUN chmod -R a+x .
CMD ["./fullcycle"]