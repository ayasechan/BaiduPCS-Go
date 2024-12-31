FROM golang:alpine as builder


ARG CGO_ENABLED=0
COPY . /src/
WORKDIR /src
RUN go build -ldflags="-s -w" -trimpath .

# FROM gcr.io/distroless/static-debian12
FROM scratch

COPY --link --from=builder /src/BaiduPCS-Go /

ENTRYPOINT [ "/BaiduPCS-Go" ]
