# build
FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod ./
# COPY go.sum ./
RUN go mod download
COPY . .
RUN go build -o main .

# final
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .

EXPOSE 4444

CMD ["./main"]
