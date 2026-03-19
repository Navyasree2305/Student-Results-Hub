FROM node:18-alpine

WORKDIR /app

ARG VITE_API_URL
ENV VITE_API_URL=${VITE_API_URL}
ENV NODE_OPTIONS="--max-old-space-size=1536"

# Copy package files first for better layer caching
COPY package.json package-lock.json* ./

# Install dependencies inside container (ensures Linux-compatible binaries)
RUN npm install

# Copy the rest of the source code
COPY . .

EXPOSE 2026

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "2026"]
