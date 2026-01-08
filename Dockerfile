# Estágio de compilação (Builder)
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copia os arquivos de definição de dependências
COPY go.mod go.sum ./

# Baixa as dependências
RUN go mod download

# Copia o código fonte restante
COPY . .

# Compila o binário estático
RUN CGO_ENABLED=0 GOOS=linux go build -o evaluation-service .

# Estágio final (Imagem leve)
FROM alpine:latest

WORKDIR /app

# Copia o binário compilado do estágio anterior
COPY --from=builder /app/evaluation-service .

# Expõe a porta do serviço (conforme README)
EXPOSE 8004

# Comando para rodar o serviço
CMD ["./evaluation-service"]