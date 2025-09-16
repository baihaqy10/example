FROM golang:1.23 AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod tidy

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server .

FROM gcr.io/distroless/base-debian12:nonroot
WORKDIR /app

COPY --from=builder /app/server .
COPY --from=builder /app/templates ./templates
COPY --from=builder /app/static ./static

USER root
RUN chmod +x /app/server
USER nonroot:nonroot

EXPOSE 8080
ENTRYPOINT ["/app/server"]
