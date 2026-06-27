# Build stage
FROM node:26-alpine AS builder

WORKDIR /usr/src/app

COPY src/package.json src/package-lock.json ./
RUN npm ci --omit=dev

# Final stage
FROM node:26-alpine

# Set non-root user
RUN addgroup -g 10001 appgroup && adduser -u 10001 -S appuser -G appgroup

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY src/package.json src/package-lock.json ./
COPY src/index.js ./

# Change ownership
RUN chown -R appuser:appgroup /usr/src/app

# Switch to non-root user
USER appuser

EXPOSE 3000

CMD ["node", "index.js"]
