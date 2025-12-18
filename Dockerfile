# ---------- Base ----------
FROM node:22.18.0-alpine AS base
WORKDIR /app

# ---------- Dependencies ----------
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# ---------- Build ----------
COPY . .
RUN npm run build

# ---------- Runtime ----------
FROM node:22.18.0-alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=9000

COPY --from=base /app /app

EXPOSE 9000

CMD ["npm", "run", "start"]
