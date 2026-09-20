# ---------- Stage 1: install production dependencies ----------
FROM node:22-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
# npm ci = exact, reproducible install from the lock file; --omit=dev skips dev tooling
RUN npm ci --omit=dev

# ---------- Stage 2: small runtime image ----------
FROM node:22-alpine
ENV NODE_ENV=production
WORKDIR /app

# Copy only what is needed to run: dependencies from stage 1 + app code.
# (npm cache and install tooling stay behind in stage 1.)
COPY --from=deps /app/node_modules ./node_modules
COPY package.json server.js ./

# Never run as root inside the container
USER node

EXPOSE 3000
CMD ["node", "server.js"]
