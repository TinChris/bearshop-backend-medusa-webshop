# ---------- Build stage ----------
FROM node:22.18.0-alpine AS build
WORKDIR /app

# Install ALL deps (incl. dev) so TypeScript/ts-node exist during build
COPY package.json package-lock.json ./
ENV NODE_ENV=development
RUN npm ci

# Build
COPY . .
RUN npm run build

# ---------- Runtime stage ----------
FROM node:22.18.0-alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=9000

# Install ONLY prod deps
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copy the built app (and other needed files)
COPY --from=build /app /app

EXPOSE 9000
CMD ["npm", "run", "start"]


