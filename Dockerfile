# Build stage
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY src/package*.json ./
RUN npm ci --only=production

# Final stage
FROM node:20-alpine

# Set non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY src/index.js ./

# Change ownership
RUN chown -R appuser:appgroup /usr/src/app

# Switch to non-root user
USER appuser

EXPOSE 3000

CMD ["node", "index.js"]
