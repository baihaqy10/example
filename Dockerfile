FROM golang:1.23 AS builder
WORKDIR /app
COPY app/ .
RUN go mod init contoh-deployment && go mod tidy
RUN go build -o server .

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/server .
COPY --from=builder /app/templates ./templates
COPY --from=builder /app/static ./static
EXPOSE 8080
CMD ["./server"]